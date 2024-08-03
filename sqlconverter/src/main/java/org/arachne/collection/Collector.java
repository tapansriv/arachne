package org.arachne.collection;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.prepare.RelOptTableImpl;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.*;
import org.apache.calcite.rel.externalize.RelWriterImpl;
import org.apache.calcite.rel.rel2sql.RelToSqlConverter;
import org.apache.calcite.sql.SqlDialect;
import org.apache.calcite.sql.SqlExplainLevel;
import org.apache.calcite.sql.SqlNode;
import org.apache.calcite.sql2rel.SqlToRelConverter;
import org.apache.calcite.tools.RuleSet;
import org.arachne.algorithmic_collection.QueryMetadata;
import org.arachne.common.AbstractCollector;
import org.arachne.common.ColumnSizes;
import org.arachne.common.QueryExecutionGraph;
import org.arachne.execution.ArachneRelToSqlConverter;
import org.arachne.execution.ExecutionEngine;
import org.arachne.optimizer.Optimizer;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.ProfileGraph;
import org.arachne.profiling.ProfileMatcher;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.schema.ArachneTable;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.*;

/**
 * I apologize for the poor naming. Blame timing. This isn't related to `ProfileCollector` and is in fact a replacement
 * (Update 3/6) This is now just like the entire logic lol. It's this, and then passes to ExecutionEngine
 */
public class Collector extends AbstractCollector {
    private final Optimizer optimizer;
    private final SqlToRelConverter converter;
    private final String qry;
    private final RuleSet logicalRules;
    private final ProfileRel originalRoot;

    private final double bigQueryReadSize;
    private final double baselineRuntime;
    private final double baselineRuntimeCalcite;
    private final ProfileGraph graph;

    private final Map<RelNode, Set<Parent>> parents = new HashMap<>();
    private final List<RelNode> subExprs = new ArrayList<>();

    private int count;
    private final Queue<QueryExecutionGraph> queries = new ArrayDeque<>();
    private final List<QueryExecutionGraph> queryList = new ArrayList<>();
    private final Map<RelNode, QueryExecutionGraph> nodeToQuery = new HashMap<>();
    private final PrintWriter pw;
    private final PrintWriter log;
    public final String key;

    private final MonetaryNodeType source;
    public final double cost;
    public final double movement;

    private Long startProfileTimer;
    private Long endProfileTimer;
    public int iteration = 0;
    public QueryMetadata qm;
    private String schemaName;

    public Collector(Optimizer optimizer, String qry, RuleSet logicalRules, ProfileGraph graph,
                     ProfileRel originalRoot, double bigQueryReadSize, double baselineRuntime,
                     double baselineRuntimeCalcite, String key, MonetaryNodeType source, String schemaName,
                     double cost, double mvmt)
            throws Exception {
        this.optimizer = optimizer;
        this.converter = optimizer.getConverter();
        this.qry = qry;
        this.logicalRules = logicalRules;
        this.graph = graph;
        this.originalRoot = originalRoot;
        this.bigQueryReadSize = bigQueryReadSize;
        this.baselineRuntime = baselineRuntime;
        this.baselineRuntimeCalcite = baselineRuntimeCalcite;
        this.count = 0;
        String filename = System.getProperty("user.home") + "/arachne/data/" + key + ".out";
        String logfilename = System.getProperty("user.home") + "/arachne/data/" + key + ".profile";
        this.key = key;
        this.pw = new PrintWriter(filename, "UTF-8");
        this.log = new PrintWriter(logfilename, "UTF-8");
        this.source = source;
        this.cost = cost;
        this.movement = mvmt;
        this.schemaName = schemaName;
        this.qm = new QueryMetadata(key, bigQueryReadSize, baselineRuntime, baselineRuntimeCalcite, cost, mvmt, source);
        print("BASE", this.originalRoot);
        startProfileTimer = 0L;
    }

    public QueryMetadata getQueryMetadata() {
        return qm;
    }

    public void go() throws Exception {
        startProfileTimer = System.nanoTime();
        try {
            for (int i = 0; i < 4; i++) {
                this.iteration += 1;
                resetState();
                System.out.println("trial " + i);
                this.pw.print("trial " + i + ": ");
                ProfileRel duplicate = constructTree();
                // print("BASE", duplicate);
                // int ret = findCut(duplicate, 0, null, originalRoot, 0, i);
                int ret = findCutBFS(duplicate, 0, i);
                // NOTE: not breaking up this half into sub-qs bc they need to be moved also, which is more complicated than I want
                // List<QueryExecutionGraph> cse = foo(duplicate, this.source);
                // System.out.println("done");

                String sqlQry;
                QueryExecutionGraph qc;
                // System.out.println("---------------------");
                sqlQry = splitGraph(duplicate, this.source);
                String ctasTableName = this.source.getInputString() + "_table_" + key + "_" + count;
                qc = new QueryExecutionGraph(sqlQry, ctasTableName, this.source, this.source, ret, true);
                qc.root = duplicate;
                // qc.setCardinality(duplicate.getCardinality());
                // System.out.println("!!!!---------------------");
                // if (cse != null) {
                //     qc.setNumChildren(cse.size() + ret);
                //     queries.addAll(cse);
                //     queryList.addAll(cse);
                // }
                queries.add(qc);
                queryList.add(qc);
                this.nodeToQuery.put(originalRoot, qc);
                String dbName = "arachne" + i + ".db";

                int j = i+1;
                String lf = System.getProperty("user.home") + "/arachne/data/" + key + "_" + j + ".sql";
                PrintWriter cut = new PrintWriter(lf, "UTF-8");
                for (QueryExecutionGraph q : queryList) {
                    String qry = q.getQuery() + ";";
                    cut.println(qry);
                }
                cut.close();

                try {
                    ExecutionEngine.executeQueriesSerial(queryList, dbName, this, false);
                } catch (Exception e) {
                    e.printStackTrace();
                    System.out.println("ERROR IN EXECUTION. STOPPING");
                    this.pw.flush();
                    this.pw.close();
                    this.log.close();
                    return;
                } finally {
                    if (this.source == MonetaryNodeType.GCP) {
                        File f1 = new File("/mnt/disks/tpcds/" + dbName);
                        File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
                        f1.delete();
                        f2.delete();
                    }
                }
                System.out.println("FINISHED PROFILING FOR TRIAL " + i);
                for (QueryExecutionGraph q : queryList) {
                    // print(q.toString(), q.root);
                    // System.out.println(q.getQuery());
                    System.out.println(q);
                }
                if (ret == 0) {
                    System.out.println("FAILED TO FIND CUT; WEIRD PLACE TO BE");
                    this.pw.println("FAILED TO FIND CUT; WEIRD PLACE TO BE");
                    this.pw.flush();
                    this.pw.close();
                    this.log.flush();
                    this.log.close();
                    return;
                }
                if (processCut(ret)) {
                    this.pw.flush();
                    this.pw.close();
                    this.log.flush();
                    this.log.close();
                    return;
                }
                System.out.println("FINISHED PROCESSING FOR TRIAL " + i + " plan not found. repeating...");
            }
            endProfileTimer = System.nanoTime();
            double profileSecs = (double)(endProfileTimer - startProfileTimer) / 1_000_000_000.0;
            this.log.println("totalProfileRuntime," + profileSecs);
            this.pw.println(key + ",FAILED TO FIND PLAN");
            this.pw.flush();
            this.pw.close();
            this.log.flush();
            this.log.close();
        } catch (Exception | AssertionError e) {
            this.pw.close();
            this.log.close();
            e.printStackTrace();
            throw e;
        }
    }

    public boolean processNoCuts() throws Exception {
        double baselineCost = (bigQueryReadSize/1_000_000_000) * 0.005; // BQ cost straightup
        int numQs = queryList.size();
        QueryExecutionGraph qLast = queryList.get(numQs - 1);
        double vmRuntime = qLast.getRuntime(); // cost is just total runtime of the whole thing
        for (int i = 0; i < numQs - 1; i++) { // check for multiple qs in case of common sub-qs
            QueryExecutionGraph q = queryList.get(i);
            vmRuntime += q.getRuntime();
        }
        double arachneCost = (vmRuntime / 3600) * this.cost;
        System.out.println("PROCESS NO CUTS");
        System.out.println("runtime: " + vmRuntime + "arachneCost: " + arachneCost + ", baseline: " + baselineCost);
        this.log.println("PROCESS NO CUTS");
        this.log.println("runtime: " + vmRuntime + "arachneCost: " + arachneCost + ", baseline: " + baselineCost);
        this.pw.println("(estimate) runtime: " + vmRuntime + "arachneCost: " + arachneCost + ", baseline: " + baselineCost);
        this.pw.flush();
        if (arachneCost < baselineCost) {
            // it worked!
            String sqlQryLast = splitGraph(qLast.root, this.source);
            QueryExecutionGraph qLastNew = new QueryExecutionGraph(sqlQryLast, null, this.source,
                    null, qLast.getNumChildren(), false);
            List<QueryExecutionGraph> qs = new ArrayList<>();
            for (int i = 0; i < numQs - 1; i++) {
                qs.add(queryList.get(i));
            }
            qs.add(qLastNew);
            String dbName = "arachne_final.db";
            try {
                ExecutionEngine.executeQueriesSerial(qs, dbName, this, true);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("ERROR IN EXECUTION. STOPPING");
                this.pw.flush();
                this.pw.close();
                this.log.close();
                throw e;
            } finally {
                if (this.source == MonetaryNodeType.GCP) {
                    File f1 = new File("/mnt/disks/tpcds/" + dbName);
                    File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
                    f1.delete();
                    f2.delete();
                }
            }

            for (QueryExecutionGraph q : qs) {
                System.out.println(q);
                this.log.println(q);
                this.pw.println(q);
            }

            double totalCost = 0;
            for (QueryExecutionGraph q : qs) {
                totalCost += q.cost;
            }
            System.out.println("(NO CUT) TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
            this.log.println("(NO CUT) TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
            this.pw.println("(NO CUT) TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
            return true;
        }
        return false;
    }

    public boolean processCut(int ret) throws Exception {
        int numQs = queryList.size();
        System.out.println(numQs);
        this.log.println(numQs);
        for (QueryExecutionGraph q : queryList) {
            System.out.println(q);
            this.log.println(q);
        }
        if (ret == 0)
            return processNoCuts();
        System.out.println("BEGUN PROCESSING");
        double baselineCost = (bigQueryReadSize / 1_000_000_000) * 0.005; // BQ cost straightup
        double baselineCost2 = (baselineRuntime / 3600) * this.cost; // RS/DuckDB cost vanilla
        double baselineCostCalcite = (baselineRuntimeCalcite / 3600) * this.cost; // RS/DuckDB cost through calcite

        double vmRuntime = 0;
        for (int i = 0; i < numQs - 1; i++) {
            QueryExecutionGraph q = queryList.get(i);
            vmRuntime += q.getRuntime();
        }

        double vmCost = (vmRuntime / 3600) * this.cost;
        QueryExecutionGraph q0 = queryList.get(numQs - 1);
        QueryExecutionGraph qMoveEst = queryList.get(numQs - 2);

        double cutNoHybrid = vmRuntime + q0.getRuntime();
        double costCutNoHybrid = (cutNoHybrid / 3600) * this.cost;

        Long card = qMoveEst.getCardinality();

        CardinalityEstimator est = new CardinalityEstimator();
        est.computeTables(q0.root);

        long rowSize = ColumnSizes.estimateRowSize(qMoveEst.root);
        double intermediateTableSize = ((double)card/1_000_000_000) * rowSize;
        System.out.println(q0);
        System.out.println(qMoveEst);
        System.out.println("rowSize: " + rowSize);
        double compressed = (intermediateTableSize / 2.1d) + est.extraSizeParquetGB; // NOTE: 2.1 is rough estimate for SNAPPY compression ratio w/ Parquet
        double movementCost = compressed * this.movement;

        double totalBQRead = intermediateTableSize + est.extraSizeGB;
        double bqSize = Math.max(totalBQRead, 0.010485760d); // min 10MB of charges
        double p2Cost = bqSize * 0.005;
        double arachneCost = vmCost + movementCost + p2Cost;

        // double lastVM = (q0.getRuntime() / 3600) * this.cost;
        // double arachneCost2 = vmCost + lastVM;
        String vals = "{\"bqSize\":" + bqSize + ",\"compressed\":" + compressed + ",\"mvmtCost\":" + movementCost +
                ",\"runtime\":" + vmRuntime + ",\"runCost\":" + vmCost + ",\"bqCost\":" + p2Cost +
                ",\"cutNoHybrid\":" + cutNoHybrid + "}";

        String baselines = "baseline runtime: " + baselineRuntime + " baselineBQ read size: " + bigQueryReadSize;
        System.out.println(vals);
        System.out.println(baselines);
        System.out.println("arachneCost: " + arachneCost + ", baselineCost2: " + baselineCost2 + ", baseline: " + baselineCost + ", cutNoHybrid: " + costCutNoHybrid);
        this.pw.println(vals);
        this.pw.println("(estimate)arachneCost: " + arachneCost + ", baselineCost2: " + baselineCost2 + ", baseline: " + baselineCost);
        this.pw.flush();
        double bqSavings = baselineCost - arachneCost;
        double duckSavings = baselineCost2 - arachneCost;
        double splitSavings = costCutNoHybrid - arachneCost;
        double realSave = Math.min(Math.min(bqSavings, duckSavings), splitSavings); // > 0 iff arachneCost < all
        double savePercent = realSave / (realSave + arachneCost); // if < epsilon, say 0.02, then don't do it.

        boolean cond;
        if (this.source == MonetaryNodeType.GCP) {
            cond = arachneCost < baselineCost && arachneCost < baselineCost2 && arachneCost < baselineCostCalcite;
        } else if (this.source == MonetaryNodeType.RS) {
            cond = arachneCost < baselineCost2 && arachneCost < baselineCostCalcite;
        } else {
            throw new Exception("Invalid source type ya moron");
        }
        // if (arachneCost < baselineCost && arachneCost < baselineCost2 && arachneCost < costCutNoHybrid) {
        // if (arachneCost < baselineCost && arachneCost < baselineCost2) {
        if (cond) {
            // it worked!
            QueryExecutionGraph qMove = queryList.get(numQs - 2);
            QueryExecutionGraph qLast = queryList.get(numQs - 1);

            String sqlQryMove = splitGraph(qMove.root, this.source);
            sqlQryMove = "CREATE TABLE " + qMove.getOutTableName() + " AS " + sqlQryMove;
            QueryExecutionGraph qMoveNew = new QueryExecutionGraph(sqlQryMove, qMove.getOutTableName(), this.source,
                    MonetaryNodeType.BQ, qMove.getNumChildren(), numQs > 2);


            String sqlQryLast = splitGraph(qLast.root, MonetaryNodeType.BQ);
            QueryExecutionGraph qLastNew = new QueryExecutionGraph(sqlQryLast, null, MonetaryNodeType.BQ,
                    null, 1, false);
            List<QueryExecutionGraph> qs = new ArrayList<>();
            for (int i = 0; i < numQs - 2; i++) {
                qs.add(queryList.get(i));
            }
            qs.add(qMoveNew);
            qs.add(qLastNew);
            String dbName = "arachne_final.db";

            endProfileTimer = System.nanoTime();
            double profileSecs = (double)(endProfileTimer - startProfileTimer) / 1_000_000_000.0;
            this.log.println("totalProfileRuntime," + profileSecs);

            try {
                ExecutionEngine.executeQueriesSerial(qs, dbName, this, true);
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("ERROR IN EXECUTION. STOPPING");
                this.pw.flush();
                this.pw.close();
                this.log.close();
                throw e;
            } finally {
                if (this.source == MonetaryNodeType.GCP) {
                    File f1 = new File("/mnt/disks/tpcds/" + dbName);
                    File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
                    f1.delete();
                    f2.delete();
                }
            }
            for (QueryExecutionGraph q : qs) {
                System.out.println(q);
                this.pw.println(q);
            }

            System.out.println("estimated move size: " + compressed);
            System.out.println("estimate billed runtime: " + vmRuntime);
            System.out.println("estimated BQ read size: " + bqSize);

            double totalCost = 0;
            for (QueryExecutionGraph q : qs) {
                totalCost += q.cost;
            }
            System.out.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
            // this.pw.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
            System.out.println("total cost: " + key + "," + totalCost + ","  + baselineCost + "," + baselineCost2 + "," + costCutNoHybrid);
            this.pw.println("total cost: " + key + "," + totalCost + ","  + baselineCost + "," + baselineCost2 + "," + costCutNoHybrid);
            this.pw.flush();
            return true;
        }
        // else if (arachneCost2 < baselineCost) {
        //     // it worked!
        //     QueryExecutionGraph qLast = queryList.get(numQs - 1);
        //     String sqlQryLast = splitGraph(qLast.root, this.source);
        //     QueryExecutionGraph qLastNew = new QueryExecutionGraph(sqlQryLast, null, this.source,
        //             null, qLast.getNumChildren(), false);
        //     List<QueryExecutionGraph> qs = new ArrayList<>();
        //     for (int i = 0; i < numQs - 1; i++) {
        //         qs.add(queryList.get(i));
        //     }
        //     qs.add(qLastNew);
        //     String dbName = "arachne_final.db";
        //     try {
        //         ExecutionEngine.executeQueriesSerial(qs, dbName, this, true);
        //     } catch (Exception e) {
        //         e.printStackTrace();
        //         System.out.println("ERROR IN EXECUTION. STOPPING");
        //         this.pw.flush();
        //         this.pw.close();
        //         this.log.close();
        //         throw e;
        //     } finally {
        //         if (this.source == MonetaryNodeType.GCP) {
        //             File f1 = new File("/mnt/disks/tpcds/" + dbName);
        //             File f2 = new File("/mnt/disks/tpcds/" + dbName + ".wal");
        //             f1.delete();
        //             f2.delete();
        //         }
        //     }

        //     for (QueryExecutionGraph q : qs) {
        //         System.out.println(q);
        //         this.log.println(q);
        //         this.pw.println(q);
        //     }

        //     double totalCost = 0;
        //     for (QueryExecutionGraph q : qs) {
        //         totalCost += q.cost;
        //     }
        //     System.out.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
        //     this.log.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
        //     this.pw.println("TOTAL COST OF ARACHNE PLAN: $" + totalCost + ", BASELINE: $" + baselineCost);
        //     this.pw.flush();
        //     return true;
        // }
        else {
            return false;
        }
    }

    private class CutTraverseState {
        public int ordinal;
        public @Nullable ProfileRel parent;
        public ProfileRel node;
        // public int trial;
        public int numBigOps;

        public CutTraverseState(ProfileRel node, int ordinal, @Nullable ProfileRel parent, int numBigOps, int trial) {
            this.node = node;
            this.ordinal = ordinal;
            this.parent = parent;
            this.numBigOps = numBigOps;
            // this.trial = trial;
        }

        @Override public boolean equals(Object o) {
            if (!(o instanceof CutTraverseState))
                return false;
            CutTraverseState comp  = (CutTraverseState) o;
            return ((parent.getId() == comp.parent.getId()) && (ordinal == comp.ordinal) &&
                    (node.getId() == comp.node.getId()) && /*(trial == comp.trial) &&*/ (numBigOps == comp.numBigOps)
            );
            // return (parent == comp.parent);
        }

        // need hashCode for Set to find duplicates. HashSet just uses fact that hashCodes same iff equals(...) true
        @Override public int hashCode() {
            return Objects.hash(ordinal, parent, node, /*trial,*/ numBigOps);
        }
    }

    public int findCutBFS(ProfileRel node, int numOps, int trial) {
        Queue<CutTraverseState> traverseQueue = new LinkedList<>();
        CutTraverseState init = new CutTraverseState(node, 0, null, numOps, trial);
        // traverseQueue.offer(init);
        int result = testNodeForCut(init, trial, traverseQueue);
        while (result == 0 && !traverseQueue.isEmpty()) {
            CutTraverseState curr = traverseQueue.poll();
            result = testNodeForCut(curr, trial, traverseQueue);
            if (result == 2) { // we skipped trial
                trial -= 1;
                result = 0;
            }

        }
        return result;
    }

    public int testNodeForCut(CutTraverseState state, int trial, Queue<CutTraverseState> traverseQueue) {
        ProfileRel node = state.node;
        int ordinal = state.ordinal;
        ProfileRel parent = state.parent;
        int numOps = state.numBigOps;
        // int trial = state.trial;

        Long outputCardinality = node.getCardinality();
        boolean condition = (numOps > 0);
        if (outputCardinality != null) {
            Long rowSize = ColumnSizes.estimateRowSize(node);
            long numBytes = outputCardinality * rowSize; // TODO estimate this better
            // System.out.println(node.getDigest() + " " + numBytes + " " + this.bigQueryReadSize);
            // System.out.println(numBytes / this.bigQueryReadSize);
            // System.out.println(numOps);
            // what is total size of leaves? should have this from some profile/previous run or something
            condition = (numOps > 0) && (numBytes < 100_000_000_000L || (numBytes / this.bigQueryReadSize) < 0.1f);
            // System.out.println(condition);
        }

        boolean skippedTrial = false;
        if (condition && trial > 0) {
            // skip the first `trial` accepts as we've tried them already
            // reset this value, because we want to take the first big Op after trial is 0,
            // not just the next node we see after trial is 0
            numOps = 0;
            // trial -= 1;
            skippedTrial = true;
        } else if (condition) {
            //propose cut here
            String sqlQry;
            QueryExecutionGraph qc;
            // QueryExecutionGraph cse = findCommonSubExpression(node, this.source);
            List<QueryExecutionGraph> cse = foo(node, this.source);
            // System.out.println("---------------------");
            String ctasTableName = this.source.getInputString() + "_table_" + key + "_" + count;
            sqlQry = splitGraph(node, parent, ordinal, ctasTableName, this.source);
            qc = new QueryExecutionGraph(sqlQry, ctasTableName, this.source, this.source,
                    0, true);
            qc.root = node;
            // qc.setCardinality(node.getCardinality());
            if (cse != null) {
                qc.setNumChildren(cse.size());
                queries.addAll(cse);
                queryList.addAll(cse);
            }
            // print(ctasTableName, node);
            // System.out.println(sqlQry);
            // System.out.println(qc);
            // System.out.println("---------------------!!!");
            queries.add(qc);
            queryList.add(qc);
            return 1;
        }

        int numBigOps = numOps;
        if (node instanceof Aggregate)
            numBigOps++;
        else if (node instanceof Project && ((Project)node).containsOver())
            numBigOps++;
        else if (node instanceof Join)
            numBigOps++;
        else if (node instanceof Correlate)
            numBigOps++;
        else if (node instanceof Intersect)
            numBigOps++;

        List<RelNode> inputs = node.getInputs();
        int size = inputs.size();
        for (int i = 0; i < size; i++) {
            ProfileRel input = (ProfileRel)inputs.get(i);
            CutTraverseState child = new CutTraverseState(input, i, node, numBigOps, trial);
            traverseQueue.offer(child);
        }
        if (skippedTrial)
            return 2;
        return 0;
    }

    public int findCut(ProfileRel node, int ordinal, @Nullable RelNode parent, ProfileRel ref, int numOps, int trial) {
        Long outputCardinality = node.getCardinality();
        boolean condition = (numOps > 0);
        if (outputCardinality != null) {
            Long rowSize = ColumnSizes.estimateRowSize(node);
            long numBytes = outputCardinality * rowSize; // TODO estimate this better
            // System.out.println(node.getDigest() + " " + numBytes + " " + this.bigQueryReadSize);
            // System.out.println(numBytes / this.bigQueryReadSize);
            // System.out.println(numOps);
            // what is total size of leaves? should have this from some profile/previous run or something
            condition = (numOps > 0) && (numBytes < 100_000_000_000L || (numBytes / this.bigQueryReadSize) < 0.1f);
            // System.out.println(condition);
        }

        if (condition && trial > 0) {
            // reset this value, because we want to take the first big Op after trial is 0,
            // not just the next node we see after trial is 0
            numOps = 0;
            trial -= 1; // skip the first `trial` accepts as we've tried them already
        } else if (condition) {
            //propose cut here
            String sqlQry;
            QueryExecutionGraph qc;
            // QueryExecutionGraph cse = findCommonSubExpression(node, this.source);
            List<QueryExecutionGraph> cse = foo(node, this.source);
            // System.out.println("---------------------");
            String ctasTableName = this.source.getInputString() + "_table_" + key + "_" + count;
            sqlQry = splitGraph(node, parent, ordinal, ctasTableName, this.source);
            qc = new QueryExecutionGraph(sqlQry, ctasTableName, this.source, this.source,
                    0, true);
            qc.root = node;
            // qc.setCardinality(node.getCardinality());
            if (cse != null) {
                qc.setNumChildren(cse.size());
                queries.addAll(cse);
                queryList.addAll(cse);
            }
            // print(ctasTableName, node);
            // System.out.println(sqlQry);
            // System.out.println(qc);
            // System.out.println("---------------------!!!");
            queries.add(qc);
            queryList.add(qc);
            this.nodeToQuery.put(ref, qc);
            return 1;
        }

        int numBigOps = numOps;
        if (node instanceof Aggregate)
            numBigOps++;
        else if (node instanceof Project && ((Project)node).containsOver())
            numBigOps++;
        else if (node instanceof Join)
            numBigOps++;
        else if (node instanceof Correlate)
            numBigOps++;
        else if (node instanceof Intersect)
            numBigOps++;

        List<RelNode> inputs = node.getInputs();
        List<RelNode> refInputs = ref.getInputs();
        int size = inputs.size();
        for (int i = 0; i < size; i++) {
            ProfileRel input = (ProfileRel)inputs.get(i);
            ProfileRel refInput = (ProfileRel)refInputs.get(i);
            int ret = findCut(input, i, node, refInput, numBigOps, trial);
            if (ret == 1)
                return ret;
        }
        return 0;
    }

    public void resetState() { // TODO maybe just make new maps/lists, unsure
        count = 0;
        queries.clear();
        queryList.clear();
        nodeToQuery.clear();
        parents.clear();
        subExprs.clear();
    }

    private String splitGraph(RelNode node, MonetaryNodeType type) {
        SqlDialect outDialect = type.getOutputDialect();
        MonetaryLocation loc = ExecutionEngine.getLocationForType(type);
        SqlNode sqlNode = new RelToSqlConverter(outDialect).visitRoot(node).asStatement();
        String sqlQry = sqlNode.toSqlString(outDialect).getSql();
        sqlQry = ArachneRelToSqlConverter.convertQuery(sqlQry, loc, this.schemaName, true);
        return sqlQry;
    }

    private String splitGraph(RelNode node, @Nullable RelNode parent, int ordinal, String ctasTableName, MonetaryNodeType type) {
        String sqlQry = splitGraph(node, type);
        // String CTAS = new StringBuilder().append("CREATE TABLE ").append(ctasTableName).append(" AS ").append(sqlQry).toString();
        String CTAS = "CREATE TABLE " + ctasTableName + " AS " + sqlQry;
        RelNode temp = createTempScan(node, this.source);
        // print("PRIOR STATE: ", originalRoot);
        if (parent != null)
            parent.replaceInput(ordinal, temp);
        // print("CURRENT STATE: ", originalRoot);
        return CTAS;
    }

    private ProfileRel constructTree() {
        ProfileRel pTree = null;
        try {
            SqlNode sqlTree = optimizer.parse(qry);
            SqlNode validatedSqlTree = optimizer.validate(sqlTree);
            RelNode relTree = optimizer.convert(validatedSqlTree);
            relTree = optimizer.convertLogical(relTree, logicalRules);
            pTree = optimizer.createProfile(relTree);
            ProfileMatcher profileMatcher = new ProfileMatcher(graph);
            profileMatcher.goMatchCard(pTree);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pTree;
    }

    private class Parent {
        public int ordinal;
        public RelNode parent;
        public Parent(int ordinal, RelNode parent) {
            this.parent = parent;
            this.ordinal = ordinal;
        }
        @Override public boolean equals(Object o) {
            if (!(o instanceof Parent))
                return false;
            Parent comp  = (Parent) o;
            return ((parent.getId() == comp.parent.getId()) && (ordinal == comp.ordinal));
            // return (parent == comp.parent);
        }

        // need hashCode for Set to find duplicates. HashSet just uses fact that hashCodes same iff equals(...) true
        @Override public int hashCode() {
            return Objects.hash(ordinal, parent);
        }
    }

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

    public void findCommonSubExpression(RelNode node, int ordinal, @Nullable RelNode parent) {
        int size = node.getInputs().size();
        if (size == 0) {
            return;
        }
        ProfileRel pNode = (ProfileRel)node;
        ProfileRel next = findNextMatchableRelNode(pNode);
        if (next.getRelTypeName().equals("ProfileTableScan")) {
            return;
        }

        if (!parents.containsKey(node) && parent != null) {
            Set<Parent> currParents = new HashSet<>();
            Parent p = new Parent(ordinal, parent);
            currParents.add(p);
            parents.put(node, currParents);
        } else if (parents.containsKey(node)) {
            // System.out.println(node.getDigest());
            Set<Parent> currParents = parents.get(node);
            Parent p = new Parent(ordinal, parent);
            if (!currParents.contains(p)) {
                // System.out.println(node.getId() + " " + parent.getId());
                currParents.add(p);
                if (!subExprs.contains(node)) {
                    // System.out.println(node.getId());
                    subExprs.add(node);
                }
            }
        }

        for (int i = 0; i < size; i++) {
            RelNode input = node.getInput(i);
            findCommonSubExpression(input, i, node);
        }
    }

    public List<QueryExecutionGraph> foo(RelNode root, MonetaryNodeType type) {
        // print("AH", root);
        findCommonSubExpression(root, 0, null);
        QueryExecutionGraph qc = null;

        List<QueryExecutionGraph> ret = new ArrayList<>();
        for (RelNode r : subExprs) {
            // System.out.println("AHHHHH!!!!");
            Set<Parent> ps = parents.get(r);
            String ctasTableName = this.source.getInputString() + "_table_" + key + "_" + count;
            RelNode temp = createTempScan(r, type);
            String sqlQry = splitGraph(r, type);
            String CTAS = "CREATE TABLE " + ctasTableName + " AS " + sqlQry;
            for (Parent p : ps) {
                p.parent.replaceInput(p.ordinal, temp);
            }
            qc = new QueryExecutionGraph(CTAS, ctasTableName, type, type, 0, true); // TODO num=0 is wrong. parallel wont work when impl'd
            qc.root = r;
            // ProfileRel pr = (ProfileRel) r;
            // qc.setCardinality(pr.getCardinality());
            // System.out.println(qc.getQuery());
            ret.add(qc);
        }
        if (ret.size() == 0)
            return null;
        subExprs.clear();
        parents.clear(); // TODO: we're not detecting situations where we have CSEs between the two split queries.
        return ret;
    }

    protected void print(String header, RelNode relTree) {
        StringWriter sw = new StringWriter();
        sw.append(header).append(":").append("\n");
        RelWriterImpl relWriter = new RelWriterImpl(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        relTree.explain(relWriter);
        System.out.println(sw);
    }

    private RelNode createTempScan(RelNode node, MonetaryNodeType type) {
        String tableName = this.source.getInputString() + "_table_" + key + "_" + count;
        count++;
        String schemaName = "tpcds";
        ArachneTable.Builder tblBuilder = ArachneTable.newBuilder(tableName);
        node.getRowType().getFieldList().forEach((f) -> tblBuilder.addField(f.getName(), f.getType().getSqlTypeName()));
        long rowCount = 1L;
        tblBuilder.withRowCount(rowCount); // TODO use card of input as table cardinality, handle no-match
        ArachneTable table = tblBuilder.build();
        RelOptTable relTable = RelOptTableImpl.create(null, node.getRowType(), table, ImmutableList.of(schemaName, tableName));
        RelNode scan = converter.toRel(relTable, ImmutableList.of());
        return optimizer.createProfile(scan);
    }
}
