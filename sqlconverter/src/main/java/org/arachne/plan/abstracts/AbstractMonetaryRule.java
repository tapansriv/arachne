package org.arachne.plan.abstracts;

import org.apache.calcite.rel.convert.ConverterRule;

public abstract class AbstractMonetaryRule extends ConverterRule {

    protected AbstractMonetaryRule(Config config) {
        super(config);
    }

}
