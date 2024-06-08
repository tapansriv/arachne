package org.arachne;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.rel.RelWriter;
import org.arachne.algorithmic_collection.AlgorithmicCollector;
import org.arachne.algorithmic_collection.QueryMetadata;
import org.arachne.collection.ArachneRelWriter;
import org.arachne.collection.Collector;
import org.arachne.common.QueryExecutionGraph;
import org.arachne.common.Schemas;
import org.arachne.execution.ArachneRelToSqlConverter;
import org.arachne.execution.ExecutionEngine;
import org.arachne.plan.MonetaryConvention;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.ProfileGraph;
import org.arachne.profiling.ProfileMatcher;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.profiling.rules.ProfileRelRules;
import org.arachne.schema.ArachneSchema;
import org.arachne.schema.ArachneTable;
import org.arachne.optimizer.Optimizer;

import org.apache.calcite.config.CalciteConnectionConfig;
import org.apache.calcite.config.CalciteConnectionConfigImpl;
import org.apache.calcite.config.CalciteConnectionProperty;
import org.apache.calcite.avatica.util.Casing;
import org.apache.calcite.plan.RelOptCostImpl;
import org.apache.calcite.plan.Contexts;
import org.apache.calcite.rex.RexBuilder;
import org.apache.calcite.jdbc.JavaTypeFactoryImpl;

import org.apache.calcite.plan.RelOptRule;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.ConventionTraitDef;
import org.apache.calcite.interpreter.Bindables;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.tools.Program;
import org.apache.calcite.tools.Programs;
import org.apache.calcite.tools.RuleSets;
import org.apache.calcite.rel.rules.CoreRules;
import org.apache.calcite.rel.RelCollationTraitDef;
import org.apache.calcite.adapter.enumerable.EnumerableRules;
import org.apache.calcite.adapter.enumerable.EnumerableConvention;
import org.apache.calcite.tools.RuleSet;

import org.apache.calcite.jdbc.CalciteSchema;
import org.apache.calcite.plan.RelOptCostImpl;
import org.apache.calcite.plan.ConventionTraitDef;
import org.apache.calcite.plan.Contexts;
import org.apache.calcite.tools.FrameworkConfig;
import org.apache.calcite.rel.type.RelDataTypeFactory;
import org.apache.calcite.tools.Frameworks;
import org.apache.calcite.tools.Planner;
import org.apache.calcite.schema.SchemaPlus;
import org.apache.calcite.sql.SqlNode;
import org.apache.calcite.sql.parser.SqlParser;
import org.apache.calcite.sql.pretty.SqlPrettyWriter;
import org.apache.calcite.sql.SqlWriter;
import org.apache.calcite.sql.dialect.AnsiSqlDialect;
import org.apache.calcite.rel.RelRoot;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.sql.SqlDialect;
import org.apache.calcite.sql.SqlWriterConfig;
import org.apache.calcite.rel.rel2sql.RelToSqlConverter;
import org.apache.calcite.plan.volcano.VolcanoPlanner;
import org.apache.calcite.plan.RelOptUtil;

import org.apache.calcite.schema.impl.AbstractSchema;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Properties;


import org.apache.calcite.rel.externalize.RelWriterImpl;
import org.apache.calcite.sql.SqlExplainLevel;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import static org.arachne.common.Queries.qry13;

public class ArachneQueryProcessor {

    public static RuleSet logicalRules_80 = RuleSets.ofList(
            CoreRules.FILTER_INTO_JOIN,
            CoreRules.FILTER_SCAN,
            CoreRules.FILTER_CORRELATE,
            CoreRules.PROJECT_CORRELATE_TRANSPOSE,
            CoreRules.JOIN_CONDITION_PUSH,
            CoreRules.JOIN_ADD_REDUNDANT_SEMI_JOIN,
            CoreRules.JOIN_TO_SEMI_JOIN,
            CoreRules.JOIN_LEFT_UNION_TRANSPOSE,
            CoreRules.JOIN_RIGHT_UNION_TRANSPOSE,
            CoreRules.PROJECT_TO_SEMI_JOIN,
            // CoreRules.PROJECT_JOIN_TRANSPOSE,
            CoreRules.PROJECT_SUB_QUERY_TO_CORRELATE,
            CoreRules.FILTER_SUB_QUERY_TO_CORRELATE,
            CoreRules.JOIN_SUB_QUERY_TO_CORRELATE,
            CoreRules.SEMI_JOIN_FILTER_TRANSPOSE,
            CoreRules.SEMI_JOIN_JOIN_TRANSPOSE,
            CoreRules.SEMI_JOIN_PROJECT_TRANSPOSE,
            CoreRules.SEMI_JOIN_REMOVE,
            CoreRules.PROJECT_FILTER_TRANSPOSE,
            CoreRules.AGGREGATE_CASE_TO_FILTER,
            CoreRules.FILTER_PROJECT_TRANSPOSE
    );
    public static RuleSet logicalRules = RuleSets.ofList(
            CoreRules.FILTER_INTO_JOIN,
            CoreRules.FILTER_SCAN,
            CoreRules.FILTER_CORRELATE,
            CoreRules.PROJECT_CORRELATE_TRANSPOSE,
            CoreRules.JOIN_CONDITION_PUSH,
            CoreRules.JOIN_ADD_REDUNDANT_SEMI_JOIN,
            CoreRules.JOIN_TO_SEMI_JOIN,
            CoreRules.JOIN_LEFT_UNION_TRANSPOSE,
            CoreRules.JOIN_RIGHT_UNION_TRANSPOSE,
            CoreRules.PROJECT_TO_SEMI_JOIN,
            CoreRules.PROJECT_JOIN_TRANSPOSE,
            CoreRules.PROJECT_SUB_QUERY_TO_CORRELATE,
            CoreRules.FILTER_SUB_QUERY_TO_CORRELATE,
            CoreRules.JOIN_SUB_QUERY_TO_CORRELATE,
            CoreRules.SEMI_JOIN_FILTER_TRANSPOSE,
            CoreRules.SEMI_JOIN_JOIN_TRANSPOSE,
            CoreRules.SEMI_JOIN_PROJECT_TRANSPOSE,
            CoreRules.SEMI_JOIN_REMOVE,
            CoreRules.PROJECT_FILTER_TRANSPOSE,
            CoreRules.AGGREGATE_CASE_TO_FILTER,
            CoreRules.FILTER_PROJECT_TRANSPOSE
    );

    public static RelNode convertQuery(Optimizer optimizer, String qry) throws Exception {
        SqlNode sqlTree = optimizer.parse(qry);
        SqlNode validatedSqlTree = optimizer.validate(sqlTree);
        return optimizer.convert(validatedSqlTree);
    }

    public static ProfileGraph matchProfile(ProfileRel relTree, String filename, String schemaName) {
        ProfileGraph graph = new ProfileGraph();
        try {
            graph.parseProfile(filename, schemaName);
            ProfileMatcher profileMatcher = new ProfileMatcher(graph);
            profileMatcher.goMatchCard(relTree);
            return graph;
        } catch (Exception e) {
            e.printStackTrace();
            return graph;
        }
        // profileMatcher.go(relTree); // annotate graph
    }

    protected static void print(String header, RelNode relTree) {
        StringWriter sw = new StringWriter();
        sw.append(header).append(":").append("\n");
        RelWriter relWriter;
        if (relTree instanceof ProfileRel)
            relWriter = new ArachneRelWriter(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);
        else
            relWriter = new RelWriterImpl(new PrintWriter(sw), SqlExplainLevel.ALL_ATTRIBUTES, true);

        relTree.explain(relWriter);
        System.out.println(sw);
    }

    public static double baselineRuntime(String key, String src, String schemaName) throws Exception {
        JSONParser parser = new JSONParser();
        try {
            String file; //= System.getProperty("user.home") + "/arachneDB/baseline/" + src + "_baseline.json";
            if (schemaName.equals("tpcds")) {
                // file = System.getProperty("user.home") + "/arachneDB/baseline_1tb/" + src + "_baseline.json";
                // file = System.getProperty("user.home") + "/arachneDB/baseline_2tb/" + src + "_baseline_2tb.json";
                file = System.getProperty("user.home") + "/arachneDB/baseline_10tb/" + src + "_baseline_10tb.json";
            } else if (schemaName.equals("ldbc")) {
                file = System.getProperty("user.home") + "/arachneDB/ldbc/baseline/" + src + "_baseline_ldbc_sf100.json";
            } else {
                throw new RuntimeException("Illegal schema name provided; should be tpcds, ldbc");
            }
            System.out.println(file);
            JSONObject jsonObject = (JSONObject) parser.parse(new FileReader(file));
            if (jsonObject.containsKey(key)) {
                Double runtime = (Double) jsonObject.get(key);
                System.out.println(key + " " + runtime);
                return runtime;
            } else {
                return -1;
            }
        } catch (Exception e)  {
            e.printStackTrace();
            throw e;
        }
    }

    public static double getBaselineRuntime(String qry) throws ClassNotFoundException, SQLException {
        Statement stmt = ExecutionEngine.getPostgresStatement();
        Long start = System.nanoTime();
        stmt.executeQuery(qry);
        Long end = System.nanoTime();
        double secs = (double)(end - start) / 1_000_000_000.0;
        return secs;
    }

    public static double bigQueryReadSize(String key, String schemaName) {
        JSONParser parser = new JSONParser();
        try {
            String file;
            if (schemaName.equals("tpcds")) {
                // file = System.getProperty("user.home") + "/arachneDB/baseline_1tb/bigquery_baseline.json";
                // file = System.getProperty("user.home") + "/arachneDB/baseline_2tb/bigquery_baseline_2tb.json";
                file = System.getProperty("user.home") + "/arachneDB/baseline_10tb/bigquery_baseline_10tb.json";
            } else if (schemaName.equals("ldbc")) {
                file = System.getProperty("user.home") + "/arachneDB/ldbc/baseline/bigquery_baseline_ldbc_sf100.json";
            } else {
                throw new RuntimeException("Illegal schema name provided; should be tpcds, ldbc");
            }
            JSONObject jsonObject = (JSONObject) parser.parse(new FileReader(file));
            JSONObject baseline = (JSONObject) jsonObject.get(key);
            Long bytes = (Long)baseline.get("bytes");
            return bytes.doubleValue();
        } catch (Exception e)  {
            e.printStackTrace();
        }

        if (key.equals("67")) {
            return 930_370_000_000d;
        } else if (key.equals("81")) {
            return 38_710_000_000d;
        } else if (key.equals("36")) {
            return 310_300_000_000d;
        } else {
            return -1d;
        }
    }

    private static String splitGraph(RelNode node, MonetaryNodeType type, String schemaName) {
        SqlDialect outDialect = type.getOutputDialect();
        MonetaryLocation loc = ExecutionEngine.getLocationForType(type);
        SqlNode sqlNode = new RelToSqlConverter(outDialect).visitRoot(node).asStatement();
        String sqlQry = sqlNode.toSqlString(outDialect).getSql();
        System.out.println(schemaName);
        sqlQry = ArachneRelToSqlConverter.convertQuery(sqlQry, loc, schemaName, true);
        return sqlQry;
    }

    public static boolean runIteration(String key, MonetaryNodeType type, String schemaName, double cost, double mvmt,
                                       boolean verbose, int iteration) throws Exception {
        RelNode relTree = null;
        ProfileRel relTree2 = null;
        try {
            String filePath;
            ArachneSchema schema;
            if (schemaName.equals("tpcds")) {
                filePath = System.getProperty("user.home") + "/arachneDB/a_queries/" + key + ".sql";
                schema = Schemas.tpcdsSchema;
            } else if (schemaName.equals("ldbc")) {
                filePath = System.getProperty("user.home") + "/arachneDB/ldbc/queries/a_queries/" + key + ".sql";
                schema = Schemas.ldbcSchema;
            } else {
                throw new RuntimeException("Illegal schema name provided;");
            }

            double bigQueryReadSize = bigQueryReadSize(key, schemaName);
            double baselineRuntime, baselineRuntimeCalcite;
            String qry = new String(Files.readAllBytes(Paths.get(filePath))); // query text
            baselineRuntime = baselineRuntime(key, type.getInputString(), schemaName); // runtime for static runtime cost system
            baselineRuntimeCalcite = baselineRuntime(key, type.getInputString() + "_c", schemaName); // runtime for sql preop
            if (baselineRuntime == -1 || baselineRuntimeCalcite == -1) {
                throw new Exception("Baseline for query " + key + " not run");
            }

            qry = qry.replaceAll(";", ""); // calcite will not process semicolons
            String profile_name = key + "_profile.json";
            Optimizer optimizer = Optimizer.create(schema);
            relTree = convertQuery(optimizer, qry);
            RuleSet lRules = (key.equals("80")) ? logicalRules_80 : logicalRules;
            relTree = optimizer.convertLogical(relTree, lRules);
            relTree2 = optimizer.createProfile(relTree);

            if (key.equals("88"))
                fixQuery88(relTree2);

            // print("AFTER PROFILE", relTree2);
            ProfileGraph graph = matchProfile(relTree2, profile_name, schemaName);
            QueryMetadata qm = new QueryMetadata(key, bigQueryReadSize, baselineRuntime, baselineRuntimeCalcite, cost, mvmt, type);
            AlgorithmicCollector ac = new AlgorithmicCollector(qm, optimizer, qry, logicalRules, relTree2, schemaName, iteration);
            ac.go();

            return true;
        } catch (Exception | AssertionError  e) {
            System.out.println("failed: " + key);
            e.printStackTrace();
            if (verbose) {
                e.printStackTrace();
                if (relTree2 != null)
                    print("ERROR:", relTree2);
                else if (relTree != null)
                    print("ERROR:", relTree);
            }
            String fname = System.getProperty("user.home") + "/arachneDB/data/" + key + ".done";
            new PrintWriter(fname, "UTF-8").close(); // ensure that in case of exception we stop iterating
            return false;
        }
    }

    public static boolean run(String key, MonetaryNodeType type, String schemaName,
                              double cost, double mvmt, boolean verbose) {
        RelNode relTree = null;
        ProfileRel relTree2 = null;
        try {
            String filePath;
            ArachneSchema schema;
            if (schemaName.equals("tpcds")) {
                filePath = System.getProperty("user.home") + "/arachneDB/a_queries/" + key + ".sql";
                schema = Schemas.tpcdsSchema;
            } else if (schemaName.equals("ldbc")) {
                filePath = System.getProperty("user.home") + "/arachneDB/ldbc/queries/a_queries/" + key + ".sql";
                schema = Schemas.ldbcSchema;
            } else {
                throw new RuntimeException("Illegal schema name provided;");
            }
            double bigQueryReadSize = bigQueryReadSize(key, schemaName);
            double baselineRuntime, baselineRuntimeCalcite;
            String qry = new String(Files.readAllBytes(Paths.get(filePath)));
            baselineRuntime = baselineRuntime(key, type.getInputString(), schemaName);
            baselineRuntimeCalcite = baselineRuntime(key, type.getInputString() + "_c", schemaName);
            if (baselineRuntime == -1 || baselineRuntimeCalcite == -1) {
                throw new Exception("Baseline for query " + key + " not run");
            }

            qry = qry.replaceAll(";", "");
            // String profile_name = key + "/" + key + "_final.json";
            String profile_name = key + "_profile.json";
            Optimizer optimizer = Optimizer.create(schema);
            relTree = convertQuery(optimizer, qry);
            RuleSet lRules = (key.equals("80")) ? logicalRules_80 : logicalRules;
            relTree = optimizer.convertLogical(relTree, lRules);
            relTree2 = optimizer.createProfile(relTree);
            // print("AFTER PROFILE", relTree2);
            ProfileGraph graph = matchProfile(relTree2, profile_name, schemaName);
            if (key.equals("88"))
                fixQuery88(relTree2);
            // System.out.println("you did it: " + key);
            // print("AFTER MATCH", relTree2);
            // Collector c = new Collector(optimizer, qry, logicalRules, graph,
            //                            relTree2, bigQueryReadSize, baselineRuntime,
            //                            baselineRuntimeCalcite, outpath, type, cost, mvmt);
            // c.go();

            QueryMetadata qm = new QueryMetadata(key, bigQueryReadSize, baselineRuntime, baselineRuntimeCalcite, cost, mvmt, type);
            AlgorithmicCollector ac = new AlgorithmicCollector(qm, optimizer, qry, logicalRules, relTree2, schemaName);
            ac.go();

            return true;
        } catch (Exception | AssertionError e) {
            System.out.println("failed: " + key);
            e.printStackTrace();
            if (verbose) {
                e.printStackTrace();
                if (relTree2 != null)
                    print("ERROR:", relTree2);
                else if (relTree != null)
                    print("ERROR:", relTree);
            }
            return false;
        }
    }

    public static void calcifyQuery(String key, MonetaryNodeType type, String schemaName) {
        RelNode relTree = null;
        ProfileRel relTree2 = null;
        try {
            String filePath;
            ArachneSchema schema;
            if (schemaName.equals("tpcds")) {
                filePath = System.getProperty("user.home") + "/arachneDB/a_queries/" + key + ".sql";
                schema = Schemas.tpcdsSchema;
            } else if (schemaName.equals("ldbc")) {
                filePath = System.getProperty("user.home") + "/arachneDB/ldbc/queries/a_queries/" + key + ".sql";
                schema = Schemas.ldbcSchema;
            } else if (schemaName.equals("tpch")) {
                filePath = System.getProperty("user.home") + "/arachneDB/arachne/tests/table_queries/" + key + ".sql";
                schema = Schemas.tpchSchema;
            } else if (schemaName.equals("imdb")) {
                filePath = System.getProperty("user.home") + "/arachneDB/cockroach/imdb/queries/" + key + ".sql";
                schema = Schemas.imdbSchema;
            } else if (schemaName.equals("custom")) {
                filePath = System.getProperty("user.home") + "/arachneDB/prediction/workload/queries/" + key + ".sql";
                schema = Schemas.customSchema;
            } else {
                throw new RuntimeException("Illegal schema name provided;");
            }
            String qry = new String(Files.readAllBytes(Paths.get(filePath)));

            qry = qry.replaceAll(";", "");
            String profile_name = key + "/" + key + "_final.json";
            Optimizer optimizer = Optimizer.create(schema);
            relTree = convertQuery(optimizer, qry);
            RuleSet lRules = (key.equals("80")) ? logicalRules_80 : logicalRules;
            relTree = optimizer.convertLogical(relTree, lRules);
            print("", relTree);
            // relTree2 = optimizer.createProfile(relTree);
            // ProfileGraph graph = matchProfile(relTree2, profile_name);

            System.out.println(schemaName);
            String sqlQry = splitGraph(relTree, type, schemaName);
            System.out.println(sqlQry);

            String typeStr = type.getInputString();
            String filename;
            switch (schemaName) {
                case "custom":
                    filename = System.getProperty("user.home") + "/arachneDB/prediction/workload/c_queries/" + key + ".sql";
                    break;
                case "tpcds":
                    filename = System.getProperty("user.home") + "/arachneDB/c_queries/" + typeStr + "/" + key + ".sql";
                    break;
                case "ldbc":
                    filename = System.getProperty("user.home") + "/arachneDB/ldbc/queries/c_queries/" + key + ".sql";
                    break;
                case "tpch":
                case "imdb":
                    filename = System.getProperty("user.home") + "/arachneDB/c_queries/" + schemaName + "/" + key + ".sql";
                    break;
                default:
                    throw new RuntimeException("Invalid schema provided");
            }
            PrintWriter pw = new PrintWriter(filename, "UTF-8");
            pw.println(sqlQry + ";");
            pw.flush();
            pw.close();
        } catch (Exception | AssertionError e) {
            System.out.println("failed: " + key);
            e.printStackTrace();
        }
    }

    public static void convertLeftDeepToBushy(ProfileRel trueRoot, int ordinal, ProfileRel root, int size) {
        ProfileRel newRoot = root;
        ProfileRel parent = null;
        List<ProfileRel> parents = new ArrayList<>();
        for (int i = 0; i < size; i++) {
            parent = newRoot;
            parents.add(parent);
            newRoot = (ProfileRel)newRoot.getInput(0);
        }

        ProfileRel leftChild = (ProfileRel)newRoot.getInput(0);
        ProfileRel rightDangler = (ProfileRel)newRoot.getInput(1);
        newRoot.replaceInput(0, rightDangler);
        newRoot.replaceInput(1, leftChild);

        ProfileRel curr = newRoot;
        for (int i = size - 1; i >= 0; i--) {
            curr.replaceInput(0, parents.get(i));
            curr = parents.get(i);
        }
        parents.get(0).replaceInput(0, rightDangler);
        trueRoot.replaceInput(ordinal, newRoot);
    }

    public static void fixQuery88(ProfileRel root) {
        ProfileRel joinRoot = (ProfileRel)root.getInput(0);
        convertLeftDeepToBushy(root, 0, joinRoot, 3);
        joinRoot = (ProfileRel)root.getInput(0);
        convertLeftDeepToBushy(joinRoot, 0, (ProfileRel)joinRoot.getInput(0), 1);
    }

    public static void testMatch(String key, String schemaName) throws Exception {
        MonetaryNodeType type = MonetaryNodeType.GCP;
        RelNode relTree = null;
        ProfileRel relTree2 = null;
        try {
            String filePath;
            ArachneSchema schema;
            if (schemaName.equals("tpcds")) {
                filePath = System.getProperty("user.home") + "/arachneDB/a_queries/" + key + ".sql";
                schema = Schemas.tpcdsSchema;
            } else if (schemaName.equals("ldbc")) {
                filePath = System.getProperty("user.home") + "/arachneDB/ldbc/queries/a_queries/" + key + ".sql";
                schema = Schemas.ldbcSchema;
            } else {
                throw new RuntimeException("Illegal schema name provided;");
            }

            double bigQueryReadSize = bigQueryReadSize(key, schemaName);
            double baselineRuntime, baselineRuntimeCalcite;
            String qry = new String(Files.readAllBytes(Paths.get(filePath))); // query text
            baselineRuntime = baselineRuntime(key, type.getInputString(), schemaName); // runtime for static runtime cost system
            baselineRuntimeCalcite = baselineRuntime(key, type.getInputString() + "_c", schemaName); // runtime for sql preop
            if (baselineRuntime == -1 || baselineRuntimeCalcite == -1) {
                throw new Exception("Baseline for query " + key + " not run");
            }

            qry = qry.replaceAll(";", ""); // calcite will not process semicolons
            String profile_name = key + "_profile.json";
            Optimizer optimizer = Optimizer.create(schema);
            relTree = convertQuery(optimizer, qry);
            RuleSet lRules = (key.equals("80")) ? logicalRules_80 : logicalRules;
            relTree = optimizer.convertLogical(relTree, lRules);
            relTree2 = optimizer.createProfile(relTree);

            if (key.equals("88"))
                fixQuery88(relTree2);

            // print("AFTER PROFILE", relTree2);
            ProfileGraph graph = matchProfile(relTree2, profile_name, schemaName);
            QueryMetadata qm = new QueryMetadata(key, bigQueryReadSize, baselineRuntime, baselineRuntimeCalcite, 1.48, 0.0, type);
            System.out.println("duckdb: $" + qm.rCost() +  " calcite: $" + qm.rcCost() + " bigquery: $" + qm.sCost());
            AlgorithmicCollector ac = new AlgorithmicCollector(qm, optimizer, qry, logicalRules, relTree2, schemaName, 0);
            ac.test();

        } catch (Exception | AssertionError  e) {
            System.out.println("failed: " + key);
            e.printStackTrace();
            e.printStackTrace();
            if (relTree2 != null)
                print("ERROR:", relTree2);
            else if (relTree != null)
                print("ERROR:", relTree);
            String fname = System.getProperty("user.home") + "/arachneDB/data/" + key + ".done";
            new PrintWriter(fname, "UTF-8").close(); // ensure that in case of exception we stop iterating
        }
    }

    // mvn exec:java -Dexec.mainClass=org.arachne.ArachneQueryProcessor -Dexec.args="single duck tpcds 59 1.48 0"
    public static void main(String[] args) throws Exception {
        if (args.length == 2) {
            testMatch(args[0], args[1]);
            return;
        }

        String mode = args[0];
        MonetaryNodeType type;
        switch (args[1]) {
            case "rs":
                type = MonetaryNodeType.RS;
                break;
            case "duck":
                type = MonetaryNodeType.GCP;
                break;
            case "psql":
                type = MonetaryNodeType.PSQL;
                break;
            case "monet":
                type = MonetaryNodeType.SPECTRUM;
                break;
            default:
                throw new RuntimeException("Illegal argument provided, not rs, duck, or psql for type");
        }
        // args[2] is the schema type
        String schemaName = args[2];

        if (mode.equals("calcify")) {
            String key;
            if (schemaName.equals("tpcds")) {
                int i = Integer.parseInt(args[3]);
                key = "" + i;
                if (i < 10)
                    key = "0" + key;
            } else if (schemaName.equals("ldbc")) {
                key = args[3];
            } else if (schemaName.equals("tpch")) {
                key = args[3];
            } else if (schemaName.equals("imdb")) {
                key = args[3];
            } else if (schemaName.equals("custom")) {
                key = args[3];
            } else {
                throw new RuntimeException("Illegal schema name provided; should be tpcds, ldbc");
            }
            calcifyQuery(key, type, schemaName);
        } else if (mode.equals("single")) {
            String key;
            if (schemaName.equals("tpcds")) {
                int i = Integer.parseInt(args[3]);
                key = "" + i;
                if (i < 10)
                    key = "0" + key;
            } else if (schemaName.equals("ldbc")) {
                key = args[3];
            } else {
                throw new RuntimeException("Illegal schema name provided; should be tpcds, ldbc");
            }

            double cost = Double.parseDouble(args[4]);
            double mvmt = (args.length > 4) ? Double.parseDouble(args[5]) : 0;
            System.out.println(key + " " + cost + " " + mvmt + " " + type);
            if (args.length == 7) {
                int iteration = Integer.parseInt(args[6]);
                runIteration(key, type, schemaName, cost, mvmt, true, iteration);
            } else {
                run(key, type, schemaName, cost, mvmt, true);
            }
        }
    }
}
