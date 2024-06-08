package org.arachne.plan;

import org.apache.calcite.plan.DeriveMode;
import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptPlanner;
import org.apache.calcite.plan.RelTraitSet;
import org.apache.calcite.plan.volcano.RelSubset;
import org.apache.calcite.rel.PhysicalNode;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.metadata.RelMetadataQuery;
import org.apache.calcite.rel.type.RelDataTypeField;
import org.apache.calcite.util.Pair;

import org.arachne.cost.ArachneRelOptCostFactory;
import org.arachne.plan.abstracts.AbstractMonetaryAggregate;
import org.arachne.plan.abstracts.AbstractMonetaryProject;
import org.arachne.profiling.rel.ProfileRel;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.List;

/**
*/
public interface MonetaryRel
    extends PhysicalNode {

    MonetaryNodeType getType();
    MonetaryLocation getLocation();
    MonetaryRel setTiming(Double timing);
    MonetaryRel setCard(Long card);

    Double getTiming();
    Long getCard();

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

    default MonetaryRel copyProfileData(MonetaryRel from) {
        setCard(from.getCard());
        setTiming(from.getTiming());
        return this;
    }

    default Double computeMovementCost(Double numBytes,
                                       @Nullable MonetaryNodeType source,
                                       @Nullable MonetaryNodeType dest) {
        // TODO: here's where to link lookup table, do sort of easy matching now that we have real cardinality
        // TODO: for initial test (1/14) we assume Spectrum + Redshift, so movement is free
        if (source == null || dest == null || source == dest)
            return 0.0;
        return 0.0;
    }

    default Double computeDC2Cost(Double timing, Double numBytes) {
        return 0.77 * (timing / 3600.0);
    }

    default Double computeSpectrumCost(Double timing, Double numBytes, MonetaryNodeType inputType) {
        if (inputType == MonetaryNodeType.SPECTRUM){
            return 0.0;
        } else {
            Double numTB = numBytes / 1_000_000_000_000.0;
            return 5 * numTB;
        }
    }

    default Double computeMonetaryCost(Double timing,
                                       Double numBytes,
                                       MonetaryNodeType selfType,
                                       MonetaryNodeType inputType) {
        switch (selfType) {
            case DC2:
                return (computeDC2Cost(timing, numBytes));
            case SPECTRUM:
                return computeSpectrumCost(timing, numBytes, inputType);
            case DC28:
            case DS2:
            case DS28:
            case GCP:
            case RA3x1:
            case RA34:
            case RA136:
            default:
                return -1.0;
        }
    }

    default Double estimateRowSize(RelNode r) {
        Double size = 0.0;
        // System.out.println(r.getRowType().getFieldList());
        for (RelDataTypeField tf : r.getRowType().getFieldList()) {
            String s = tf.getType().toString();
            if (s.startsWith("DECIMAL")) {
                String[] ss = s.split(",");
                Integer precision = Integer.valueOf(ss[0].substring(8));
                // String s2 = ss[1].substring(0, ss[1].length() - 1);
                if (precision < 10)
                    size += 5;
                else if (precision < 20)
                    size += 9;
                else if (precision < 29)
                    size += 13;
                else
                    size += 17;
            } else {
                switch (s) {
                    case "VARCHAR":
                    case "BIGINT":
                    case "INTEGER":
                        size += 8;
                        break;
                    default:
                        // System.out.println(new StringBuilder().append("UNKNOWN TYPE: ").append(s).toString());
                        size += 8;
                        break;
                }
            }
        }
        return size;
    }

    @Nullable
    default RelOptCost computeSelfCostSingleInput(RelOptPlanner planner, RelMetadataQuery mq, @Nullable RelNode input) {
        ArachneRelOptCostFactory factory = (ArachneRelOptCostFactory) planner.getCostFactory();
        // Double rowSize = mq.getAverageRowSize(this);
        // Double rowSize = 180.0;
        Double rowSize = estimateRowSize(this);
        Double numBytes = 0.0;

        MonetaryNodeType selfType = getType();
        MonetaryNodeType inputType;

        if (input == null) {
            inputType = null;
            numBytes = getCard() * rowSize;
        } else if (input instanceof RelSubset) {
            RelSubset subset = (RelSubset) input;
            MonetaryRel rel = (MonetaryRel)subset.getBest();
            if (rel == null)
                throw new RuntimeException("no best node from subset");
            inputType = rel.getType();
            numBytes = rel.getCard() * estimateRowSize(rel);
        } else {
            MonetaryRel rel = (MonetaryRel)input;
            inputType = rel.getType();
            numBytes = rel.getCard() * estimateRowSize(rel);

        }
        Double mvmntCost = computeMovementCost(numBytes, selfType, inputType);
        Double cost = computeMonetaryCost(getTiming(), numBytes, selfType, inputType);

        if (this instanceof AbstractMonetaryProject && (selfType == MonetaryNodeType.SPECTRUM || selfType == MonetaryNodeType.DC2) && (getCard() == 11 || getCard() == 1)) {
            Double specCost = computeMonetaryCost(getTiming(), numBytes, MonetaryNodeType.SPECTRUM, inputType);
            Double dc2Cost = computeMonetaryCost(getTiming(), numBytes, MonetaryNodeType.DC2, inputType);
            System.out.println("PROJECT-------------------CHECK");
            if (((AbstractMonetaryProject) this).containsOver())
                System.out.println("WINDOW");
            String s = new StringBuilder().append(getTiming()).append(" ,").append(getCard()).append(" , ").append(numBytes).toString();
            System.out.println(s);
            System.out.println(specCost);
            System.out.println(dc2Cost);
            System.out.println(cost);
            System.out.println("PROJECT-------------------CHECK");
            if (selfType == MonetaryNodeType.SPECTRUM) // TODO don't actually do this
                cost = 10.0;
        }

        if (cost == -1) {
            return factory.makeInfiniteCost();
        } else if (cost == 0) {
            // System.out.println(selfType + " " + inputType);
            return factory.makeZeroCost();
        } else {
            return factory.makeCost(getCard(), getTiming(), numBytes, cost + mvmntCost);
        }
    }

    @Nullable
    default RelOptCost computeSelfCostMultiInput(RelOptPlanner planner, RelMetadataQuery mq, List<RelNode> inputs) {
        ArachneRelOptCostFactory factory = (ArachneRelOptCostFactory) planner.getCostFactory();
        Double timePerRow = 0.0000010992533223322238;
        // Double numBytes = getCard() * rowSize; // TODO assuming card of join is total # rows, viz. sum of all inputs
        // Double rowSize = mq.getAverageRowSize(this);
        // Double rowSize = 180.0;

        MonetaryNodeType selfType = getType();
        Double numBytes = 0.0;
        Double mvmntCosts = 0.0;
        Double cost = 0.0;
        for (RelNode input : inputs) {
            MonetaryNodeType inputType = null;
            MonetaryRel rel = null;
            if (input == null) {
                inputType = null;
            } else if (input instanceof RelSubset) {
                RelSubset subset = (RelSubset) input;
                rel = (MonetaryRel)subset.getBest();
                if (rel == null)
                    throw new RuntimeException("no best node from subset");
                inputType = rel.getType();
            } else {
                rel = (MonetaryRel)input;
                inputType = rel.getType();
            }

            Double rowSize = estimateRowSize(input);
            Double inputNumBytes = rel.getCard() * rowSize;
            numBytes += inputNumBytes;

            mvmntCosts += computeMovementCost(inputNumBytes, selfType, inputType);
            if (selfType == MonetaryNodeType.SPECTRUM) {
                cost += computeMonetaryCost(getTiming(), inputNumBytes, selfType, inputType);
            } else if (selfType == MonetaryNodeType.DC2 && selfType != inputType) {
                Double readTime = rel.getCard() * timePerRow;
                cost += computeMonetaryCost(readTime, inputNumBytes, selfType, inputType);
            }

        }

        if (selfType != MonetaryNodeType.SPECTRUM) {
            cost += computeMonetaryCost(getTiming(), numBytes, selfType, null);
        }

        cost = (cost < -1) ? -1 : cost;
        if (cost == -1) {
            return factory.makeInfiniteCost();
        } else if (cost == 0) {
            return factory.makeZeroCost();
        } else {
            return factory.makeCost(getCard(), getTiming(), numBytes, cost + mvmntCosts);
        }
    }

    @Override
    default @Nullable RelOptCost computeSelfCost(RelOptPlanner planner, RelMetadataQuery mq) {
        ArachneRelOptCostFactory factory = (ArachneRelOptCostFactory) planner.getCostFactory();
        List<RelNode> inputs = getInputs();
        int numInputs = inputs.size();

        if (numInputs > 1) { // if multiple inputs, subclass and override
            return computeSelfCostMultiInput(planner, mq, inputs);
        } else {
            RelNode input = (numInputs == 1) ? inputs.get(0) : null;
            return computeSelfCostSingleInput(planner, mq, input);
        }
    }

}
