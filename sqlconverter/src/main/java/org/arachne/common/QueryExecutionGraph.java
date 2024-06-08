package org.arachne.common;

import org.apache.calcite.rel.RelNode;
import org.arachne.plan.MonetaryNodeType;
import org.checkerframework.checker.nullness.qual.Nullable;

import java.util.*;

public class QueryExecutionGraph {

    protected String query;
    protected String outTableName;
    public MonetaryNodeType source;
    public MonetaryNodeType destination;
    protected int numChildren;
    public RelNode root;
    public double cost = 0.0d;

    protected Double runtime = -1.0; // runtime in seconds
    protected Long cardinality = -1L;
    public boolean profile; // is this a profile job or not; indicates whether we need to collect card, timing info

    protected @Nullable QueryExecutionGraph parent;
    protected List<QueryExecutionGraph> children;

    public QueryExecutionGraph(String qry, MonetaryNodeType src, MonetaryNodeType dest) {
        this(qry, null, src, dest, 0);
    }

    public QueryExecutionGraph(String qry, String outTableName, MonetaryNodeType src, MonetaryNodeType dest) {
        this(qry, outTableName, src, dest, 0);
    }

    public QueryExecutionGraph(String qry, String outTableName, MonetaryNodeType src, MonetaryNodeType dest, int num) {
        this(qry, outTableName, src, dest, num, false);
    }

    public QueryExecutionGraph(String qry,
                               String outTableName,
                               MonetaryNodeType src,
                               MonetaryNodeType dest,
                               int num,
                               boolean profile)
    {
        this.query = qry;
        this.outTableName = outTableName;
        this.source = src;
        this.destination = dest;
        this.numChildren = num;
        this.profile = profile;
        parent = null;
        children = new ArrayList<>();
    }

    public static QueryExecutionGraph buildDependencies(Queue<QueryExecutionGraph> queries) {
        Stack<QueryExecutionGraph> seen = new Stack<>();
        while (!queries.isEmpty()) {
            QueryExecutionGraph curr = queries.remove();
            int numChildren = curr.getNumChildren();
            System.out.println(seen);
            while (numChildren > 0) {
                QueryExecutionGraph child = seen.pop();
                curr.addChild(child);
                child.setParent(curr);
                numChildren--;
            }
            seen.push(curr);
        }
        if (seen.size() != 1)
            throw new RuntimeException("error in building dependencies: multiple roots left");
        return seen.pop();
    }

    public void setNumChildren(int num) { this.numChildren = num; }
    public int getNumChildren() { return numChildren; }
    public void addChild(QueryExecutionGraph q) { this.children.add(q); }
    public List<QueryExecutionGraph> getChildren() { return this.children; }
    public void setParent(QueryExecutionGraph p) { this.parent = p; }

    public String getQuery() { return query; }
    public @Nullable String getOutTableName() { return outTableName; }
    public MonetaryNodeType getSource() { return source; }
    public MonetaryNodeType getDestination() { return destination; }

    public Double getRuntime() { return runtime; }
    public Long getCardinality() { return cardinality; }

    public void setRuntime(Double r) {
        assert r >= 0.0;
        runtime = r;
    }

    public void setCardinality(Long c) {
        // assert c > 0;
        cardinality = c;
    }

    public String toString() {
        String out = new StringBuilder()
                .append("CTAS: ")
                .append(outTableName)
                .append(" SRC: ")
                .append(source)
                .append(" DEST: ")
                .append(destination)
                .append(" NUM INPUTS: ")
                .append(numChildren)
                .append(" RUNTIME: ")
                .append(getRuntime())
                .append(" CARDINALITY: ")
                .append(getCardinality())
                .append(" COST: ")
                .append(cost)
                .toString();
        return out;
    }
}
