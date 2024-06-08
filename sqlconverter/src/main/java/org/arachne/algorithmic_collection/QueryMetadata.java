package org.arachne.algorithmic_collection;

import org.arachne.plan.MonetaryNodeType;

public class QueryMetadata {
    public final double bigQueryReadSize;
    public final double baselineRuntime;
    public final double baselineRuntimeCalcite;
    public final double cost;
    public final double movement;
    public final String key;
    public final MonetaryNodeType source;

    public QueryMetadata(String key, double bigQueryReadSize, double baselineRuntime, double baselineRuntimeCalcite,
                         double cost, double movement, MonetaryNodeType source) {
        this.key = key;
        this.bigQueryReadSize = bigQueryReadSize;
        this.baselineRuntime = baselineRuntime;
        this.baselineRuntimeCalcite = baselineRuntimeCalcite;
        this.cost = cost;
        this.movement = movement;
        this.source = source;
    }

    public double minBaseline() {
        double loadTimeCost = (9.344 / 3600) * this.cost;

        double sCost = (this.bigQueryReadSize / 1_000_000_000) * 0.005; // BQ cost straightup
        double rCost = (this.baselineRuntime / 3600) * this.cost; // RS/DuckDB cost vanilla
        double rcCost = (this.baselineRuntimeCalcite / 3600) * this.cost; // RS/DuckDB cost through calcite
        rCost = rCost + loadTimeCost;
        rcCost = rcCost + loadTimeCost;
        return Math.min(Math.min(sCost, rCost), rcCost);
    }

    public double rCost() {
        double loadTimeCost = (9.344 / 3600) * this.cost;
        double rCost = (this.baselineRuntime / 3600) * this.cost; // RS/DuckDB cost vanilla
        rCost = rCost + loadTimeCost;
        return rCost;
    }
    public double rcCost() {
        double loadTimeCost = (9.344 / 3600) * this.cost;
        double rcCost = (this.baselineRuntimeCalcite / 3600) * this.cost; // RS/DuckDB cost through calcite
        rcCost = rcCost + loadTimeCost;
        return rcCost;
    }
    // public double sCost() {
    //     return ((this.bigQueryReadSize / 1_000_000_000) * 0.005); // BQ cost straightup
    // }
    public double sCost() {
        return ((this.bigQueryReadSize / 1_073_741_824) * 0.005); // BQ cost straightup use 2^30 as metric
    }
}
