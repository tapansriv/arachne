package org.arachne.converter;

import java.util.List;
import java.util.Arrays;
import javax.annotation.Nullable;

public class ArachneQueryNode {
    
    private ArachneNodeType type;
    private List<String> attributes; 
    private List<ArachneQueryNode> children;

    public ArachneQueryNode(ArachneNodeType type, 
                            List<String> attributes, 
                            List<ArachneQueryNode> children) {
        this.type = type;
        this.attributes = attributes;
        this.children = children;
    }

    public ArachneNodeType getType() { return this.type; }
    public List<String> getAttributes() { return this.attributes; }
    public List<ArachneQueryNode> getChildren() { return this.children; }

    public ArachneSqlGraph parsePlan() {
        ArachneQueryNode curr = this; 
        ArachneSqlGraph output = new ArachneSqlGraph();

        while (curr != null) {
            if (curr.getType() == ArachneNodeType.JOIN) {
                ArachneQueryNode left = curr.getChildren().get(0);
                ArachneQueryNode right = curr.getChildren().get(1);
                ArachneSqlGraph leftOut = left.parsePlan();
                ArachneSqlGraph rightOut = right.parsePlan();
                List<ArachneSqlGraph> children = Arrays.asList(leftOut, rightOut);
                
                ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.JOIN, curr.getAttributes(), children);
                output.insertFront(op);
                return output;
            } else {
                if (curr.getType() == ArachneNodeType.SELECT) {
                    ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.SELECT, curr.getAttributes(), null);
                    output.insertFront(op);
                }
                if (curr.getType() == ArachneNodeType.ORDER_BY) {
                    ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.ORDER_BY, curr.getAttributes(), null);
                    output.insertFront(op);
                }
                if (curr.getType() == ArachneNodeType.GROUP_BY) {
                    ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.GROUP_BY, curr.getAttributes(), null);
                    output.insertFront(op);
                }
                if (curr.getType() == ArachneNodeType.WHERE) {
                    ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.WHERE, curr.getAttributes(), null);
                    output.insertFront(op);
                }
                if (curr.getType() == ArachneNodeType.TABLE_SCAN) {
                    ArachneSqlNode op = new ArachneSqlNode(ArachneNodeType.TABLE_SCAN, curr.getAttributes(), null);
                    output.insertFront(op);
                }

                if (curr.getChildren() != null) {
                    curr = curr.getChildren().get(0);
                } else {
                    curr = null;    
                }
            }
        }
        return output;
    }
}
