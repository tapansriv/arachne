package org.arachne.common;

import org.apache.calcite.sql.type.SqlTypeName;
import org.arachne.schema.ArachneTable;

public class CustomTables {
    private CustomTables() {
    }

    public static final ArachneTable buildings = ArachneTable.newBuilder("buildings")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("campus", SqlTypeName.INTEGER)
            .addField("address", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable campuses = ArachneTable.newBuilder("campuses")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("address", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable depts = ArachneTable.newBuilder("depts")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("chair", SqlTypeName.INTEGER)
            .addField("building", SqlTypeName.INTEGER)
            .addField("campus", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();
    public static final ArachneTable classes = ArachneTable.newBuilder("classes")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("prof", SqlTypeName.INTEGER)
            .addField("rating", SqlTypeName.FLOAT)
            .addField("avg_gpa", SqlTypeName.FLOAT)
            .withRowCount(1L)
            .build();

    public static final ArachneTable illness = ArachneTable.newBuilder("illness")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("primary_drug", SqlTypeName.INTEGER)
            .addField("secondary_drug", SqlTypeName.INTEGER)
            .addField("age_diag", SqlTypeName.FLOAT)
            .addField("age_death", SqlTypeName.FLOAT)
            .addField("death_rate", SqlTypeName.FLOAT)
            .addField("incidence", SqlTypeName.FLOAT)
            .withRowCount(1L)
            .build();

    public static final ArachneTable library = ArachneTable.newBuilder("library")
            .addField("id", SqlTypeName.INTEGER)
            .addField("title", SqlTypeName.VARCHAR)
            .addField("student_id", SqlTypeName.INTEGER)
            .addField("checkout_date", SqlTypeName.DATE)
            .addField("return_date", SqlTypeName.DATE)
            .addField("topic", SqlTypeName.VARCHAR)
            .addField("descrip", SqlTypeName.VARCHAR)
            .addField("project", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable medicine = ArachneTable.newBuilder("medicine")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("approv_date", SqlTypeName.DATE)
            .addField("effic", SqlTypeName.FLOAT)
            .addField("illness", SqlTypeName.INTEGER)
            .addField("side_effects", SqlTypeName.VARCHAR)
            .addField("avg_age", SqlTypeName.FLOAT)
            .addField("pregnancy_tested", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable professors = ArachneTable.newBuilder("professors")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("dept", SqlTypeName.INTEGER)
            .addField("building", SqlTypeName.INTEGER)
            .addField("room", SqlTypeName.INTEGER)
            .addField("start_date", SqlTypeName.DATE)
            .addField("salary", SqlTypeName.FLOAT)
            .withRowCount(1L)
            .build();

    public static final ArachneTable projects = ArachneTable.newBuilder("projects")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("illness", SqlTypeName.INTEGER)
            .addField("method", SqlTypeName.VARCHAR)
            .addField("yeart_start", SqlTypeName.INTEGER)
            .addField("status", SqlTypeName.VARCHAR)
            .addField("funding", SqlTypeName.FLOAT)
            .addField("professor", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable student = ArachneTable.newBuilder("student")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("gpa", SqlTypeName.FLOAT)
            .addField("dept", SqlTypeName.INTEGER)
            .addField("advisor", SqlTypeName.INTEGER)
            .addField("position", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();
}
