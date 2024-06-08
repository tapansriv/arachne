package org.arachne.collection;

import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Join;
import org.apache.calcite.rel.core.Project;
import org.arachne.common.QueryExecutionGraph;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.rel.ProfileRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

public class IntegrateProfile {

    public IntegrateProfile() {}


    public static void traverse(RelNode lNode, @Nullable RelNode lParent, ProfileRel pNode, @Nullable ProfileRel pParent, ProfileMetadata pm) {
        // do matching of profile
        ProfileMetadata.ProfileInfo pi = pm.metadataMap.get(lNode);
        pNode.setTiming(pi.timing);
        pNode.setCardinality(pi.cardinality);

        List<RelNode> inputs = lNode.getInputs();
        List<RelNode> refInputs = pNode.getInputs();
        int size = inputs.size();
        for (int i = 0; i < size; i++) {
            RelNode input = inputs.get(i);
            ProfileRel pInput = (ProfileRel)refInputs.get(i);
            traverse(input, lNode, pInput, pNode, pm);
        }
    }
}
