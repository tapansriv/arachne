package org.arachne.common;


import org.arachne.algorithmic_collection.QueryMetadata;

public abstract class AbstractCollector {

    public abstract void go() throws Exception;
    public abstract QueryMetadata getQueryMetadata();
}
