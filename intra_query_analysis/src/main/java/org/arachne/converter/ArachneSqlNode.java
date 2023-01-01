package org.arachne.converter;

import javax.annotation.Nullable;
import java.util.List;

public class ArachneSqlNode {
    private ArachneNodeType type;
    private List<String> attributes;
    private @Nullable List<ArachneSqlGraph> children;
    private @Nullable ArachneSqlNode next;
    private @Nullable ArachneSqlNode prev;

    ArachneSqlNode(ArachneNodeType type, 
                   List<String> attributes, 
                   @Nullable List<ArachneSqlGraph> children) {

        this.type = type;
        this.attributes = attributes;
        this.children = children;
        this.next = null;
        this.prev = null;
    }

    ArachneSqlNode(ArachneNodeType type, 
                   List<String> attributes, 
                   @Nullable List<ArachneSqlGraph> children,
                   @Nullable ArachneSqlNode next) {

        this.type = type;
        this.attributes = attributes;
        this.children = children;
        this.next = next;
        this.prev = null;
    }

    ArachneSqlNode(ArachneNodeType type, 
                   List<String> attributes, 
                   @Nullable List<ArachneSqlGraph> children,
                   @Nullable ArachneSqlNode next,
                   @Nullable ArachneSqlNode prev) {

        this.type = type;
        this.attributes = attributes;
        this.children = children;
        this.next = next;
        this.prev = prev;
    }

    public void setNext(ArachneSqlNode next) {
        this.next = next;
    }

    public void setPrev(ArachneSqlNode prev) {
        this.prev = prev;
    }

    public @Nullable ArachneSqlNode getNext() { return this.next; }
    public @Nullable ArachneSqlNode getPrev() { return this.prev; }

    public ArachneNodeType getType() { return this.type; }
    public List<String> getAttributes() { return this.attributes; }
    public @Nullable List<ArachneSqlGraph> getChildren() { return this.children; }
    public @Nullable String getAttribute(int index) { 
        if (index < 0 || index >= attributes.size()) {
            return null;
        }
        return attributes.get(index); 
    }

    public boolean setAttribute(int index, String value) { 
        if (index < 0 || index >= attributes.size()) {
            return false;
        } else {
            attributes.set(index, value); 
            return true;
        }
    }

    public void addAttribute(String element) { attributes.add(element); }
    public void addAttributes(List<String> elements) { attributes.addAll(elements); }
    public void setAttributes(List<String> newattrs) { this.attributes = newattrs; }
    public void setChildren(List<ArachneSqlGraph> newChildren) { this.children = newChildren; }
}

