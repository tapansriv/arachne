package org.arachne.profiling;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ProfileNode {
    private Long cardinality;
    private Double timing;
    private String opName;
    private List<String> extraInfo;
    private List<ProfileNode> children;
    private ProfileNode parent;

    public ProfileNode(Long cardinality, Double timing, String opName, ProfileNode parent) {
        this.cardinality = cardinality;
        this.timing = timing;
        this.opName = opName;
        this.children = new ArrayList<ProfileNode>(2);
        this.parent = parent;
        this.extraInfo = null;
    }

    public ProfileNode(Long cardinality, Double timing, String opName, String extraInfo, ProfileNode parent) {
        this(cardinality, timing, opName, parent);
        this.extraInfo = Arrays.asList(extraInfo.split("\\n"));
    }

    public void addChild(ProfileNode child) { children.add(child); }
    public ProfileNode getChild(int i) {
        assert this.children.size() > i;
        return children.get(i);
    }

    public ProfileNode getChild() {
        assert this.children.size() == 1;
        return this.children.get(0);
    }

    public Long getCardinality() { return cardinality; }
    public Double getTiming() { return this.timing; }
    public String getOpName() { return opName; }
    public List<String> getExtraInfo() { return extraInfo; }

    public String getDigest() {
        String fields = "";
        if (extraInfo != null) {
            fields = "(" + String.join(", ", extraInfo) + ") ";
        }
        String digest = children.size() + " " +
                        cardinality.toString() + " " +
                        timing.toString() + " " +
                        fields +
                        opName;
        return digest;
    }
    public String toString() { return getDigest(); }
    public void setParent(ProfileNode p) { this.parent = p; }
    public ProfileNode getParent() { return this.parent; }
    public int getNumChildren() { return this.children.size(); }
}
