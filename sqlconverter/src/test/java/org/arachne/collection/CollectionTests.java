package org.arachne.collection;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.tools.RuleSet;
import org.arachne.ArachneQueryProcessor;
import org.arachne.common.ArachneBaseTest;
import org.arachne.common.Schemas;
import org.arachne.optimizer.Optimizer;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.ProfileGraph;
import org.arachne.profiling.rel.ProfileRel;
import org.junit.Test;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.*;

import static org.arachne.common.Queries.*;


public class CollectionTests extends ArachneBaseTest {


    @Test public void testBaseline() throws Exception {
        String key = "11";
        String src = "duck";
        String src2 = "rs";
        System.out.println(ArachneQueryProcessor.baselineRuntime(key, src, "tpcds"));
        System.out.println(ArachneQueryProcessor.baselineRuntime(key, src2, "tpcds"));
    }

    public void run(String key) {
        RelNode relTree = null;
        ProfileRel relTree2 = null;
        try {
            String filePath = System.getProperty("user.home") + "/arachneDB/a_queries/" + key + ".sql";
            String qry = new String(Files.readAllBytes(Paths.get(filePath)));
            qry = qry.replaceAll(";", "");
            String profile_name = key + "/" + key + "_final.json";
            Optimizer optimizer = Optimizer.create(Schemas.tpcdsSchema);
            relTree = ArachneQueryProcessor.convertQuery(optimizer, qry);
            RuleSet lRules = ArachneQueryProcessor.logicalRules;
            relTree = optimizer.convertLogical(relTree, lRules);
            relTree2 = optimizer.createProfile(relTree);
            CardinalityEstimator est = new CardinalityEstimator();
            est.computeTables(relTree2);
            System.out.println(est.tableNames);
            System.out.println(est.cardinality);
            System.out.println(est.extraSizeGB);
        } catch (Exception | AssertionError e) {
            System.out.println("failed: " + key);
            e.printStackTrace();
        }
    }

    @Test public void testCardEstimation() {
        String key = "07";
        run(key);
    }

    @Test public void testInitialSplit() throws Exception {
        String qry = qry13;
        // String qry = noWindow;

        try {
            Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
            Connection conn = DriverManager.getConnection("jdbc:duckdb:/home/cc/arachne.db");
            Statement stmt = conn.createStatement();
            stmt.execute("PRAGMA memory_limit='118G'");
            Optimizer optimizer = Optimizer.create(Schemas.tpcdsSchema);
            RelNode relTree = convertQuery(optimizer, qry);

            relTree = optimizer.convertLogical(relTree, logicalRules);
            print("AFTER LOGICAL", relTree);

            // ProfileCollector pc = new ProfileCollector(optimizer, qry, relTree, logicalRules);
            // pc.initialSplit();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }
}
