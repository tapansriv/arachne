package org.arachne.profiling.rules;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptRule;

import java.util.List;

public class ProfileRelRules {
    private ProfileRelRules() {}

    public static final ProfileAggregateRule PROFILE_AGGREGATE_RULE;
    public static final ProfileFilterRule PROFILE_FILTER_RULE;
    public static final ProfileJoinRule PROFILE_JOIN_RULE;
    public static final ProfileProjectRule PROFILE_PROJECT_RULE;
    public static final ProfileSortRule PROFILE_SORT_RULE;
    public static final ProfileTableScanRule PROFILE_TABLE_SCAN_RULE;
    public static final ProfileUnionRule PROFILE_UNION_RULE;
    public static final List<RelOptRule> PROFILE_RULES;

    static {
        PROFILE_AGGREGATE_RULE = (ProfileAggregateRule) ProfileAggregateRule.DEFAULT_CONFIG.toRule(ProfileAggregateRule.class);
        PROFILE_FILTER_RULE = (ProfileFilterRule) ProfileFilterRule.DEFAULT_CONFIG.toRule(ProfileFilterRule.class);
        PROFILE_JOIN_RULE = (ProfileJoinRule) ProfileJoinRule.DEFAULT_CONFIG.toRule(ProfileJoinRule.class);
        PROFILE_PROJECT_RULE = (ProfileProjectRule)ProfileProjectRule.DEFAULT_CONFIG.toRule(ProfileProjectRule.class);
        PROFILE_SORT_RULE = (ProfileSortRule) ProfileSortRule.DEFAULT_CONFIG.toRule(ProfileSortRule.class);
        PROFILE_TABLE_SCAN_RULE = (ProfileTableScanRule)ProfileTableScanRule.DEFAULT_CONFIG.toRule(ProfileTableScanRule.class);
        PROFILE_UNION_RULE = (ProfileUnionRule) ProfileUnionRule.DEFAULT_CONFIG.toRule(ProfileUnionRule.class);

        PROFILE_RULES = ImmutableList.of(
                PROFILE_AGGREGATE_RULE,
                PROFILE_FILTER_RULE,
                PROFILE_JOIN_RULE,
                PROFILE_PROJECT_RULE,
                PROFILE_SORT_RULE,
                PROFILE_TABLE_SCAN_RULE,
                PROFILE_UNION_RULE
        );
    }
}
