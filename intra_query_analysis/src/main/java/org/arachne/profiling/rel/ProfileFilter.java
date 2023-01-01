package org.arachne.profiling.rel;

import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollationTraitDef;
import org.apache.calcite.rel.RelDistributionTraitDef;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Filter;
import org.apache.calcite.rel.logical.LogicalFilter;
import org.apache.calcite.rel.metadata.RelMdCollation;
import org.apache.calcite.rel.metadata.RelMdDistribution;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rex.RexNode;

import java.util.List;

public class ProfileFilter extends Filter implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileFilter(RelOptCluster cluster, RelTraitSet traits, RelNode child, RexNode condition) {
        super(cluster, traits, child, condition);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    @Override
    public Filter copy(RelTraitSet traitSet, RelNode child, RexNode condition) {
        return (Filter) new ProfileFilter(getCluster(), traitSet, child, condition).copyProfileData(this);
    }

    public static ProfileFilter create(final RelNode input, RexNode condition) {
        final RelOptCluster cluster = input.getCluster();
        final RelMetadataQuery mq = cluster.getMetadataQuery();
        final RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE)
                .replaceIfs(RelCollationTraitDef.INSTANCE, () -> RelMdCollation.filter(mq, input))
                .replaceIf(RelDistributionTraitDef.INSTANCE, () -> RelMdDistribution.filter(mq, input));
        return new ProfileFilter(cluster, traitSet, input, condition);
    }

    @Override
    public Long getCardinality() { return this.card; }

    @Override
    public Double getTiming() { return this.timing; }

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