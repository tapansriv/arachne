package org.arachne.profiling;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.RelVisitor;
import org.apache.calcite.rel.logical.LogicalFilter;
import org.apache.calcite.rel.logical.LogicalProject;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProfileVisitor extends RelVisitor {
    public Map<RelNode, ProfileNode> profileMap;
    public ProfileGraph graph;
    public ProfileNode current;

    public ProfileVisitor(ProfileGraph graph) {
        this.profileMap = new HashMap<RelNode, ProfileNode>();
        this.graph = graph;
        this.current = this.graph.root;
    }

    public String getClassName(ProfileNode node) {
        switch(node.getOpName()) {
            case "PROJECTION":
            case "WINDOW":
                return "LogicalProject";
            case "UNION":
                return "LogicalUnion";
            case "FILTER":
                return "LogicalFilter";
            case "TOP_N":
                return "LogicalSort";
            case "HASH_GROUP_BY":
                return "LogicalAggregate";
            case "HASH_JOIN":
                return "LogicalJoin";
            case "SEQ_SCAN":
                return "LogicalTableScan";
            default:
                return "";
        }
    }
    /**
     * Override the visitor function to locate places where data movement operators need to be implemented.
     * We split the physical tree
     *
     * @param node
     * @param ordinal
     * @param parent
     */
    @Override
    public void visit(RelNode node, int ordinal, @Nullable RelNode parent) {
        System.out.println(node.getDigest());
        current = current.getChild(ordinal);

        String profileOp = getClassName(current);
        String className = node.getRelTypeName();
        System.out.println(profileOp);
        System.out.println(className);
        if (!profileOp.equals(className))
        {
            if (profileOp.equals("LogicalProject")) {
                current = current.getChild(0);
                profileMap.put(node, current);
            } else if (className.equals("LogicalProject")) {
                ProfileNode dummy = new ProfileNode(current.getCardinality(), 0.0, "PROJECTION", null);
                profileMap.put(node, dummy);
                node = ((LogicalProject)node).getInput();
            } else if (className.equals("LogicalFilter") && profileOp.equals("LogicalTableScan")) {
                ProfileNode dummy = new ProfileNode(current.getCardinality(), 0.0, "FILTER", null);
                profileMap.put(node, dummy);
                node = ((LogicalFilter)node).getInput();
            } else {
                System.out.println("HELLLLLLLP WE HAVE A PROFILING MISMATCH NOT BASED ON PROJECTS");
            }
        }

        System.out.println(current.getDigest());
        List<RelNode> inputs = node.getInputs();
        System.out.println("inputs size: " + inputs.size());

        for (int i = 0; i < inputs.size(); i++) {
            RelNode c = inputs.get(i);
            visit(c, i, node);
            current = current.getParent();
        }
    }
}
