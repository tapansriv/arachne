package org.arachne.algorithmic_collection;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.prepare.RelOptTableImpl;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.RelWriter;
import org.apache.calcite.rel.core.Filter;
import org.apache.calcite.rel.core.Project;
import org.apache.calcite.rel.core.TableScan;
import org.apache.calcite.rel.rel2sql.RelToSqlConverter;
import org.apache.calcite.rel.type.RelDataType;
import org.apache.calcite.rel.type.RelDataTypeField;
import org.apache.calcite.rel.type.RelRecordType;
import org.apache.calcite.rex.RexInputRef;
import org.apache.calcite.sql.*;
import org.apache.calcite.tools.RuleSet;
import org.arachne.collection.ArachneRelWriter;
import org.arachne.collection.CardinalityEstimator;
import org.arachne.common.AbstractCollector;
import org.arachne.common.ColumnSizes;
import org.arachne.common.QueryExecutionGraph;
import org.arachne.execution.ArachneRelToSqlConverter;
import org.arachne.execution.ExecutionEngine;
import org.arachne.optimizer.Optimizer;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.rel.ProfileJoin;
import org.arachne.profiling.rel.ProfileProject;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.schema.ArachneTable;

import java.io.*;
import java.util.*;

public class AlgorithmicCollector extends AbstractCollector {
    public QueryMetadata qm;
    public List<ProfileRel> candidates = new ArrayList<>();
    public List<ProfileRel> testedCandidates = new ArrayList<>();
    public Map<ProfileRel, List<QueryExecutionGraph>> profileInfo = new HashMap<>();

    private Optimizer optimizer;
    private String qry;
    private RuleSet logicalRules;
    private ProfileRel originalRoot;
    private String schemaName;

    private int max_iter = 4; // TODO: decide how to choose this
    private Long startProfileTimer;
    private Long endProfileTimer;
    private Double loadTimeCost;

    private final PrintWriter pw;
    private final PrintWriter log;
    private int iteration = 0;
    private boolean iter_mode = false;
    private HashMap<String, HashMap<String, Double>> iterationInformation = null;
    private HashMap<Integer, Double> cutNoMovementMap = new HashMap<>(); // log the cost of cut but no moving

    public AlgorithmicCollector(QueryMetadata qm, Optimizer optimizer, String qry, RuleSet logicalRules,
                                ProfileRel root, String schemaName)
            throws Exception {
        this.qm = qm;
        this.optimizer = optimizer;
        this.qry = qry;
        this.logicalRules = logicalRules;
        this.originalRoot = root; // NOTE: assume root has already had cardinality data attached
        this.schemaName = schemaName;

        String filename = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + ".out";
        String logfilename = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + ".profile";
        // this.pw = new PrintWriter(filename, "UTF-8");
        // this.log = new PrintWriter(logfilename, "UTF-8");
        this.pw = new PrintWriter(new FileOutputStream(filename, true)); // append = true
        this.log = new PrintWriter(new FileOutputStream(logfilename, true)); // append = true
        this.loadTimeCost = (9.344 / 3600) * qm.cost;
        startProfileTimer = 0L;
    }

    // this is the constructor to use for one process per-iteration
    public AlgorithmicCollector(QueryMetadata qm, Optimizer optimizer, String qry, RuleSet logicalRules,
                                ProfileRel root, String schemaName, int iteration)
            throws Exception {
        this(qm, optimizer, qry, logicalRules, root, schemaName);
        this.iteration = iteration;
        this.iter_mode = true;
        if (iteration == 0) {
            iterationInformation = new HashMap<>();
        }
    }

    public QueryMetadata getQueryMetadata() { return qm; }

    public void test() throws Exception {
        addParentsAndId(this.originalRoot, null, 1);
        initializeCandidateList(this.originalRoot);
        ProfileRel cut  = findNodeById(this.originalRoot, 6);
        executeFinalHybridPlan(cut);
    }

    public void go() throws Exception {
        startProfileTimer = System.nanoTime();
        addParentsAndId(this.originalRoot, null, 1);
        initializeCandidateList(this.originalRoot);
        if (iter_mode && this.iteration > 0)
            replayPreviousCuts();
        print("START: ", originalRoot);
        if (!this.iter_mode && candidates.size() == 0) {
            System.out.println("NO NODES ELIGIBLE FOR SAVINGS");
            this.pw.println("NO NODES ELIGIBLE FOR SAVINGS");
            this.pw.flush();
            this.pw.close();
            this.log.flush();
            this.log.close();
            return;
        }

        boolean testNextCut = true;
        if (iter_mode) {
            System.out.println("trial " + iteration);
            this.pw.print("trial " + iteration + ": ");
            testNextCut = findCutByOpportunity(iteration);
            if (testNextCut) {
                // if we have another cut to test, exit normally. otherwise lets execute the final plan
                endProfileTimer = System.nanoTime();
                double profileSecs = (double)(endProfileTimer - startProfileTimer) / 1_000_000_000.0;
                this.log.println("totalProfileRuntime," + profileSecs);
                this.log.flush();
                this.log.close();
                this.pw.flush();
                this.pw.close();
                return;
            } else {
                String fname = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + ".done";
                new PrintWriter(fname, "UTF-8").close(); // ugly, but touch new file to show that we're done to script
            }
        } else {
            int i = 0;
            while (testNextCut) {
                System.out.println("trial " + i);
                this.pw.print("trial " + i + ": ");
                testNextCut = findCutByOpportunity(i);
                i++;
            }
        }

        // for (int i = 0; i < this.max_iter; i++) {
        //     System.out.println("trial " + i);
        //     this.pw.print("trial " + i + ": ");
        //     findCutByOpportunity(i);
        // }
        endProfileTimer = System.nanoTime();
        double profileSecs = (double)(endProfileTimer - startProfileTimer) / 1_000_000_000.0;

        double maxSavings = -1;
        ProfileRel maxSavingsNode = null;
        for (ProfileRel p: testedCandidates) {
            if (p.getRealSave() <= 0)
                continue;

            if (maxSavings == -1 || p.getRealSave() > maxSavings) {
                maxSavings = p.getRealSave();
                maxSavingsNode = p;
            }
        }

        this.log.println("totalProfileRuntime," + profileSecs);
        this.log.flush();
        if (maxSavingsNode == null) {
            System.out.println("FAILED TO FIND PLAN");
            this.pw.println(qm.key + ",FAILED TO FIND PLAN");
        } else {
            // found plan; chose node that had the best savings of those we profiled; now we execute the real hybrid plan
            executeFinalHybridPlan(maxSavingsNode);
            System.out.println("FOUND PLAN");
            this.pw.println(qm.key + ",FOUND PLAN");
            Double cutNoMovementCost = cutNoMovementMap.get(maxSavingsNode.getArachneID());

            System.out.println("node id: " + maxSavingsNode.getArachneID());
            System.out.println("estimated savings: $" + maxSavingsNode.getRealSave());
            System.out.println("min baseline cost: $" + qm.minBaseline());
            System.out.println("estimated cost for cut but no movement: $" + cutNoMovementCost);
        }
        this.pw.flush();
        this.pw.close();
        this.log.flush();
        this.log.close();
    }

    // is the only thing between this and the lower project a table scan
    public boolean isProjectOverScan(RelNode curr) {
        if (curr instanceof TableScan) {
            return true;
        } else if (curr instanceof Project) {
            return isProjectOverScan(((Project)curr).getInput());
        } else {
            return false;
        }
    }

    public boolean containsCandidate(ProfileRel pr) {
        for (ProfileRel p : candidates) {
            if (p.getArachneID() == pr.getArachneID()) 
                return true;
        }
        return false;
    }

    public void initializeCandidateList(ProfileRel root) {
        Stack<ProfileRel> dfs = new Stack<>();
        dfs.push((ProfileRel)root.getInput(0)); // ignore the root: making a cut there makes no sense
        while (!dfs.empty()) {
            ProfileRel curr = dfs.pop();
            if (!containsCandidate(curr)) { // if we've seen this before, we can just add the children
                double minBaseline = qm.minBaseline();

                // compute movement, size costs here.
                // define opportunity accordingly. if opp > 0, add to list of candidates
                CardinalityEstimator est = new CardinalityEstimator();
                est.computeTablesExceptId(root, curr.getArachneID());
                double readSize = est.extraSizeGB;
                double moveSize = est.extraSizeParquetGB;

                double readCost = readSize * 0.005;
                double moveCost = moveSize * qm.movement;

                double opportunity = minBaseline - readCost - moveCost - this.loadTimeCost;
                curr.setOpportunity(opportunity);

                // don't cut above joins (only cut above the projections)
                // don't include straight table scans or projections on scans: these don't make sense to check; filters over scans
                // boolean exclusionCases = (curr instanceof Join) || (curr instanceof TableScan) || (isProjectOverScan(curr));
                boolean exclusionCases = (curr instanceof TableScan) || (isProjectOverScan(curr));
                if (!exclusionCases) {
                    if (curr.getOpportunity() > 0) {
                        candidates.add(curr);
                    }
                }
            }
            for (RelNode c : curr.getInputs()) {
                dfs.push((ProfileRel) c);
            }
        }
    }

    private int addParentsAndId(ProfileRel curr, ProfileRel parent, int arachneId) {
        if (parent != null) {
            // add parent if we've not seen it before
            // TODO: could we exit early if parent has been seen before? want to prove further before I add that in
            if (curr.getParents() == null || !(curr.getParents().contains(parent))) {
                curr.addParent(parent);
            }
        }
        // give node id if one hasn't been assigned yet.
        if (curr.getArachneID() == -1) {
            curr.setArachneId(arachneId);
            arachneId++;
        }
        for (RelNode c : curr.getInputs()) {
            int ret = addParentsAndId((ProfileRel)c, curr, arachneId);
            arachneId = ret;
        }
        return arachneId;
    }

    private void replayPreviousCuts() throws Exception {
        // open file with info
        String filename = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + ".cut_info";
        try {
            FileInputStream fis = new FileInputStream(filename);
            ObjectInputStream ois = new ObjectInputStream(fis);
            iterationInformation = (HashMap<String, HashMap<String, Double>>) ois.readObject();
            Set<Map.Entry<String, HashMap<String, Double>>> keys = iterationInformation.entrySet();

            for (int i = 0; i < this.iteration; i++) {
                String key = String.valueOf(i);
                HashMap<String, Double> vals = iterationInformation.get(key);
                int check_aid = vals.get("id").intValue();
                Long card = vals.get("card").longValue();
                double realSave = vals.get("realSave");
                double totalRuntimeCost = vals.get("totalRuntimeCost");
                double cutNoMovementCost = vals.get("cutNoMovementCost");
                System.out.println("replaying trial " + key);

                System.out.println(i + ", " + check_aid);
                ProfileRel max = getAndRemoveMaxNode(); // there should always be something here since we executed it
                int aid = max.getArachneID();
                System.out.println("CHOSEN: " + aid);
                if (aid != check_aid) {
                    throw new RuntimeException("Error: the logged cut id doesn't match what we dequeued");
                }
                // update values
                max.setRealSave(realSave);
                max.setCardinality(card);
                if (totalRuntimeCost == -1) {
                    System.out.println("Failed cut");
                } else {
                    cutNoMovementMap.put(check_aid, cutNoMovementCost);
                    updateCandidates(totalRuntimeCost, realSave, max);

                    // add to tested candidates
                    testedCandidates.add(max);
                }
            }
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error when deserializing hash map");
        }
    }

    private ProfileRel getAndRemoveMaxNode() {
        double maxValue = -1;
        ProfileRel maxNode = null;

        System.out.println(candidates.size());
        for (ProfileRel p : candidates) {
            System.out.println("id: " + p.getArachneID() + ", opp: " + p.getOpportunity());
            if (p.getOpportunity() <= 0)
                continue;

            if (maxValue == -1 || p.getOpportunity() > maxValue) {
                maxValue = p.getOpportunity();
                maxNode = p;
            } else if (p.getOpportunity() == maxValue && p.getArachneID() > maxNode.getArachneID()) {
                // in case of tie, go with deepest node. This acts as a rough, easy to determine proxy for depth
                // this may not be the "deepest" node in case where p is on the CSE but maxNode is later
                // TODO: do proper ancestry check.
                maxValue = p.getOpportunity();
                maxNode = p;
            }
        }

        // if we found a node with positive opportunity, remove it from the list of candidates
        if (maxNode != null) {
            System.out.println("-------");
            System.out.println("id: " + maxNode.getArachneID() + ", opp: " + maxNode.getOpportunity());
            candidates.remove(maxNode);
        }
        return maxNode;
    }

    private ProfileRel constructTree() {
        ProfileRel pTree = null;
        try {
            SqlNode sqlTree = optimizer.parse(qry);
            SqlNode validatedSqlTree = optimizer.validate(sqlTree);
            RelNode relTree = optimizer.convert(validatedSqlTree);
            relTree = optimizer.convertLogical(relTree, logicalRules);
            pTree = optimizer.createProfile(relTree);
            addParentsAndId(pTree, null, 1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pTree;
    }

    /**
     *
     * @param i iteration number--just used for logging really
     * @return true if a cut was profiled successfully, false if not--either for execution error or because we're out of profiles
     */
    public boolean findCutByOpportunity(int i) throws Exception{
        // REMEMBER: this is getting a node from the original graph. We use the ID system to find the same node in a duplicate graph
        System.out.println("hi");
        ProfileRel max = getAndRemoveMaxNode();
        if (max == null) {
            System.out.println("no more candidates to check");
            return false;
        }

        int aid = max.getArachneID();
        ProfileRel duplicate = constructTree();
        // print("CUT: ", max);

        // make cut at id
        boolean isProfileCut = true;
        List<QueryExecutionGraph> queryList = makeCut(duplicate, aid, isProfileCut);

        // log sql executed
        try {
            int j = i+1;
            String lf = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + "_" + j + ".sql";
            PrintWriter cut = new PrintWriter(lf, "UTF-8");
            for (QueryExecutionGraph q : queryList) {
                String qry = q.getQuery() + ";";
                cut.println(qry);
            }
            cut.close();
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR IN EXECUTION. STOPPING; COULDN'T OPEN SHIT");
            this.pw.flush();
            this.pw.close();
            this.log.close();
            return false;
        }

        for (QueryExecutionGraph q : queryList) {
            System.out.println(q);
            System.out.println(q.getQuery());
        }

        // run and get timing
        String dbName = "arachne_profile.db";
        try {
            boolean real = false;
            ExecutionEngine.executeQueriesSerial(queryList, dbName, this, real);
        } catch (Exception e) {
            // Error in profiling this cut. keep profiling other cuts,
            // but do not add to tested candidates or update other values, since we just got no info from this
            max.setRealSave(0);
            logIterationForReplay(max, -1, -1);
            e.printStackTrace();
            System.out.println("ERROR IN EXECUTION. STOPPING");
            this.pw.flush();
            this.pw.close();
            this.log.close();
            return true;
        } finally {
            if (qm.source == MonetaryNodeType.GCP) {
                File f1 = new File("/mnt/disks/tpcds/" + dbName);
                File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
                f1.delete();
                f2.delete();
            }
        }
        System.out.println("FINISHED PROFILING FOR TRIAL " + i);
        for (QueryExecutionGraph q : queryList) {
            System.out.println(q);
        }

        // update information in max and in tree
        updateValues(queryList, max, duplicate); // we want to pass in root of topmost query (running in BQ) which is root of duplicated tree

        // push max onto tested list
        testedCandidates.add(max);
        profileInfo.put(max, queryList);
        return true;
    }

    public void findCutBottomUp() { return ; }

    private List<QueryExecutionGraph> makeCut(ProfileRel root, int aid, boolean isProfileCut) {
        // find where to make cut by aid
        ProfileRel cut = findNodeById(root, aid);
        if (cut == null)
            return null;

        MonetaryNodeType dest = (isProfileCut) ? qm.source : MonetaryNodeType.BQ;
        MonetaryNodeType finalDest = (isProfileCut) ? qm.source : null;

        // find common sub-expressions below aid, add to list
        List<QueryExecutionGraph> queryList = findCommonSubExpressions(cut, dest);
        int tableNum = queryList.size();

        // make cut here, add to list
        String ctasTableName = this.qm.source.getInputString() + "_table_" + this.qm.key + "_" + tableNum;
        String qry = cutGraphAtNode(cut, ctasTableName, tableNum);
        QueryExecutionGraph cutQuery = new QueryExecutionGraph(qry, ctasTableName, qm.source, dest, 0, true); // TODO num=0 is wrong. parallel wont work when impl'd
        cutQuery.root = cut;
        queryList.add(cutQuery);
        tableNum++;

        // create QueryExecutionGraph for root too
        String rootQuery = convertNodeToSQL(root, dest);
        QueryExecutionGraph rootQc = new QueryExecutionGraph(rootQuery, null, dest, finalDest, 0, true); // TODO num=0 is wrong. parallel wont work when impl'd
        rootQc.root = cut;
        queryList.add(rootQc);

        // return final query list
        return queryList;
    }

    private void executeFinalHybridPlan(ProfileRel cut) {
        // actually execute the hybrid plan
        int aid = cut.getArachneID();
        ProfileRel duplicate = constructTree();
        boolean isProfileCut = false;
        List<QueryExecutionGraph> queryList = makeCut(duplicate, aid, isProfileCut);

        String dbName = "arachne_final.db";
        try {
            boolean real = true;
            ExecutionEngine.executeQueriesSerial(queryList, dbName, this, real);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR IN EXECUTION. STOPPING");
            this.pw.flush();
            this.pw.close();
            this.log.close();
            return;
        } finally {
            if (qm.source == MonetaryNodeType.GCP) {
                File f1 = new File("/mnt/disks/tpcds/" + dbName);
                File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
                f1.delete();
                f2.delete();
            }
        }

        // cutNoHybrid doesnt make sense, last qi is BigQuery execution.
        // this is runtime for the entire hybrid execution, which is interesting
        double totalRuntime = 0;
        double totalCost = 0;
        for (QueryExecutionGraph q : queryList) {
            System.out.println(q);
            this.pw.println(q);
            totalRuntime += q.getRuntime();
            totalCost += q.cost;
        }

        Double savings = qm.minBaseline() - totalCost;
        System.out.println("node id: " + aid);
        System.out.println("hybrid cost: $" + totalCost);
        System.out.println("min baseline cost: $" + qm.minBaseline());
        System.out.println("real savings: $" + savings);

        System.out.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", MIN BASELINE: $" + qm.minBaseline());
        System.out.println("total cost: " + qm.key + "," + totalCost + ","  + qm.rCost() + "," + qm.rcCost() + "," + qm.sCost());
        System.out.println("total runtime: " + totalRuntime + "(seconds)");
        this.pw.println("total cost: " + qm.key + "," + totalCost + ","  + qm.rCost() + "," + qm.rcCost() + "," + qm.sCost());
        this.pw.flush();
    }

    private ProfileRel findNodeById(ProfileRel root, int aid) {
        Stack<ProfileRel> dfs = new Stack<>();
        dfs.push(root);
        while (!dfs.empty()) {
            ProfileRel curr = dfs.pop();
            if (curr.getArachneID() == aid)
                return curr;
            for (RelNode child : curr.getInputs()) {
                dfs.push((ProfileRel)child);
            }
        }
        return null; // didn't find node
    }

    // Utility function; finds next "meaningful" node. Currently used to detect "small" subqueries we don't want to deal with
    // Since Calcite has every table scan be a "Common sub-expression" node
    private ProfileRel findNextMatchableRelNode(ProfileRel node) {
        ProfileRel currNode = node;
        while (true) {
            String className = currNode.getRelTypeName();
            if (className.equals("ProfileProject")) {
                Project p = (Project) currNode;
                if (p.containsOver()) {
                    return currNode;
                } else {
                    ProfileRel in = (ProfileRel) p.getInput();
                    currNode = in;
                }
            } else if (className.equals("ProfileFilter")) {
                Filter f = (Filter) currNode;
                ProfileRel in = (ProfileRel) f.getInput();
                String inputName = in.getRelTypeName();
                if (!inputName.equals("ProfileTableScan") && !inputName.equals("ProfileJoin") && !inputName.equals("ProfileCorrelate")) {
                    return currNode;
                } else {
                    currNode = in;
                }
            } else {
                return currNode;
            }
        }
    }

    private List<QueryExecutionGraph> findCommonSubExpressions(ProfileRel cut, MonetaryNodeType dest) {
        List<ProfileRel> cses = new ArrayList<>();
        Stack<ProfileRel> dfs = new Stack<>();
        for (RelNode child : cut.getInputs()) {
            dfs.push((ProfileRel)child);
        }
        // dfs.push(cut);
        while (!dfs.empty()) {
            ProfileRel curr = dfs.pop();
            ProfileRel next = findNextMatchableRelNode(curr);
            if (!next.getRelTypeName().equals("ProfileTableScan")) {
                if (curr.getParents() != null && curr.getParents().size() > 1) {
                    boolean seen = false;
                    for (ProfileRel p : cses) {
                        if (p.getArachneID() == curr.getArachneID()) {
                            seen = true;
                            break;
                        }
                    }
                    if (!seen)
                        cses.add(curr);
                }
            }
            for (RelNode child : curr.getInputs()) {
                dfs.push((ProfileRel)child);
            }
        }
        int tableNum = 0;
        List<QueryExecutionGraph> ret = new ArrayList<>();
        for (ProfileRel cse : cses) {
            String ctasTableName = this.qm.source.getInputString() + "_table_" + this.qm.key + "_" + tableNum;
            String qry = cutGraphAtNode(cse, ctasTableName, tableNum);
            QueryExecutionGraph qc = new QueryExecutionGraph(qry, ctasTableName, qm.source, dest, 0, true); // TODO num=0 is wrong. parallel wont work when impl'd
            qc.root = cse;
            ret.add(qc);
            tableNum++;
        }
        return ret;
    }

    private String convertNodeToSQL(RelNode node, MonetaryNodeType type) {
        RelNode bottomRoot = node;
        node.getRowType().getFieldList().forEach((f) -> System.out.println(f.getName() + " " + f.getType().getSqlTypeName()));

        // if the cut node is a join, then the sql isn't gonna work bc it'll do select * from (...) join (...) and that will cause
        // name conflict if the inner subquery/join has duplicate field names
        // solution is to force it to be explicit by creating a dummy projection operator and then having the projection
        // add 1 extra dummy field that it's not selecting, so it forces the SQL conversion to not use the * and instead
        // fully specify the fields. It's a hack but it'll work
        if (node instanceof ProfileJoin) {
            List<RexInputRef> projects = new ArrayList<>();
            List<RelDataTypeField> fields = node.getRowType().getFieldList(); // want to pass through all the fields
            List<RelDataTypeField> dummyFields = new ArrayList<>(); // fields to add

            for (int i = 0; i < fields.size(); i++) {
                RexInputRef xi = RexInputRef.of(i, fields);
                projects.add(xi);
                dummyFields.add(fields.get(i));
            }
            dummyFields.add(fields.get(0));
            RelDataType dummyType = new RelRecordType(dummyFields);
            ProfileProject dummyRoot = ProfileProject.create(node, projects, dummyType);
            bottomRoot = dummyRoot;
        }

        SqlDialect outDialect = type.getOutputDialect();
        MonetaryLocation loc = ExecutionEngine.getLocationForType(type);
        // SqlNode sqlNode = new RelToSqlConverter(outDialect).visitRoot(node).asStatement();
        SqlNode sqlNode = new RelToSqlConverter(outDialect).visitRoot(bottomRoot).asStatement();
        String sqlQry = sqlNode.toSqlString(outDialect).getSql();
        sqlQry = ArachneRelToSqlConverter.convertQuery(sqlQry, loc, this.schemaName, true);
        return sqlQry;
    }

    private String cutGraphAtNode(ProfileRel node, String ctasTableName, int count) {
        String qryText = convertNodeToSQL(node, this.qm.source);
        String sqlQry = "CREATE TABLE " + ctasTableName + " AS " + qryText;
        RelNode temp = createTempScan(node, count);

        // print("PRIOR STATE: ", originalRoot);
        System.out.println("making cut ------------");
        System.out.println("cut id: " + node.getId() + ", arachneId: " + node.getArachneID());
        for (RelNode parent : node.getParents()) {
            ProfileRel p = (ProfileRel) parent;
            System.out.println("parent id: " + p.getId() + ", arachneId: " + p.getArachneID());
            int ordinal = getOrdinal(node, p);
            p.replaceInput(ordinal, temp);
        }
        System.out.println("made cut ------------");
        // print("CURRENT STATE: ", originalRoot);
        return sqlQry;
    }

    private int getOrdinal(ProfileRel node, ProfileRel parent) {
        int size = parent.getInputs().size();
        for (int i = 0; i < size; i++) {
            int childId = ((ProfileRel)parent.getInput(i)).getArachneID();
            if (childId == node.getArachneID()) {
                return i;
            }
        }
        return -1; // was not child of parent
    }

    private RelNode createTempScan(RelNode node, int count) {
        String tableName = qm.source.getInputString() + "_table_" + qm.key + "_" + count;
        // String schemaName = "tpcds";
        ArachneTable.Builder tblBuilder = ArachneTable.newBuilder(tableName);
        node.getRowType().getFieldList().forEach((f) -> tblBuilder.addField(f.getName(), f.getType().getSqlTypeName()));
        long rowCount = 1L;
        tblBuilder.withRowCount(rowCount); // TODO use card of input as table cardinality, handle no-match
        ArachneTable table = tblBuilder.build();
        RelOptTable relTable = RelOptTableImpl.create(null, node.getRowType(), table, ImmutableList.of(this.schemaName, tableName));
        RelNode scan = optimizer.getConverter().toRel(relTable, ImmutableList.of());
        return optimizer.createProfile(scan);
    }

    private void logIterationForReplay(ProfileRel cut, double totalRuntimeCost, double cutNoMovementCost) throws Exception {
        if (iterationInformation == null) {
            throw new RuntimeException("replay information struct not initialized");
        }
        HashMap<String, Double> cutInfo = new HashMap<>();
        cutInfo.put("id", (double)cut.getArachneID());
        cutInfo.put("realSave", cut.getRealSave());
        cutInfo.put("card", cut.getCardinality().doubleValue());
        cutInfo.put("totalRuntimeCost", totalRuntimeCost);
        cutInfo.put("cutNoMovementCost", cutNoMovementCost);
        iterationInformation.put(String.valueOf(iteration), cutInfo);
        try {
            String filename = System.getProperty("user.home") + "/arachneDB/data/" + qm.key + ".cut_info";
            FileOutputStream fos = new FileOutputStream(filename); // default mode is to overwrite not append
            ObjectOutputStream oos = new ObjectOutputStream(fos);
            oos.writeObject(iterationInformation); // only one hash map will exist in file at any point
            oos.close();
            fos.close();
        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("error serializing hashmap");
        }
    }

    /**
     *
     * @param queryList list of QueryExecutionGraph objects that were executed (passed to ExecutionEngine)
     * @param cut the node that induced the cut (we cut the edge(s) above it) to separate the graphs
     * @param root the root of the upper subgraph, which is also the root of the original duplicate graph.
     *             CANNOT BE the `originalRoot` since this is being used to calculate extra table size,
     *             and that will add the total size of the tables read by this query into that calculation,
     *             adding unfair weight to that node's opportunity
     * @throws Exception
     */
    private void updateValues(List<QueryExecutionGraph> queryList, ProfileRel cut, ProfileRel root) throws Exception {
        int size = queryList.size();
        double totalRuntime = 0;
        for (int i = 0; i < size - 1; i++) {
            QueryExecutionGraph qi = queryList.get(i);
            totalRuntime += qi.getRuntime();
        }
        double totalRuntimeCost = (totalRuntime / 3600) * qm.cost;

        double minBaseline = qm.minBaseline();
        CardinalityEstimator est = new CardinalityEstimator();
        est.computeTables(root);

        // want the output cardinality of the intermediate table that was moved,
        // which is represented by the output cardinality of the second to last query executed.
        Long t_card = queryList.get(size - 2).getCardinality();
        // double cutSize = (t_card * ColumnSizes.estimateRowSize(cut)) / 1_000_000_000.0;
        double cutSize = (t_card * ColumnSizes.estimateRowSize(cut)) / 1_073_741_824.0; // use 2^30 bytes/gb
        double cutSizeMove = (cutSize / 2.1d);

        double readSize = est.extraSizeGB + cutSize;
        double moveSize = est.extraSizeParquetGB + cutSizeMove;

        double readCost = readSize * 0.005;
        double moveCost = moveSize * qm.movement;

        double realSave = minBaseline - (totalRuntimeCost + moveCost + readCost + this.loadTimeCost);
        cut.setRealSave(realSave);
        System.out.println("cut real save: " + realSave);
        double cutNoMovement = ((totalRuntime + queryList.get(size - 1).getRuntime()) / 3600) * qm.cost + this.loadTimeCost;
        double hybridCost = totalRuntimeCost + moveCost + readCost + this.loadTimeCost;

        if (this.iter_mode) {
            logIterationForReplay(cut, totalRuntimeCost, cutNoMovement);
        }

        updateCandidates(totalRuntimeCost, realSave, cut);
        print("Post Trial :", originalRoot);

        System.out.println("estimated move size: " + moveSize + "GB");
        System.out.println("estimated BQ read size: " + readSize + "GB");
        System.out.println("estimated extra read size: " + est.extraSizeGB + "GB, estimated extra move size: " + est.extraSizeParquetGB + "GB");
        System.out.println("estimate billed runtime: " + totalRuntime + " seconds");
        System.out.println("");

        System.out.println("estimated move cost: $" +  moveCost);
        System.out.println("estimated BQ read cost: $" + readCost);
        System.out.println("estimate billed runtime cost: $" + totalRuntimeCost);
        System.out.println("");

        System.out.println("estimated savings: $" + realSave);
        System.out.println("min baseline cost: $" + minBaseline);
        System.out.println("estimated hybrid cost: $" + hybridCost);
        System.out.println("estimated cost for cut but no movement: $" + cutNoMovement);
    }

    private void updateCandidates(double totalRuntimeCost, double realSave, ProfileRel cut) {
        if (cut.getParents() != null) {
            Stack<ProfileRel> dfsUp = new Stack<>();
            for (RelNode parent : cut.getParents()) {
                ProfileRel p = (ProfileRel) parent;
                dfsUp.push(p);
            }
            while (!dfsUp.empty()) {
                ProfileRel curr = dfsUp.pop();
                if (curr.getOpportunity() > 0) {
                    double newOpp = curr.getOpportunity() - totalRuntimeCost;
                    curr.setOpportunity(newOpp);
                    if (newOpp <= 0) {
                        candidates.remove(curr);
                    }
                }

                if (curr.getParents() != null) {
                    for (RelNode parent : curr.getParents()) {
                        ProfileRel p = (ProfileRel) parent;
                        dfsUp.push(p);
                    }
                }
            }
        }

        Stack<ProfileRel> dfsDown = new Stack<>();
        for (RelNode child : cut.getInputs()) {
            ProfileRel c = (ProfileRel) child;
            dfsDown.push(c);
        }
        while (!dfsDown.empty()) {
            ProfileRel curr = dfsDown.pop();
            if (curr.getOpportunity() < realSave) {
                if (candidates.contains(curr)) {
                    candidates.remove(curr);
                }
            }

            for (RelNode child : curr.getInputs()) {
                ProfileRel c = (ProfileRel) child;
                dfsDown.push(c);
            }
        }
        // remove candidates with opp less than the real savings we've achieved
        List<ProfileRel> toRemove = new ArrayList<>();
        for (ProfileRel c: candidates) {
            if (c.getOpportunity() < realSave) {
                toRemove.add(c);
            }
        }
        for (ProfileRel c: toRemove) {
            candidates.remove(c);
        }
    }

    protected void print(String header, RelNode relTree) {
        StringWriter sw = new StringWriter();
        sw.append(header).append(":").append("\n");
        RelWriter relWriter;
        relWriter = new ArachneRelWriter(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        // if (relTree instanceof ProfileRel)
        //     relWriter = new ArachneRelWriter(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        // else
        //     relWriter = new RelWriterImpl(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        // RelWriterImpl relWriter = new RelWriterImpl(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        relTree.explain(relWriter);
        System.out.println(sw);
    }
}
