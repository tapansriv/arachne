package org.arachne.profiling.rel;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollationTraitDef;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Project;
import org.apache.calcite.rel.hint.RelHint;
import org.apache.calcite.rel.metadata.RelMdCollation;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rel.type.RelDataType;
import org.apache.calcite.rex.RexNode;

import java.util.List;

public class ProfileProject extends Project implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    public ProfileProject(RelOptCluster cluster, RelTraitSet traitSet, List<RelHint> hints,
                          RelNode input, List<? extends RexNode> projects, RelDataType rowType) {
        super(cluster, traitSet, hints, input, projects, rowType);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    public ProfileProject(RelOptCluster cluster, RelTraitSet traitSet, RelNode input,
                          List<? extends RexNode> projects, RelDataType rowType) {
        this(cluster, traitSet, ImmutableList.of(), input, projects, rowType);
    }

    public static ProfileProject create(RelNode input, List<? extends RexNode> projects, RelDataType rowType) {
        RelOptCluster cluster = input.getCluster();
        RelMetadataQuery mq = cluster.getMetadataQuery();
        RelTraitSet traitSet = cluster.traitSet().replace(ProfileConvention.INSTANCE)
                .replaceIfs(RelCollationTraitDef.INSTANCE, () -> {
                    return RelMdCollation.project(mq, input, projects);
                });
        return new ProfileProject(cluster, traitSet, input, projects, rowType);
    }

    @Override public ProfileProject copy(RelTraitSet traitSet, RelNode input,
                                         List<RexNode> projects, RelDataType rowType) {
        return (ProfileProject) new ProfileProject(getCluster(), traitSet, input, projects, rowType)
                .copyProfileData(this);
    }

    @Override
    public Long getCardinality() {
        return this.card;
    }

    @Override
    public Double getTiming() {
        return timing;
    }

    @Override
    public void setCardinality(Long card) {
        this.card = card;
    }

    @Override
    public void setTiming(Double timing) {
        this.timing = timing;
    }

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