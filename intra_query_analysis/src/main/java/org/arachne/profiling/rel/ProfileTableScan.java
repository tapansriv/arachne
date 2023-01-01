package org.arachne.profiling.rel;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollationTraitDef;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.TableScan;
import org.apache.calcite.rel.hint.RelHint;
import org.apache.calcite.schema.Table;

import java.util.List;

public class ProfileTableScan extends TableScan implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    protected ProfileTableScan(RelOptCluster cluster, RelTraitSet traitSet, List<RelHint> hints, RelOptTable table) {
        super(cluster, traitSet, hints, table);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }

    protected ProfileTableScan(RelOptCluster cluster, RelTraitSet traitSet, RelOptTable table) {
        this(cluster, traitSet, ImmutableList.of(), table);
    }

    public static ProfileTableScan create(RelOptCluster cluster, RelOptTable relOptTable) {
        Table table = relOptTable.unwrap(Table.class);
        RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE).replaceIfs(RelCollationTraitDef.INSTANCE, () -> {
            return (List)(table != null ? table.getStatistic().getCollations() : ImmutableList.of());
        });
        return new ProfileTableScan(cluster, traitSet, relOptTable);
    }

    @Override public RelNode copy(RelTraitSet traitSet, List<RelNode> inputs) {
        return new ProfileTableScan(getCluster(), traitSet, table).copyProfileData(this);
    }

    @Override
    public Long getCardinality() { return this.card; }

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