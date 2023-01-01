package org.arachne.common;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.RelWriter;
import org.apache.calcite.rel.externalize.RelWriterImpl;
import org.apache.calcite.rel.rules.CoreRules;
import org.apache.calcite.sql.SqlExplainLevel;
import org.apache.calcite.sql.SqlNode;
import org.apache.calcite.tools.RuleSet;
import org.apache.calcite.tools.RuleSets;
import org.arachne.collection.ArachneRelWriter;
import org.arachne.optimizer.Optimizer;
import org.arachne.plan.MonetaryConvention;
import org.arachne.profiling.ProfileGraph;
import org.arachne.profiling.ProfileMatcher;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.profiling.rules.ProfileRelRules;
import org.arachne.schema.ArachneSchema;

import java.io.PrintWriter;
import java.io.StringWriter;

public class ArachneBaseTest {
    protected static RuleSet logicalRules = RuleSets.ofList(
            CoreRules.FILTER_INTO_JOIN,
            CoreRules.FILTER_SCAN,
            CoreRules.JOIN_CONDITION_PUSH,
            CoreRules.JOIN_ADD_REDUNDANT_SEMI_JOIN,
            CoreRules.JOIN_TO_SEMI_JOIN,
//            CoreRules.JOIN_TO_MULTI_JOIN,
            CoreRules.PROJECT_TO_SEMI_JOIN,
            CoreRules.PROJECT_JOIN_TRANSPOSE,
//            CoreRules.PROJECT_MULTI_JOIN_MERGE,
            CoreRules.SEMI_JOIN_FILTER_TRANSPOSE,
            CoreRules.SEMI_JOIN_JOIN_TRANSPOSE,
            CoreRules.SEMI_JOIN_PROJECT_TRANSPOSE,
            CoreRules.SEMI_JOIN_REMOVE,
            CoreRules.PROJECT_FILTER_TRANSPOSE,
            CoreRules.AGGREGATE_CASE_TO_FILTER,
            CoreRules.FILTER_PROJECT_TRANSPOSE
    );

    protected static RuleSet profileRules = RuleSets.ofList(ProfileRelRules.PROFILE_RULES);

    public RelNode convertQuery(Optimizer optimizer, String qry) throws Exception {
        SqlNode sqlTree = optimizer.parse(qry);
        SqlNode validatedSqlTree = optimizer.validate(sqlTree);
        return optimizer.convert(validatedSqlTree);
    }

    public ProfileGraph matchProfile(ProfileRel relTree, String filename) {
        ProfileGraph graph = new ProfileGraph();
        graph.parseProfile(filename, "tpcds");
        ProfileMatcher profileMatcher = new ProfileMatcher(graph);
        profileMatcher.goMatchCard(relTree);
        return graph;
        // profileMatcher.go(relTree); // annotate graph
    }

    protected void print(String header, RelNode relTree) {
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
}
