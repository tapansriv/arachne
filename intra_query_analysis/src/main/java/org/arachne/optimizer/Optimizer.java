package org.arachne.optimizer;

// internal project imports
import org.apache.calcite.config.NullCollation;
import org.apache.calcite.plan.*;
import org.apache.calcite.plan.hep.HepPlanner;
import org.apache.calcite.plan.hep.HepProgramBuilder;
import org.apache.calcite.rel.logical.LogicalIntersect;
import org.arachne.cost.ArachneCostImpl;
import org.arachne.profiling.rel.ProfileRel;
import org.arachne.profiling.rules.*;
import org.arachne.schema.ArachneSchema;

// calcite imports
import org.apache.calcite.avatica.util.Casing;
import org.apache.calcite.sql.util.SqlOperatorTables;
import org.apache.calcite.config.CalciteConnectionConfig;
import org.apache.calcite.config.CalciteConnectionConfigImpl;
import org.apache.calcite.config.CalciteConnectionProperty;
import org.apache.calcite.jdbc.CalciteSchema;
import org.apache.calcite.jdbc.JavaTypeFactoryImpl;
import org.apache.calcite.plan.volcano.VolcanoPlanner;
import org.apache.calcite.prepare.CalciteCatalogReader;
import org.apache.calcite.prepare.Prepare;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rel.RelRoot;
import org.apache.calcite.rel.type.RelDataTypeFactory;
import org.apache.calcite.rex.RexBuilder;
import org.apache.calcite.sql.SqlNode;
import org.apache.calcite.sql.SqlOperatorTable;
import org.apache.calcite.sql.fun.SqlStdOperatorTable;
import org.apache.calcite.sql.parser.SqlParser;
import org.apache.calcite.sql.validate.SqlValidator;
import org.apache.calcite.sql.validate.SqlValidatorUtil;
import org.apache.calcite.sql2rel.SqlToRelConverter;
import org.apache.calcite.sql2rel.StandardConvertletTable;
import org.apache.calcite.tools.Program;
import org.apache.calcite.tools.Programs;
import org.apache.calcite.tools.RuleSet;
import org.apache.calcite.tools.RuleSets;
import org.checkerframework.checker.nullness.qual.Nullable;

// general imports
import java.util.*;

public class Optimizer {

    private final CalciteConnectionConfig config;
    private final SqlValidator validator;
    private final SqlToRelConverter converter;
    private final VolcanoPlanner planner;
    private final VolcanoPlanner planner2;
    private HepPlanner hPlanner;

    private Map<RelNode, ProfileRel> seen = new HashMap<>();

    public Optimizer(
            CalciteConnectionConfig config,
            SqlValidator validator,
            SqlToRelConverter converter,
            VolcanoPlanner planner,
            VolcanoPlanner planner2) {
        this.config = config;
        this.validator = validator;
        this.converter = converter;
        this.planner = planner;
        this.planner2 = planner2;
    }

    public SqlToRelConverter getConverter() { return converter; }

    public static Optimizer create(ArachneSchema schema) {
        RelDataTypeFactory typeFactory = new JavaTypeFactoryImpl();

        Properties configProperties = new Properties();
        configProperties.put(CalciteConnectionProperty.CASE_SENSITIVE.camelName(), Boolean.TRUE.toString());
        configProperties.put(CalciteConnectionProperty.UNQUOTED_CASING.camelName(), Casing.UNCHANGED.toString());
        configProperties.put(CalciteConnectionProperty.QUOTED_CASING.camelName(), Casing.UNCHANGED.toString());
        CalciteConnectionConfig config = new CalciteConnectionConfigImpl(configProperties);

        CalciteSchema rootSchema = CalciteSchema.createRootSchema(false, false);
        rootSchema.add(schema.getSchemaName(), schema);
        Prepare.CatalogReader catalogReader = new CalciteCatalogReader(
            rootSchema,
            Collections.singletonList(schema.getSchemaName()),
            typeFactory,
            config
        );

        SqlOperatorTable operatorTable = SqlOperatorTables.chain(SqlStdOperatorTable.instance());


        SqlValidator.Config validatorConfig = SqlValidator.Config.DEFAULT
            .withLenientOperatorLookup(config.lenientOperatorLookup())
            .withSqlConformance(config.conformance())
            // .withDefaultNullCollation(config.defaultNullCollation())
            .withDefaultNullCollation(NullCollation.LAST)
            .withCallRewrite(true)
            .withIdentifierExpansion(true);

        SqlValidator validator = SqlValidatorUtil.newValidator(operatorTable, catalogReader, typeFactory, validatorConfig);

        VolcanoPlanner planner = new VolcanoPlanner(ArachneCostImpl.FACTORY, Contexts.of(config));
        VolcanoPlanner planner2 = new VolcanoPlanner(ArachneCostImpl.FACTORY, Contexts.of(config));
        planner.addRelTraitDef(ConventionTraitDef.INSTANCE);
        planner2.addRelTraitDef(ConventionTraitDef.INSTANCE);

        RelOptCluster cluster = RelOptCluster.create(planner, new RexBuilder(typeFactory));

        SqlToRelConverter.Config converterConfig = SqlToRelConverter.configBuilder()
            .withTrimUnusedFields(true)
            .withExpand(false) // https://issues.apache.org/jira/browse/CALCITE-1045
            .build();

        SqlToRelConverter converter = new SqlToRelConverter(
            null,
            validator,
            catalogReader,
            cluster,
            StandardConvertletTable.INSTANCE,
            converterConfig
        );

        return new Optimizer(config, validator, converter, planner, planner2);
    }

    public SqlNode parse(String sql) throws Exception {
        SqlParser.Config parserConfig = SqlParser.config()
                .withCaseSensitive(config.caseSensitive())
                .withUnquotedCasing(config.unquotedCasing())
                .withQuotedCasing(config.quotedCasing())
                .withConformance(config.conformance());
        SqlParser parser = SqlParser.create(sql, parserConfig);
        return parser.parseStmt();
    }

    public SqlNode validate(SqlNode node) {
        return validator.validate(node);
    }

    public RelNode convert(SqlNode node) {
        RelRoot root = converter.convertQuery(node, false, true);

        return root.rel;
    }

    public RelNode convertLogical(RelNode node, RuleSet rules) {
        HepProgramBuilder hpBuilder = new HepProgramBuilder();
        rules.forEach((rule) -> {
            hpBuilder.addRuleInstance(rule);
        });
        this.hPlanner = new HepPlanner(hpBuilder.build());
        this.hPlanner.setRoot(node);
        return this.hPlanner.findBestExp();
    }

    public ProfileRel createNodeByType(RelNode node) {
        String name = node.getRelTypeName();
        System.out.println(name);
        switch(name) {
            case "LogicalAggregate":
                return (ProfileRel) new ProfileAggregateRule(ProfileAggregateRule.DEFAULT_CONFIG).convert(node);
            case "LogicalFilter":
                return (ProfileRel) new ProfileFilterRule(ProfileFilterRule.DEFAULT_CONFIG).convert(node);
            case "LogicalJoin":
                return (ProfileRel) new ProfileJoinRule(ProfileJoinRule.DEFAULT_CONFIG).convert(node);
            case "LogicalProject":
                return (ProfileRel) new ProfileProjectRule(ProfileProjectRule.DEFAULT_CONFIG).convert(node);
            case "LogicalSort":
                return (ProfileRel) new ProfileSortRule(ProfileSortRule.DEFAULT_CONFIG).convert(node);
            case "LogicalTableScan":
                return (ProfileRel) new ProfileTableScanRule(ProfileTableScanRule.DEFAULT_CONFIG).convert(node);
            case "LogicalUnion":
                return (ProfileRel) new ProfileUnionRule(ProfileUnionRule.DEFAULT_CONFIG).convert(node);
            case "LogicalIntersect":
                return (ProfileRel) new ProfileIntersectRule(ProfileIntersectRule.DEFAULT_CONFIG).convert(node);
            // case "LogicalCorrelate":
            //     return (ProfileRel) new ProfileCorrelateRule(ProfileCorrelateRule.DEFAULT_CONFIG).convert(node);
            case "LogicalMinus":
                return (ProfileRel) new ProfileMinusRule(ProfileMinusRule.DEFAULT_CONFIG).convert(node);
            case "LogicalValues":
                return (ProfileRel) new ProfileValuesRule(ProfileValuesRule.DEFAULT_CONFIG).convert(node);
            default:
                System.out.println("no match");
                break;
        }
        return null;
    }

    public ProfileRel createProfile(RelNode node) {
        ProfileRel newNode;
        if (seen.containsKey(node)) {
            newNode = seen.get(node);
            // parent.replaceInput(ordinal, cache);
        } else {
            newNode = createNodeByType(node);
            seen.put(node, newNode);
        }
        int size = node.getInputs().size();
        for (int i = 0; i < size; i++) {
            RelNode child = node.getInput(i);
            ProfileRel newChild = createProfile(child);
            newNode.replaceInput(i, newChild);
        }
        return newNode;
    }

    public RelNode convertProfile(RelNode node, RelTraitSet requiredTraitSet, RuleSet rules) {
        Program program = Programs.of(RuleSets.ofList(rules));

        return program.run(
                planner,
                node,
                requiredTraitSet,
                Collections.emptyList(),
                Collections.emptyList()
        );
    }

    public RelNode optimize(RelNode node, RelTraitSet requiredTraitSet, RuleSet rules) {
        Program program = Programs.of(RuleSets.ofList(rules));

        return program.run(
            planner,
            node,
            requiredTraitSet,
            Collections.emptyList(),
            Collections.emptyList()
        );
    }
}
