package org.arachne.profile_test;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.RelVisitor;
import org.arachne.profiling.ProfileNode;
import org.checkerframework.checker.nullness.qual.Nullable;
import org.apache.calcite.plan.volcano.VolcanoRuleCall;

import java.util.Map;

public class LoadProfileVisitor extends RelVisitor {

    Map<RelNode, ProfileNode> profileMap;

    public LoadProfileVisitor(Map<RelNode, ProfileNode> pMap) { this.profileMap = pMap; }

    @Override
    public void visit(RelNode node, int ordinal, @Nullable RelNode parent) {
        if (!profileMap.containsKey(node)) {
            System.out.println("mismatch");
            System.out.println(node.getDigest());
        }

        if (node.getInputs().size() == 0) {
            ProfileNode p = profileMap.get(node);
            System.out.println("VERIFY " + node.getDigest() + " " + node.hashCode());
            System.out.println(p.getDigest());
        }
        super.visit(node, ordinal, parent);
    }
}
