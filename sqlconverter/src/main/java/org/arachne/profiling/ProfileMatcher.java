package org.arachne.profiling;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Filter;
import org.apache.calcite.rel.core.Join;
import org.apache.calcite.rel.core.Project;
import org.arachne.profiling.rel.ProfileRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.*;

/**
 * 5/21/2022:
 *
 * 2/9/2022: Hi, Tapan here. The intended purpose of this class was to try to match profiles to our plan, accounting for
 * discrepancies. Now, we don't care about that since we're not relying on 3rd party profiles, and instead are collecting our own
 *
 * However, we'll still need to be able to read in cardinalities, and w/o a good Calcite system for stat estimation, we'll need
 * to just use cardinality from duckdb (although again, this can be estimated using standard DB stat keeping properties
 *   (actually not sure abt that. we don't own the data, or the compute processing, so this may prove to be a generally weirder situation)
 *
 */

public class ProfileMatcher {
    public ProfileGraph graph;
    public ProfileNode root;
    public Set<Integer> seen = new HashSet<>();

    public ProfileMatcher(ProfileGraph graph) {
        this.graph = graph;
        this.root = this.graph.root;
    }

    public void matchFromBottom(RelNode node, int ordinal, @Nullable RelNode parent) {
        if (node.getInputs().size() < 2) {
            if (node.getInputs().size() == 1) {
                RelNode child = node.getInput(0);
                matchFromBottom(child, 0, node);
            }
            return;
        }

        RelNode leftChild, rightChild;
        leftChild = node.getInput(0);
        rightChild = node.getInput(1);
        System.out.println("----------------");
        if (leftChild instanceof Project) {
            System.out.println("left child project");
        } else {
            System.out.println("left child not project");
        }

        if (rightChild instanceof Project) {
            System.out.println("right child project");
        } else {
            System.out.println("right child not project");
        }
        leftChild.getRowType().getFieldNames().forEach((s) -> System.out.print(s + ", "));
        System.out.println("");
        rightChild.getRowType().getFieldNames().forEach((s) -> System.out.print(s + ", "));
        System.out.println("");
        System.out.println("----------------");
        matchFromBottom(leftChild, 0, node);
        matchFromBottom(rightChild, 1, node);
    }

    public String getClassName(ProfileNode node) {
        switch(node.getOpName()) {
            case "WINDOW":
                return "ProfileWindow";
            case "PROJECTION":
                return "ProfileProject";
            case "UNION":
                return "ProfileUnion";
            case "FILTER":
                return "ProfileFilter";
            case "TOP_N":
            case "ORDER_BY":
            case "LIMIT":
                return "ProfileSort";
            case "SIMPLE_AGGREGATE":
            case "UNGROUPED_AGGREGATE":
            case "HASH_GROUP_BY":
            case "PERFECT_HASH_GROUP_BY":
                return "ProfileAggregate";
            case "HASH_JOIN":
            case "DELIM_JOIN":
            case "CROSS_PRODUCT":
            case "PIECEWISE_MERGE_JOIN":
                return "ProfileJoin";
            case "SEQ_SCAN":
            case "PARQUET_SCAN":
                return "ProfileTableScan";
            case "COLUMN_DATA_SCAN":
                return "ProfileValues";
            default:
                String s = new StringBuilder().append("AH FUCK NO MATCH: ").append(node.getOpName()).toString();
                System.out.println(s);
                return "";
        }
    }

    public void matchNodeProfile(RelNode node, ProfileNode profile) {
        assert node instanceof ProfileRel;
        ProfileRel pNode = (ProfileRel)node;
        pNode.setCardinality(profile.getCardinality());
        // NOTE: dont set timing--we can use timing to store the profile info for subquery times
        // pNode.setTiming(profile.getTiming());
    }

    /**
     *  We are trying to find what Calcite graph node to use to match. We want to skip filters that are "meaningless"
     *      This includes Filter ontop of Scans, as we want the "scan" cardinality to go to the TableScan, not the filter
     *      Similarly Filter on Join we want to put things on the join. We return when we believe that the node is meaningful
     *      and want to attach a cardinality to it (i.e. projection with a ROW OVER function)
     */
    private Result<ProfileRel> findNextMatchableRelNode(ProfileRel node) {
        ProfileRel currNode = node;
        Set<ProfileRel> unmatched = new HashSet<>();
        while (true) {
            String className = currNode.getRelTypeName();
            if (className.equals("ProfileProject")) {
                Project p = (Project) currNode;
                if (p.containsOver()) {
                    return new Result<>(currNode, unmatched);
                } else {
                    unmatched.add(currNode);
                    ProfileRel in = (ProfileRel) p.getInput();
                    currNode = in;
                }
            } else if (className.equals("ProfileFilter")) {
                Filter f = (Filter) currNode;
                ProfileRel in = (ProfileRel) f.getInput();
                String inputName = in.getRelTypeName();
                boolean cond = !inputName.equals("ProfileTableScan") && !inputName.equals("ProfileJoin") && !inputName.equals("ProfileCorrelate") && !inputName.equals("ProfileFilter");
                System.out.println(className + " " + inputName + " " + cond);
                if (cond) {
                    return new Result<>(currNode, unmatched);
                } else {
                    unmatched.add(currNode);
                    currNode = in;
                }
            } else {
                return new Result<>(currNode, unmatched);
            }
        }
    }

    /**
     * Comporably to above, trying to get the next profile node meaningful to match. Projections in our profile aren't
     * meaningful because they don't contain overs (those are labelled a different thing); filters similarly are only
     * worthwhile if they change cardinality, etc.
     *
     */
    private Result<ProfileNode> findNextMatchableProfileNode(ProfileNode node) {
        ProfileNode currNode = node;
        Set<ProfileNode> unmatched = new HashSet<>();
        while (true) {
            String className = getClassName(currNode);
            if (className.equals("ProfileProject")) {
                unmatched.add(currNode);
                currNode = currNode.getChild();
            } else if (className.equals("ProfileFilter")) {
                ProfileNode in = currNode.getChild();
                String inputType = getClassName(in);
                boolean cardUnchanged = Objects.equals(in.getCardinality(), currNode.getCardinality());
                System.out.println(className + " " + inputType + " " + cardUnchanged);
                if (inputType.equals("ProfileTableScan") || cardUnchanged) { // useless filter or something
                    unmatched.add(currNode);
                    currNode = currNode.getChild();
                } else {
                    return new Result<>(currNode, unmatched);
                }
            } else {
                return new Result<>(currNode, unmatched);
            }
        }
    }

    // assumes root
    public void go(RelNode node) {
        assert node instanceof ProfileRel;
        visit(node, 0, null, this.root.getChild(), null);
    }

    public void goMatchCard(ProfileRel node) throws RuntimeException {
        Set<ProfileRel> unmatched = matchCardinality(node, this.root); // stitched profile doesn't have header node, can start at root
        int left = unmatched.size();
        int iterNum = 0;
        while (left > 0) {
            // System.out.println("Left: " + left);
            Iterator<ProfileRel> iter = unmatched.iterator();
            while (iter.hasNext()) {
                ProfileRel missed = iter.next();
                ProfileRel input = (ProfileRel) missed.getInput(0); // missed is either Filter/Project, SingleRel (1 input)
                while (unmatched.contains(input)) { // go down to the closest descendant that's been matched
                    try {
                        input = (ProfileRel) input.getInput(0);
                    } catch (IndexOutOfBoundsException e) {
                        String error = "Error filling in unmatched node. Got to unmatched TableScan: " + missed;
                        throw new RuntimeException(error);
                    }
                }
                missed.setCardinality(input.getCardinality());
                iter.remove();
                left -= 1;
            }
            // System.out.println("Finished iteration: " + iterNum);
            iterNum++;
        }
    }

    private boolean willMatch(ProfileRel node, ProfileNode pNode) {
        Result<ProfileRel> relResult = findNextMatchableRelNode(node);
        Result<ProfileNode> profileResult = findNextMatchableProfileNode(pNode);
        ProfileRel currNode = relResult.result;
        ProfileNode currProfile = profileResult.result;
        String className = currNode.getRelTypeName();
        String profileOp = getClassName(currProfile);
        boolean error = (!className.equals(profileOp) && !(className.equals("ProfileProject") && profileOp.equals("ProfileWindow")));
        return !error;
    }

    public Set<ProfileRel> matchCardinality(ProfileRel node, ProfileNode pNode) throws RuntimeException {
        if (seen.contains(node.getId()))
            return new HashSet<>();

        seen.add(node.getId());
        System.out.print("------- ");
        System.out.println(pNode);
        Set<ProfileRel> unmatched = new HashSet<>();
        ProfileRel currNode = node;
        ProfileNode currProfile = pNode;

        Result<ProfileRel> relResult = findNextMatchableRelNode(currNode);
        Result<ProfileNode> profileResult = findNextMatchableProfileNode(currProfile);
        currNode = relResult.result;
        currProfile = profileResult.result;
        unmatched.addAll(relResult.unmatched);
        System.out.println(currNode);
        System.out.println(currProfile);

        String className = currNode.getRelTypeName();
        className = (className.equals("ProfileIntersect") || className.equals("ProfileMinus")) ? "ProfileJoin" : className;
        String profileOp = getClassName(currProfile);
        boolean correlate = (className.equals("ProfileCorrelate") && profileOp.equals("ProfileJoin"));
        if (!className.equals(profileOp) && !(className.equals("ProfileProject") && profileOp.equals("ProfileWindow")) && !correlate) {
            String error = "Issue matching: " + currNode + " , " + currProfile;
            throw new RuntimeException(error);
        }
        matchNodeProfile(currNode, currProfile); // copy cardinality data (not timing)
        /* System.out.println("MATCHED: " + currNode + " , " +currProfile);
        int profileInputs = currProfile.getNumChildren();
        if (currInputs != profileInputs) {
            String error = "Mismatched number of inputs: " + currNode + " , " + currProfile;
            throw new RuntimeException(error);
        }

        if (currInputs == 2) {
            ProfileRel currNodeInput1 = (ProfileRel) currNode.getInput(0);
            ProfileRel currNodeInput2 = (ProfileRel) currNode.getInput(1);
            ProfileNode currProfileChild1 = currProfile.getChild(0);
            ProfileNode currProfileChild2 = currProfile.getChild(1);

            boolean willMatch11 = willMatch(currNodeInput1, currProfileChild1);
            if (willMatch11) {
                unmatched.addAll(matchCardinality(currNodeInput1, currProfileChild1));
                unmatched.addAll(matchCardinality(currNodeInput2, currProfileChild2));
            } else {
                unmatched.addAll(matchCardinality(currNodeInput1, currProfileChild2));
                unmatched.addAll(matchCardinality(currNodeInput2, currProfileChild1));
            }
        } else {
            for (int i = 0; i < currInputs; i++) {
                ProfileRel currNodeInput = (ProfileRel) currNode.getInput(i);
                ProfileNode currProfileChild = currProfile.getChild(i);
                unmatched.addAll(matchCardinality(currNodeInput, currProfileChild));
            }
        } */

        /*
         * if the number of inputs aren't 2 then we just recurse
         * if the number of inputs are 2 then we compare the fields of the left and right input and match.
         */
        int currInputs = currNode.getInputs().size();
        if (currInputs == 2) {
            RelNode leftChild = currNode.getInput(0);
            RelNode rightChild = currNode.getInput(1);
            List<String> leftFields = leftChild.getRowType().getFieldNames();
            List<String> rightFields = rightChild.getRowType().getFieldNames();

            System.out.println("----------------");
            leftFields.forEach((s) -> System.out.print(s + ", "));
            System.out.println("");
            rightFields.forEach((s) -> System.out.print(s + ", "));
            System.out.println("");
            System.out.println("----------------");

            int reverse;
            if ((className.equals("ProfileUnion")) || (leftFields.equals(rightFields))) {
                // union or can't tell based on fields; implies that order won't be flipped (we hope)
                reverse = 0;
            } else {
                // join; it's possible that
                ProfileNode leftProfileChild = currProfile.getChild(0);
                ProfileNode rightProfileChild = currProfile.getChild(1);

                if (leftProfileChild.getExtraInfo() == null || rightProfileChild.getExtraInfo() == null)
                    reverse = 0;
                else {
                    leftProfileChild.getExtraInfo().forEach((s) -> System.out.print(s + ", "));
                    System.out.println("");
                    rightProfileChild.getExtraInfo().forEach((s) -> System.out.print(s + ", "));
                    System.out.println("");
                    System.out.println("----------------");

                    if (leftProfileChild.getExtraInfo().equals(leftFields) || rightProfileChild.getExtraInfo().equals(rightFields)) {
                        System.out.println("left child matched left profile node");
                        reverse = 0;
                    } else if (leftProfileChild.getExtraInfo().equals(rightFields) || rightProfileChild.getExtraInfo().equals(leftFields)) {
                        System.out.println("left child matched right profile node; reversing");
                        reverse = 1;
                    } else {
                        // left child doesn't match either left or right
                        System.out.println("Left child doesn't match left or right profile node; defaulting to plain order");
                        reverse = 0;
                    }
                }
            }
            for (int i = 0; i < currInputs; i++) {
                int j = Math.abs(i - reverse);
                System.out.println("indices " + i + " " + j);
                ProfileRel currNodeInput = (ProfileRel) currNode.getInput(i);
                ProfileNode currProfileChild = currProfile.getChild(j);
                unmatched.addAll(matchCardinality(currNodeInput, currProfileChild));
            }

        } else {
            // currInputs <= 1
            System.out.println("hi");
            for (int i = 0; i < currInputs; i++) {
                ProfileRel currNodeInput = (ProfileRel) currNode.getInput(i);
                ProfileNode currProfileChild = currProfile.getChild(i);
                unmatched.addAll(matchCardinality(currNodeInput, currProfileChild));
            }
        }

        // for (int i = 0; i < currInputs; i++) {
        //     ProfileRel currNodeInput = (ProfileRel) currNode.getInput(i);
        //     ProfileNode currProfileChild = currProfile.getChild(i);
        //     unmatched.addAll(matchCardinality(currNodeInput, currProfileChild));
        // }
        return unmatched;
    }

    public void visit(RelNode node, int ordinal, @Nullable RelNode parent, ProfileNode pNode, @Nullable ProfileNode pParent) {
        // keeps track of what nodes we've seen but have not matched
        Map<String, List<RelNode>> planSeenMap = new HashMap<String, List<RelNode>>();
        Map<String, List<ProfileNode>> profileSeenMap = new HashMap<String, List<ProfileNode>>();

        // current nodes
        RelNode currNode = node;
        ProfileNode currProfile = pNode;

        int graphCounter, profileCounter; // num inputs for logical, profile graph

        // flags indicate this node has already been processed
        boolean newNode = true;
        boolean newProfile = true;
        do {
            String profileOp = getClassName(currProfile);
            String className = currNode.getRelTypeName();
            if (className.equals("ProfileProject") && ((Project)currNode).containsOver())
                className = "ProfileWindow";
            // if (profileOp.equals("WINDOW")) {
            //     System.out.println(currProfile.getDigest());
            //     System.out.println(className);
            // }
            graphCounter = currNode.getInputs().size();
            profileCounter = currProfile.getNumChildren();

            if (newNode && newProfile && profileOp.equals(className)) {
                // case where we put in seen, later match (end case). make sure to check for already matches in leftovers
                // profileMap.put(currNode, currProfile);
                matchNodeProfile(currNode, currProfile);
            } else {
                if (newNode && profileSeenMap.containsKey(className)) {
                    List<ProfileNode> matches = profileSeenMap.get(className);
                    ProfileNode match = matches.get(0);
                    if (matches.size() == 1) {
                        profileSeenMap.remove(className, matches);
                    } else {
                        matches.remove(match);
                    }
                    matchNodeProfile(currNode, match);
                } else if (newNode) {
                    planSeenMap.computeIfAbsent(className, k -> new ArrayList<>()).add(currNode);
                }

                if (newProfile && planSeenMap.containsKey(profileOp)) {
                    List<RelNode> matches = planSeenMap.get(profileOp);
                    RelNode match = matches.get(0);
                    if (matches.size() == 1) {
                        planSeenMap.remove(profileOp, matches);
                    } else {
                        matches.remove(match);
                    }
                    // profileMap.put(match, currProfile);
                    matchNodeProfile(match, currProfile);
                } else if (newProfile) {
                    profileSeenMap.computeIfAbsent(profileOp, k -> new ArrayList<>()).add(currProfile);
                }
            }

            if (graphCounter == 1) {
                currNode = currNode.getInput(0);
            } else {
                newNode = false;
            }
            if (profileCounter == 1) {
                currProfile = currProfile.getChild(0);
            } else {
                newProfile = false;
            }
        } while (graphCounter == 1 || profileCounter == 1);

        for (Map.Entry<String, List<RelNode>> e : planSeenMap.entrySet()) {
            String key = e.getKey();
            List<RelNode> leftovers = e.getValue();
            List<ProfileNode> matches = profileSeenMap.getOrDefault(key, new ArrayList<>());
            for (int i = 0; i < leftovers.size(); i++) {
                RelNode left = leftovers.get(i);
                if (((ProfileRel)left).getCardinality() != null)
                    continue;
                if (i < matches.size()) {
                    ProfileNode match = matches.get(i);
                    // profileMap.put(left, match);
                    matchNodeProfile(left, match);
                } else {
                    ProfileNode dummyMatch = new ProfileNode(0L, 0.0, left.getRelTypeName(), null);
                    // profileMap.put(left, dummyMatch);
                    matchNodeProfile(left, dummyMatch);
                }
            }
        }
        if (graphCounter == 2 && profileCounter == 2) {
            RelNode leftNode = currNode.getInput(0);
            ProfileNode leftProfile = currProfile.getChild(0);
            RelNode rightNode = currNode.getInput(1);
            ProfileNode rightProfile = currProfile.getChild(1);

            visit(leftNode, 0, currNode, leftProfile, currProfile);
            visit(rightNode, 1, currNode, rightProfile, currProfile);
        } else if (graphCounter == 0 && profileCounter == 0) {
            // terminal case
            // System.out.println("base case");
        } else {
            throw new RuntimeException("disagreement about input number between logical, profile");
        }
    }

    private class Result<T> {
        public T result;
        public Set<T> unmatched;
        public Result(T result, Set<T> unmatched) {
            this.result = result;
            this.unmatched = unmatched;
        }
    }
}
