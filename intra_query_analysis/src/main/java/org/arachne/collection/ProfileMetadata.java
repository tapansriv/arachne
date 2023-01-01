package org.arachne.collection;

import org.apache.calcite.rel.RelNode;
import org.arachne.common.QueryExecutionGraph;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.*;

public class ProfileMetadata {
    public RelNode root;
    public final Map<RelNode, ProfileInfo> metadataMap = new HashMap<>();
    private static final double OVERHEAD_THRESHOLD = 0.1f;

    public ProfileMetadata(RelNode root) { this.root = root; }

    /**
     * Assume that if there are subqueries with size > 1, they are straight line (no 2-input ops)
     * This is an important assumption, as we assume that the last op is the terminal object, i.e. the Table scan or Join
     * With initialization, plans should be split into as fine-grained pieces as possible.
     *
     * findSubQuery doesn't make this assumption, so will put nodes in the list in DFS order, but for general metadata updates
     * this ordering doesn't matter, as we make uniform decisions across all nodes. This is only in particular for initialization
     * @param node
     * @param nodeToQuery
     * @throws IllegalStateException
     */
    public void initialize(RelNode node, Map<RelNode, QueryExecutionGraph> nodeToQuery) throws IllegalStateException {
        SubQueryResult res = findSubQuery(node, null, nodeToQuery);
        List<RelNode> inSubQuery = res.inSubQuery;
        Set<RelNode> nextRoots = res.nextRoot;
        int size = inSubQuery.size();
        QueryExecutionGraph qe = nodeToQuery.get(node);
        double subQTime = qe.getRuntime();
        if (size == 1) {
            ProfileInfo pi = new ProfileInfo(qe.getRuntime(), qe.getCardinality());
            this.metadataMap.put(node, pi);
        } else if (size > 0) {
            RelNode core = inSubQuery.get(size - 1);
            ProfileInfo corePI = new ProfileInfo(qe.getRuntime(), qe.getCardinality()); // give core node all timing info
            this.metadataMap.put(core, corePI);
            for (int i = 0; i < size - 1; i++) {
                RelNode r = inSubQuery.get(i);
                // use -1 to signal in cost calculation that this is a dependent node
                ProfileInfo pi = new ProfileInfo(-1.0d, qe.getCardinality());
                this.metadataMap.put(r, pi);
            }
        } else {
            throw new IllegalStateException("subquery size is 0: " + qe);
        }
        for (RelNode nextRoot : nextRoots) {
            initialize(nextRoot, nodeToQuery);
        }
    }

    private void populate(RelNode node, Map<RelNode, QueryExecutionGraph> nodeToQuery) throws IllegalStateException {
        SubQueryResult res = findSubQuery(node, null, nodeToQuery);
        List<RelNode> inSubQuery = res.inSubQuery;
        Set<RelNode> nextRoots = res.nextRoot;
        // do stuff with inSubQ
        int size = inSubQuery.size();
        QueryExecutionGraph qe = nodeToQuery.get(node);
        double sumTime = 0;
        double subQTime = qe.getRuntime();
        for (RelNode r : inSubQuery) {
            sumTime += (metadataMap.getOrDefault(r, null) == null) ? 0 : metadataMap.get(r).timing;
        }
        if (sumTime > subQTime) {
            double overhead = sumTime - subQTime;
            if (overhead > OVERHEAD_THRESHOLD) {
                double overheadPerNode = overhead / size;
                for (RelNode r : inSubQuery) {
                    double currTime = metadataMap.get(r).timing;
                    metadataMap.get(r).timing = currTime - overheadPerNode;
                }
            }
        } else if (sumTime == subQTime) {
            // do nothing. no overhead
        } else {
            // Not sure how. Running together would have to be longer than separate, which shouldn't happen
            throw new IllegalStateException("Subquery time was greater than sum of splits, i.e. negative overhead " + qe);
        }
        for (RelNode nextRoot : nextRoots) {
            populate(nextRoot, nodeToQuery);
        }
    }

    private SubQueryResult findSubQuery(RelNode node, @Nullable RelNode parent, Map<RelNode, QueryExecutionGraph> nodeToQuery) {
        Set<RelNode> nextRoot = new HashSet<>();
        List<RelNode> inCurrentSubQuery = new ArrayList<>();
        if (nodeToQuery.containsKey(node) && parent != null) {
            nextRoot.add(node);
            return new SubQueryResult(inCurrentSubQuery, nextRoot);
        }

        inCurrentSubQuery.add(node);
        List<RelNode> inputs = node.getInputs();
        int size = inputs.size();
        for (int i = 0; i < size; i++) {
            RelNode input = inputs.get(i);
            SubQueryResult res = findSubQuery(input, node, nodeToQuery);
            inCurrentSubQuery.addAll(res.inSubQuery);
            nextRoot.addAll(res.nextRoot);
        }
        return new SubQueryResult(inCurrentSubQuery, nextRoot);
    }

    public class ProfileInfo {
        public Double timing;
        public Long cardinality;
        public ProfileInfo(Double timing, Long cardinality) {
            this.timing = timing;
            this.cardinality = cardinality;
        }
        public String toString() {
            return "|| timing: " + timing.toString() + ", card: " + cardinality.toString();
        }
    }

    public class SubQueryResult {
        public List<RelNode> inSubQuery;
        // Want this to be set in case there are common sub expressions and nodes have multiple parents.
        // Then we might get to the same root by two different paths
        public Set<RelNode> nextRoot;
        public SubQueryResult(List<RelNode> inSubQuery, Set<RelNode> nextRoot) {
            this.inSubQuery = inSubQuery;
            this.nextRoot = nextRoot;
        }
    }

}
