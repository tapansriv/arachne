package org.arachne.cost;

import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptCostFactory;

public interface ArachneRelOptCostFactory extends RelOptCostFactory {
    RelOptCost makeCost(double rowCount, double cpu, double io, double money);
}
