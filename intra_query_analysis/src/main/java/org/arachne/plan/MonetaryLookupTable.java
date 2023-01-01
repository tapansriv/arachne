package org.arachne.plan;

import org.apache.calcite.util.Pair;

import java.util.HashMap;
import java.util.Map;

/**
 * This class contains the lookup table for the costs of moving data between locations
 * The plan is to define this statically and insert this into MonetaryRel (interfaces allow for static variables)
 * Then each physical node in the MonetaryConvention should have easy access to this lookup table within computeSelfCost
 */
public class MonetaryLookupTable {
    private Map<Pair<MonetaryNodeType, MonetaryNodeType>, Double> lookupTable;
}
