package org.arachne.profiling.rel;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.*;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.CorrelationId;
import org.apache.calcite.rel.core.Join;
import org.apache.calcite.rel.core.JoinRelType;
import org.apache.calcite.rex.RexNode;

import java.util.List;
import java.util.Set;

public class ProfileJoin extends Join implements ProfileRel {

    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileJoin(RelOptCluster cluster,
                          RelTraitSet traitSet,
                          RelNode left,
                          RelNode right,
                          RexNode condition,
                          Set<CorrelationId> variablesSet,
                          JoinRelType joinType) {
        super(cluster, traitSet, ImmutableList.of(), left, right, condition, variablesSet, joinType);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    public static ProfileJoin create(RelNode left,
                                     RelNode right,
                                     RexNode condition,
                                     Set<CorrelationId> variableSet,
                                     JoinRelType joinType) {
        final RelOptCluster cluster = left.getCluster();
        final RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE);
        return new ProfileJoin(cluster, traitSet, left, right, condition, variableSet, joinType);
    }

    @Override
    public Join copy(RelTraitSet traitSet,
                     RexNode condition,
                     RelNode left,
                     RelNode right,
                     JoinRelType joinType,
                     boolean semiJoinDone) {
        return (Join) new ProfileJoin(getCluster(), traitSet, left, right, condition, variablesSet, joinType)
                                     .copyProfileData(this);
    }

    @Override
    public Long getCardinality() { return this.card; }

    @Override
    public Double getTiming() { return timing; }

    @Override
    public void setCardinality(Long card) { this.card = card; }

    @Override
    public void setTiming(Double timing) { this.timing = timing; }

    @Override
    public int getArachneID() {
        return this.arachneId;
    }

    @Override
    public double getOpportunity() {
        return this.opportunity;
    }

    @Override
    public double getRealSave() {
        return this.realSave;
    }

    @Override
    public List<RelNode> getParents() {
        return this.parents;
    }

    @Override
    public void setArachneId(int id) {
        this.arachneId = id;
    }

    @Override
    public void setOpportunity(double opp) {
        this.opportunity = opp;
    }

    @Override
    public void setRealSave(double rs) {
        this.realSave = rs;
    }

    @Override
    public void setParents(List<RelNode> parents) {
        this.parents = parents;
    }
}