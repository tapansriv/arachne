package org.arachne;

import org.arachne.collection.Collector;
import org.arachne.common.ArachneBaseTest;
import org.arachne.common.Schemas;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.ProfileGraph;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.optimizer.Optimizer;

import static org.arachne.common.Queries.*;
import org.apache.calcite.rel.RelNode;

import org.junit.Test;

import java.util.HashSet;
import java.util.Set;
import java.util.Stack;

/**
 *
 */
public class PipelineTests extends ArachneBaseTest
{
    @Test public void test_profile() throws Exception {
        // String qry = testqry2;
        String qry = qry13;
        // String profile_name = System.getProperty("user.home") + "/67_123.json";
        String profile_name = "67_123.json";
        Optimizer optimizer = Optimizer.create(Schemas.tpcdsSchema);
        RelNode relTree = convertQuery(optimizer, qry);
        // print("AFTER CONVERSION", relTree);
        relTree = optimizer.convertLogical(relTree, logicalRules);

        // print("AFTER LOGICAL", relTree);
        // relTree = optimizer.convertProfile(relTree, relTree.getTraitSet().plus(ProfileConvention.INSTANCE), profileRules);
        ProfileRel relTree2 = optimizer.createProfile(relTree);
        // print("AFTER PROFILE", relTree2);

        ProfileGraph graph = matchProfile(relTree2, profile_name);
        Collector c = new Collector(optimizer, qry, logicalRules, graph,
                    relTree2, 930_370_000_000d, 55655.0, 55655.0, "/tmp/out.txt",
                    MonetaryNodeType.GCP, "tpcds", 1.48d, 0);
        c.go();
        // print("AFTER MATCH", relTree);

        // RelNode optimizerRelTree = optimizer.optimize(
        //         relTree,
        //         relTree.getTraitSet().plus(MonetaryConvention.INSTANCE),
        //         monetaryRules
        // );
        // print("AFTER OPTIMIZATION", optimizerRelTree);

        // PhysicalPlanProcessor ppp = new PhysicalPlanProcessor(optimizerRelTree, optimizer.getConverter());
        // ppp.start();
    }

    public void traverse(RelNode node, Optimizer optimizer) {
        Stack<RelNode> dfs = new Stack<>();
        Set<RelNode> seen = new HashSet<>();
        dfs.push(node);

        while (!dfs.empty()) {
            RelNode curr = dfs.pop();
            optimizer.createNodeByType(curr);
            for (RelNode input : curr.getInputs()) {
                dfs.push(input);
            }
        }
    }

    @Test public void testConversion() throws Exception {
        String qry = qry13;
        String profile_name = "67_123.json";
        Optimizer optimizer = Optimizer.create(Schemas.tpcdsSchema);
        RelNode relTree = convertQuery(optimizer, qry);
        // print("AFTER CONVERSION", relTree);
        relTree = optimizer.convertLogical(relTree, logicalRules);
        print("AFTER LOGICAL", relTree);
        // traverse(relTree, optimizer);
        ProfileRel relTree2 = optimizer.createProfile(relTree);
        // relTree = optimizer.convertProfile(relTree, relTree.getTraitSet().plus(ProfileConvention.INSTANCE), profileRules);
        print("AFTER PROFILE", relTree2);
    }
}
