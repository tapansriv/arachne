package org.arachne.cost;

import org.apache.calcite.plan.RelOptCost;
import org.apache.calcite.plan.RelOptCostFactory;
import org.apache.calcite.plan.RelOptUtil;

public class ArachneCostImpl implements ArachneRelOptCost {

    double rowCount;
    double cpu;
    double io;
    double money;

    static final ArachneCostImpl INFINITY =
            new ArachneCostImpl(Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY) {
                @Override
                public String toString() {
                    return "{inf}";
                }
            };

    static final ArachneCostImpl HUGE =
            new ArachneCostImpl(Double.MAX_VALUE,
                    Double.MAX_VALUE,
                    Double.MAX_VALUE,
                    Double.MAX_VALUE) {
                @Override
                public String toString() {
                    return "{huge}";
                }
            };

    static final ArachneCostImpl TINY =
            new ArachneCostImpl(0,
                    0,
                    0,
                    1) {
                @Override
                public String toString() {
                    return "{tiny}";
                }
            };

    static final ArachneCostImpl ZERO =
            new ArachneCostImpl(0,
                    0,
                    0,
                    0) {
                @Override
                public String toString() {
                    return "{zero}";
                }
            };

    public static final RelOptCostFactory FACTORY = new ArachneCostFactory();

    public ArachneCostImpl(double rowCount, double cpu, double io, double money) {
        this.rowCount = rowCount;
        this.cpu = cpu;
        this.io = io;
        this.money = money;
    }

    @Override public double getRows() { return rowCount; }

    @Override public double getCpu() { return cpu; }

    @Override public double getIo() { return io; }

    @Override
    public double getMonetaryCost() { return money; }

    @Override public boolean isInfinite() {
        return Double.isInfinite(money);
    }

    @Override public boolean equals(RelOptCost var1){
        if (var1 instanceof ArachneRelOptCost) {
            ArachneRelOptCost v1 = (ArachneRelOptCost)var1;
            return v1.getMonetaryCost() == money;
        }
        return false;
    }

    @Override public boolean isEqWithEpsilon(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return (Math.abs(this.money - that.getMonetaryCost()) < RelOptUtil.EPSILON);
    }

    @Override public boolean isLe(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return (this.getMonetaryCost() <= that.getMonetaryCost());
    }

    @Override public boolean isLt(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return (this.getMonetaryCost() < that.getMonetaryCost());
    }

    @Override public RelOptCost plus(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return new ArachneCostImpl(rowCount, cpu, io, this.money + that.getMonetaryCost());
    }

    @Override public RelOptCost minus(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return new ArachneCostImpl(rowCount, cpu, io, this.money - that.getMonetaryCost());
    }

    @Override public RelOptCost multiplyBy(double var1){
        return new ArachneCostImpl(rowCount, cpu, io, this.money * var1);
    }

    @Override public double divideBy(RelOptCost var1){
        ArachneRelOptCost that = (ArachneRelOptCost) var1;
        return this.money / that.getMonetaryCost();
    }

    @Override public String toString(){
        return "{" + rowCount + " rows, " + cpu + " cpu, " + io + " io, " + money + " money}";
    }

    public static class ArachneCostFactory implements ArachneRelOptCostFactory {

        @Override
        public RelOptCost makeCost(double rowCount, double cpu, double io, double money) {
            return new ArachneCostImpl(rowCount, cpu, io, money);
        }

        @Override
        public RelOptCost makeCost(double v, double v1, double v2) {
            return new ArachneCostImpl(v, v1, v2, 0);
        }

        @Override
        // public RelOptCost makeHugeCost() { return ArachneCostImpl.HUGE; }
        public RelOptCost makeHugeCost() {
            return new ArachneCostImpl(Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY);
        }

        @Override
        public RelOptCost makeInfiniteCost() {
            return new ArachneCostImpl(Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY,
                    Double.POSITIVE_INFINITY);
        }

        @Override
        public RelOptCost makeTinyCost() {
            return new ArachneCostImpl(0,
                    0,
                    0,
                    0.00000001);
        }

        @Override
        public RelOptCost makeZeroCost() {
            return new ArachneCostImpl(0,
                    0,
                    0,
                    0);
        }
    }

}
