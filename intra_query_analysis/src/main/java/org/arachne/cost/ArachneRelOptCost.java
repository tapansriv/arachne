package org.arachne.cost;

import org.apache.calcite.plan.RelOptCost;

public interface ArachneRelOptCost extends RelOptCost {
    double getMonetaryCost();
}
