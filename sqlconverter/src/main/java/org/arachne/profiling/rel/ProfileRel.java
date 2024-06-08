package org.arachne.profiling.rel;

import org.apache.calcite.plan.DeriveMode;
import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptPlanner;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.plan.volcano.RelSubset;
import org.apache.calcite.rel.PhysicalNode;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.util.Pair;
import org.arachne.cost.ArachneRelOptCostFactory;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.plan.MonetaryRel;
import org.arachne.profiling.ProfileNode;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.ArrayList;
import java.util.List;

public interface ProfileRel extends PhysicalNode {
    Long getCardinality();
    Double getTiming();
    int getArachneID();
    double getOpportunity();
    double getRealSave();
    @Nullable List<RelNode> getParents();

    void setCardinality(Long card);
    void setTiming(Double timing);
    void setArachneId(int id);
    void setOpportunity(double opp);
    void setRealSave(double rs);
    void setParents(List<RelNode> parents);

    default void addParent(RelNode p) {
        List<RelNode> ps = getParents();
        if (ps == null) {
            ps = new ArrayList<>();
        }
        ps.add(p);
        setParents(ps);
    }

    // TODO: Potentially add some interface methods here. Right now main EnumerableRel function wasn't applicable (probably)
    //~ Methods ----------------------------------------------------------------
    @Override default @Nullable Pair<RelTraitSet, List<RelTraitSet>> passThroughTraits(RelTraitSet required) {
        return null;
    }

    @Override default @Nullable Pair<RelTraitSet, List<RelTraitSet>> deriveTraits(RelTraitSet childTraits,
                                                                                  int childId) {
        return null;
    }

    @Override default DeriveMode getDeriveMode() {
        return DeriveMode.LEFT_FIRST;
    }

    default ProfileRel copyProfileData(ProfileRel from) {
        setCardinality(from.getCardinality());
        setTiming(from.getTiming());
        setArachneId(getArachneID());
        setOpportunity(getOpportunity());
        setRealSave(getRealSave());
        setParents(getParents());
        return this;
    }

    @Override
    default boolean deepEquals(@Nullable Object o) {
        return false;
    }

    @Override default @Nullable RelOptCost computeSelfCost(RelOptPlanner planner, RelMetadataQuery mq) {
        ArachneRelOptCostFactory factory = (ArachneRelOptCostFactory) planner.getCostFactory();
        return factory.makeCost(getCardinality(), getTiming(), 0, getOpportunity());
    }
}
