package org.arachne.profiling.rel;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.Convention;
import org.apache.calcite.plan.RelOptCluster;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.rel.RelCollationTraitDef;
import org.apache.calcite.rel.RelDistributionTraitDef;
import org.apache.calcite.rel.RelInput;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.core.Values;
import org.apache.calcite.rel.logical.LogicalValues;
import org.apache.calcite.rel.metadata.RelMdCollation;
import org.apache.calcite.rel.metadata.RelMdDistribution;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rel.type.RelDataType;
import org.apache.calcite.rex.RexLiteral;

import java.util.List;

public class ProfileValues extends Values implements ProfileRel {
    protected Long card;
    protected Double timing;
    protected int arachneId;
    protected double opportunity;
    protected double realSave;
    protected List<RelNode> parents;

    protected ProfileValues(RelOptCluster cluster, RelDataType rowType, ImmutableList<ImmutableList<RexLiteral>> tuples, RelTraitSet traits) {
        super(cluster, rowType, tuples, traits);
        this.arachneId = -1;
        this.opportunity = -1;
        this.realSave = -1;
        this.parents = null;
    }
    protected ProfileValues(RelInput input) {
        this(input.getCluster(), input.getRowType("type"), input.getTuples("tuples"), input.getTraitSet());
    }

    public static ProfileValues create(RelOptCluster cluster, RelDataType rowType, ImmutableList<ImmutableList<RexLiteral>> tuples) {
        RelMetadataQuery mq = cluster.getMetadataQuery();
        RelTraitSet traitSet = cluster.traitSetOf(ProfileConvention.INSTANCE).replaceIfs(RelCollationTraitDef.INSTANCE, () -> {
            return RelMdCollation.values(mq, rowType, tuples);
        }).replaceIf(RelDistributionTraitDef.INSTANCE, () -> {
            return RelMdDistribution.values(rowType, tuples);
        });
        return new ProfileValues(cluster, rowType, tuples, traitSet);
    }

    public RelNode copy(RelTraitSet traitSet, List<RelNode> inputs) {
        assert traitSet.containsIfApplicable(Convention.NONE);
        assert inputs.isEmpty();
        return new ProfileValues(this.getCluster(), this.getRowType(), this.tuples, traitSet);
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
