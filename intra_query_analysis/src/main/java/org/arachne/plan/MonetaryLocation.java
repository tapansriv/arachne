package org.arachne.plan;

public enum MonetaryLocation {
    REDSHIFT(1),
    BIG_QUERY(2),
    GCP_VM(3),
    POSTGRES(4);

    private final int value;
    private MonetaryLocation(int value) { this.value = value; }
}