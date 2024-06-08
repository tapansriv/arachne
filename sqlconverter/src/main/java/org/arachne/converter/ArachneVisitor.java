package org.arachne.converter;

import org.apache.calcite.rel.RelVisitor; 
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.rel.RelNode;
import org.apache.calcite.rex.RexNode;
import org.apache.calcite.rex.RexCall;
import org.apache.calcite.rex.RexLiteral;
import org.apache.calcite.rex.RexVariable;
import org.apache.calcite.rex.RexInputRef;
import org.apache.calcite.rel.RelVisitor;
import org.apache.calcite.rel.RelWriter;
import org.apache.calcite.util.ImmutableBitSet;
import org.apache.calcite.rel.core.*;
import org.apache.calcite.rel.externalize.RelWriterImpl;
import org.apache.calcite.rel.type.RelDataTypeField;
import org.apache.calcite.util.ControlFlowException;
import javax.annotation.Nullable;
import java.util.List;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Collections;

import org.apache.calcite.util.Pair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ArachneVisitor extends RelVisitor {
    
    private ArachneSqlGraph graph;
    // private List<Pair<AggregateCall, String>> namedAggCalls;
    private List<String> visitorInputs;
    private List<String> visitorPrefixes; // must have same length as visitorInputs
    public Map<Integer, String> aggregateAliases; // mapping between index of agg in inputs and name, for subquery processing

    public ArachneVisitor() {
        this.graph = new ArachneSqlGraph();
        this.aggregateAliases = new HashMap<Integer, String>();
    }

    public String toString() {
        return this.graph.toString();
    }

    public List<String> getInputs() { return this.visitorInputs; }
    public List<String> getPrefixes() { return this.visitorPrefixes; }

    private String parseRexExpressionField(RexNode expr, List<RelDataTypeField> inputs) {
        int size = inputs.size();
        List<String> newInputs = new ArrayList<String>();
        // System.out.println(newInputs.size());
        for (int i = 0; i < size; i++) {
            String name = inputs.get(i).getName();
            newInputs.add(name); 
        }
        return parseRexExpression(expr, newInputs, visitorPrefixes);
    }

    private String parseRexExpression(RexNode expr, List<String> inputs, List<String> prefixes) {
        if (expr instanceof RexVariable) {
            int inputIndex = ((RexInputRef)expr).getIndex();
            String columnName;
            if (prefixes.get(inputIndex).equals("")) {
                columnName = inputs.get(inputIndex);
            } else {
                columnName = String.format("%s.%s", prefixes.get(inputIndex), inputs.get(inputIndex));
            }
            return columnName;
        } else if (expr instanceof RexCall) {
            String operator = ((RexCall)expr).getOperator().toString();
            List<RexNode> operands = ((RexCall)expr).getOperands();
            if (operands.size() == 1) {
                String operand = parseRexExpression(operands.get(0), inputs, prefixes);
                String result = String.format("%s(%s)", operator, operand);
                return result;
            } else if (operands.size() == 2) {
                String left = parseRexExpression(operands.get(0), inputs, prefixes);
                String right = parseRexExpression(operands.get(1), inputs, prefixes);
                String result = String.format("(%s %s %s)", left, operator, right);
                return result;
            } else {
                System.out.println("ternary rex operator"); 
            }
        } else if (expr instanceof RexLiteral){
            return expr.toString();
        } else {
            System.out.println("UNEXPECTED REX SUBCLASS");
        }
        return "";
    }

    public ArachneSqlGraph getGraph() {
        return this.graph; 
    }

    @Override
    public void visit(final RelNode node, final int ordinal, @Nullable final RelNode parent) {

        if (node instanceof Join) {
            // recurse then do join stuff 

            // node.getRowType().getFieldList().forEach(field -> System.out.println(field));
            // System.out.println("JOIN _------");
            // System.out.println(node.getInput(0).getRowType().getFieldNames());
            // System.out.println(node.getInput(1).getRowType().getFieldNames());
            // System.out.println(node.getRowType().getFieldNames());
            Join n = (Join)node;
            // System.out.println(inputs);
            // System.out.println(n.getInputs());
            // System.out.println("-----");

            ArachneVisitor leftVisitor = new ArachneVisitor();
            ArachneVisitor rightVisitor = new ArachneVisitor();
            leftVisitor.go(n.getLeft());
            rightVisitor.go(n.getRight());
            System.out.println("JOIN2-----");
            System.out.println(leftVisitor.getInputs());
            System.out.println(rightVisitor.getInputs());
            System.out.println(leftVisitor.getGraph());

            List<String> modInputs = new ArrayList<String>(leftVisitor.getInputs());
            List<String> modPrefix;
            if (leftVisitor.getGraph().isSubQuery()) {
                modPrefix = new ArrayList<String>(modInputs.size() + rightVisitor.getInputs().size());
                String alias = "t1";
                for (int i = 0; i < leftVisitor.getInputs().size(); i++) {
                    modPrefix.add(alias);
                }
            } else {
                modPrefix = new ArrayList<String>(leftVisitor.getPrefixes());
            }
            leftVisitor.aggregateAliases.forEach((k,v) -> modInputs.set(k, v));

            modInputs.addAll(rightVisitor.getInputs());
            if (rightVisitor.getGraph().isSubQuery()) {
                String alias = "t2";
                for (int i = 0; i < rightVisitor.getInputs().size(); i++) {
                    modPrefix.add(alias);
                }
            } else {
                modPrefix.addAll(rightVisitor.getPrefixes());
            }
            rightVisitor.aggregateAliases.forEach((k,v) -> modInputs.set(k, v));
            System.out.println(modInputs);
            System.out.println(modPrefix);

            List<ArachneSqlGraph> children = new ArrayList<ArachneSqlGraph>(2);
            children.add(leftVisitor.getGraph());
            children.add(rightVisitor.getGraph());

            List<String> attributes = new ArrayList<String>(1);
            attributes.add(parseRexExpression(n.getCondition(), modInputs, modPrefix));
            System.out.println(n.getCondition());
            System.out.println(modInputs);
            System.out.println(modPrefix);
            System.out.println(attributes);

            visitorInputs = modInputs;
            visitorPrefixes = modPrefix;
            ArachneSqlNode join = new ArachneSqlNode(ArachneNodeType.JOIN, attributes, children);
            this.graph.insertFront(join);

            // System.out.println(n.getLeft().getRowType().getFieldNames());
            // System.out.println(n.getRight().getRowType().getFieldNames());
            // System.out.println("-----");
            // System.out.println(n.getCondition());
            // System.out.println(parseRexExpression(n.getCondition(), visitorInputs));
            // System.out.println("join");
            return;
        } else if (node instanceof TableScan) {
            // real end of recursion
            System.out.println("table scan");
            List<String> attributes = new ArrayList<String>();
            TableScan ts = (TableScan)node;
            int numTables = ts.getTable().getQualifiedName().size();
            if (numTables == 0 || numTables > 1) {
                System.out.println("UNEXPECTED NUMBER OF TABLES IN TABLESCAN NODE"); 
            } else {
                String tableName = ts.getTable().getQualifiedName().get(0);
                attributes.add(tableName);
                String alias = tableName;
                if (tableName.endsWith(".parquet")) {
                    int size = tableName.length() - 8;
                    alias = tableName.substring(0, size);
                    attributes.add(alias);
                }
                List<String> modInputs = new ArrayList<String>(node.getRowType().getFieldList().size());
                List<String> modPrefix = new ArrayList<String>(modInputs.size());
                // node.getRowType().getFieldList().jorEach(field -> 
                // System.out.println(String.format("%s.%s", node.getTable().getQualifiedName(), field.getName())));
                // System.out.println(node.getRowType().getFieldNames());

                for (String fieldName : node.getRowType().getFieldNames()) {
                    // modInputs.add(String.format("%s.%s", tableName, alias));
                    modInputs.add(fieldName);
                    modPrefix.add(alias);
                }
                visitorInputs = modInputs;
                visitorPrefixes = modPrefix;
                System.out.println(modInputs);
                System.out.println(modPrefix);
                ArachneSqlNode scan = new ArachneSqlNode(ArachneNodeType.TABLE_SCAN, attributes, null);
                this.graph.insertFront(scan);
            }
            return;
        } else {
            super.visit(node, ordinal, parent); // visit children first
            if (node instanceof Project) {
                System.out.println("select");
                Project pn = (Project)node;
                List<RexNode> projects = pn.getProjects();
                List<String> modInputs = new ArrayList<String>(visitorInputs.size());
                List<String> modPrefix = new ArrayList<String>(visitorInputs.size());

                // System.out.println(pn.getNamedProjects());
                // List<RelDataTypeField> inputs = node.getInput(0).getRowType().getFieldList();
                // System.out.println(inputs);
                System.out.println(visitorInputs);
                System.out.println(node.getRowType().getFieldNames());
                for (int i = 0; i < projects.size(); i++) {
                    RexNode p = projects.get(i);
                    if (p instanceof RexVariable) {
                        int inputIndex = ((RexInputRef)p).getIndex();
                        modInputs.add(visitorInputs.get(inputIndex));
                        modPrefix.add(visitorPrefixes.get(inputIndex)); 
                        if (aggregateAliases.containsKey(inputIndex)) {
                            aggregateAliases.put(i, aggregateAliases.remove(inputIndex)); 
                        }
                    } else {
                        String exp = parseRexExpression(p,visitorInputs, visitorPrefixes);
                        modInputs.add(exp);
                        modPrefix.add("");
                    }
                }
                // projects.forEach(p -> modInputs.add(parseRexExpression(p, visitorInputs, visitorPrefixes)));
                System.out.println(modInputs);
                System.out.println(modPrefix);
                visitorInputs = modInputs;
                visitorPrefixes = modPrefix;
            }

            if (node instanceof Aggregate) {
                System.out.println("---- group by");
                Aggregate n = (Aggregate)node;
                System.out.println(visitorInputs);

                List<String> groupBy = new ArrayList<String>();
                List<String> groupByPrefix = new ArrayList<String>();
                List<String> modInputs = new ArrayList<String>();
                List<String> modPrefix = new ArrayList<String>();

                for (Integer i : n.getGroupSet().asList()) {
                    modInputs.add(visitorInputs.get(i));
                    modPrefix.add(visitorPrefixes.get(i));

                    String value = aggregateAliases.get(i);
                    if (value != null) {
                        groupBy.add(value);
                        groupByPrefix.add("");
                    } else {
                        groupBy.add(visitorInputs.get(i));
                        groupByPrefix.add(visitorPrefixes.get(i));
                    }
                }
                // n.getGroupSet().asList().forEach(i -> groupBy.add(visitorInputs.get(i)));

                int index = modInputs.size();
                // System.out.println(groupBy);
                // System.out.println(node.getRowType().getFieldList());
                // System.out.println(n.getNamedAggCalls());

                for (Pair<AggregateCall, String> nd : n.getNamedAggCalls()) {
                    String opName = nd.getKey().getAggregation().toString(); // SUM or AVG, etc.
                    String alias = nd.getValue(); // NAME in SUM(x) as NAME
                    System.out.println(nd);
                    int size = nd.getKey().getArgList().size();

                    if (size == 0) {
                        opName = String.format("%s(*) AS %s", opName, alias);
                    } else if (size == 1) {
                        Integer opIndex = nd.getKey().getArgList().get(0);
                        String args = visitorInputs.get(opIndex);
                        opName = String.format("%s(%s) AS %s", opName, args, alias);
                    } else {
                        System.out.println("UNEXPECTED BEHAVIOR");
                    }
                    aggregateAliases.put(index, alias);
                    index++;
                    modInputs.add(opName);
                    modPrefix.add("");
                    // modPrefix.add(alias);
                }
                System.out.println(modInputs);
                System.out.println(modPrefix);
                visitorInputs = modInputs;
                visitorPrefixes = modPrefix;
                List<String> attributes = new ArrayList<String>(groupBy.size());
                for (int i = 0; i < groupBy.size(); i++) {
                    if (groupByPrefix.get(i).equals(""))
                        attributes.add(groupBy.get(i));
                    else
                        attributes.add(String.format("%s.%s", groupByPrefix.get(i), groupBy.get(i)));
                }
                ArachneSqlNode gb = new ArachneSqlNode(ArachneNodeType.GROUP_BY, attributes, null);
                this.graph.insertBack(gb);
            }

            if (node instanceof Sort) {
                System.out.println("------ order by");
                System.out.println(node.getInput(0).getRowType().getFieldList());
                System.out.println(node.getRowType().getFieldList());
                Sort n = (Sort)node;
                List<String> attributes = new ArrayList<String>();
                System.out.println(n.getSortExps());
                // n.getSortExps().forEach(f -> attributes.add(parseRexExpression(f, visitorInputs, visitorPrefixes)));
                for (RexNode f : n.getSortExps()) {
                    if (f instanceof RexVariable) {
                        int inputIndex = ((RexInputRef)f).getIndex();
                        String alias = aggregateAliases.get(inputIndex);
                        if (alias != null) {
                            attributes.add(alias);
                        } else {
                            attributes.add(parseRexExpression(f, visitorInputs, visitorPrefixes));
                        }
                    } else {
                        attributes.add(parseRexExpression(f, visitorInputs, visitorPrefixes));
                    }
                }
                System.out.println(visitorInputs);
                System.out.println(visitorPrefixes);
                System.out.println(attributes);
                ArachneSqlNode orderBy = new ArachneSqlNode(ArachneNodeType.ORDER_BY, attributes, null);
                this.graph.insertBack(orderBy);
            }

            if (node instanceof Filter) {
                Filter f = (Filter) node;
                RexCall rn = (RexCall)f.getCondition();
                String output = parseRexExpression(rn, visitorInputs, visitorPrefixes);
                // System.out.println(node.getInput(0).getRowType().getFieldList());
                // System.out.println(node.getRowType().getFieldList());
                List<String> attributes = new ArrayList<String>();
                attributes.add(output);
                ArachneSqlNode where = new ArachneSqlNode(ArachneNodeType.WHERE, attributes, null);
                this.graph.insertBack(where);
                System.out.println("where");
            }
            
            
            if (parent == null) { // root node
                System.out.println("root");
                ArachneSqlNode select = this.graph.getSelect();
                List<String> attributes = new ArrayList<String>(visitorInputs.size());
                System.out.println(visitorInputs);
                System.out.println(visitorPrefixes);
                for (int i = 0; i < visitorInputs.size(); i++) {
                    if (visitorPrefixes.get(i).equals("")) {
                        attributes.add(visitorInputs.get(i));
                    } else {
                        attributes.add(String.format("%s.%s", visitorPrefixes.get(i), visitorInputs.get(i)));
                    }
                }

                if (select != null) {
                    select.setAttributes(attributes);
                } else {
                    select = new ArachneSqlNode(ArachneNodeType.SELECT, attributes, null);
                    this.graph.insertFront(select);
                    this.graph.setSelect(select);
                    System.out.println(visitorInputs);
                    System.out.println(select.getAttributes());
                    System.out.println(this.graph);
                }
            }
        }

    }
}
