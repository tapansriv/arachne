package org.arachne.converter;

import java.util.List;
import javax.annotation.Nullable;

public class ArachneSqlGraph {
    
    private @Nullable ArachneSqlNode head;
    private @Nullable ArachneSqlNode front;
    private @Nullable ArachneSqlNode tail;
    private @Nullable ArachneSqlNode back;

    private @Nullable ArachneSqlNode select;
    private int size;

    public ArachneSqlGraph() {
        this.tail = new ArachneSqlNode(null, null, null);
        this.head = new ArachneSqlNode(null, null, null, this.tail);
        this.tail.setPrev(this.head);
        this.front = this.head;
        this.back = this.tail;
        this.size = 0;
        this.select = null;
    }

    public @Nullable ArachneSqlNode getSelect() {
        return select;
    }

    public void setSelect(ArachneSqlNode select) {
        this.select = select;
    }

    public String toString() {
        ArachneSqlNode curr = this.head.getNext();
        StringBuilder sb = new StringBuilder();

        while (curr.getNext() != null) {
            if (curr.getType() == ArachneNodeType.SELECT) {
                String cols = String.join(",", curr.getAttributes());
                String op = String.format("SELECT %s FROM ", cols);
                // System.out.println(cols);
                sb = sb.append(op);
            }
            if (curr.getType() == ArachneNodeType.JOIN) {
                List<ArachneSqlGraph> children = curr.getChildren();
                // System.out.println("LEFT");
                String left = children.get(0).toString();
                // System.out.println("Right");
                String right = children.get(1).toString();
                String condition = curr.getAttributes().get(0);
                
                String leftAlias = children.get(0).getAlias();
                if (leftAlias == null) {
                    if (children.get(0).isSubQuery()) {
                        leftAlias = "t1";    
                    }
                }

                String rightAlias = children.get(1).getAlias();
                if (rightAlias == null) {
                    if (children.get(1).isSubQuery()) {
                        rightAlias = "t2";    
                    }
                }

                String leftOp  = (leftAlias != null) ? String.format( "%sAS %s", left, leftAlias) : String.format("%s", left);
                String rightOp = (rightAlias != null) ? String.format( "%sAS %s", right, rightAlias) : String.format("%s", right);
                // System.out.println(leftOp);
                String op = String.format("%s JOIN %s ON %s ", leftOp, rightOp, condition);
                sb = sb.append(op);
            }
            if (curr.getType() == ArachneNodeType.ORDER_BY) {
                String cols = String.join(",", curr.getAttributes());
                String op = String.format("ORDER BY %s ", cols);
                sb = sb.append(op);
            }
            if (curr.getType() == ArachneNodeType.GROUP_BY) {
                String cols = String.join(",", curr.getAttributes());
                String op = String.format("GROUP BY %s ", cols);
                sb = sb.append(op);
            }
            if (curr.getType() == ArachneNodeType.WHERE) {
                String conds = String.join(",", curr.getAttributes());
                String op = String.format("WHERE %s ", conds);
                sb = sb.append(op);
            }
            if (curr.getType() == ArachneNodeType.TABLE_SCAN) {
                String tables = curr.getAttributes().get(0);
                if (curr.getAttributes().size() == 2) {
                    String alias = curr.getAttributes().get(1);
                    String op = String.format("%s AS %s ", tables, alias);
                    sb = sb.append(op);
                } else {
                    String op = String.format("%s ", tables);
                    sb = sb.append(op);
                }
            }
            curr = curr.getNext();
        }
        return sb.toString();
    }

    public int size() {
        return this.size;
    }

    public void insertFront(ArachneSqlNode node) {
        ArachneSqlNode nxt = this.head.getNext();
        node.setNext(nxt);
        nxt.setPrev(node);
        node.setPrev(this.head);
        this.head.setNext(node);
        // this.front = node;
        this.size += 1;
    }

    public void insertBack(ArachneSqlNode node) {
        ArachneSqlNode prv = this.tail.getPrev(); 
        node.setPrev(prv);
        prv.setNext(node);
        node.setNext(this.tail);
        this.tail.setPrev(node);
        // this.back = node;
        this.size += 1;
    }

    public boolean isSubQuery() {
        return (!(size() == 1 && this.head.getNext().getType() == ArachneNodeType.TABLE_SCAN));
    }

    // if graph is just table scan, get alias of scan node
    public @Nullable String getAlias() {
        if (!isSubQuery()) {
            ArachneSqlNode scan = this.head.getNext();
            if (scan.getAttributes().size() == 2) {
                return scan.getAttributes().get(1);
            }
        }
        return null;
    }
}
