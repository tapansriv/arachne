package org.arachne.profiling.rules;

import org.apache.calcite.plan.Convention;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.convert.ConverterRule;
import org.apache.calcite.rel.core.Project;
import org.apache.calcite.rel.logical.LogicalProject;
import org.arachne.profiling.rel.ProfileConvention;
import org.arachne.profiling.rel.ProfileProject;

public class ProfileProjectRule extends ConverterRule {
    public static final ConverterRule.Config DEFAULT_CONFIG;

    public ProfileProjectRule(ConverterRule.Config config) {
        super(config);
    }

    public RelNode convert(RelNode rel) {
        Project project = (Project)rel;
        return ProfileProject.create(
                convert(project.getInput(),
                        project.getInput().getTraitSet().replace(ProfileConvention.INSTANCE)),
                project.getProjects(),
                project.getRowType());
    }

    static {
        DEFAULT_CONFIG = ((ConverterRule.Config) ConverterRule.Config.EMPTY.as(ConverterRule.Config.class)).withConversion(LogicalProject.class, (p) -> {
            return true;
        }, Convention.NONE, ProfileConvention.INSTANCE, "ProfileProjectRule").withRuleFactory(ProfileProjectRule::new);
    }

}
