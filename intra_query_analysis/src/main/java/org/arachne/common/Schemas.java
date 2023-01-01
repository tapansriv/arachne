package org.arachne.common;

import org.arachne.schema.ArachneSchema;
import org.arachne.schema.ArachneTable;

public final class Schemas {
    private Schemas() {}

    public static final ArachneSchema customSchema = ArachneSchema.newBuilder("custom")
            .addTable(CustomTables.buildings)
            .addTable(CustomTables.campuses)
            .addTable(CustomTables.classes)
            .addTable(CustomTables.depts)
            .addTable(CustomTables.illness)
            .addTable(CustomTables.library)
            .addTable(CustomTables.medicine)
            .addTable(CustomTables.professors)
            .addTable(CustomTables.projects)
            .addTable(CustomTables.student)
            .build();
    public static final ArachneSchema imdbSchema = ArachneSchema.newBuilder("imdb")
            .addTable(IMDBTables.aka_name)
            .addTable(IMDBTables.aka_title)
            .addTable(IMDBTables.cast_info)
            .addTable(IMDBTables.char_name)
            .addTable(IMDBTables.comp_cast_type)
            .addTable(IMDBTables.company_name)
            .addTable(IMDBTables.company_type)
            .addTable(IMDBTables.complete_cast)
            .addTable(IMDBTables.info_type)
            .addTable(IMDBTables.keyword)
            .addTable(IMDBTables.kind_type)
            .addTable(IMDBTables.link_type)
            .addTable(IMDBTables.movie_companies)
            .addTable(IMDBTables.movie_info_idx)
            .addTable(IMDBTables.movie_keyword)
            .addTable(IMDBTables.movie_link)
            .addTable(IMDBTables.name)
            .addTable(IMDBTables.role_type)
            .addTable(IMDBTables.title)
            .addTable(IMDBTables.movie_info)
            .addTable(IMDBTables.person_info)
            .build();
    public static final ArachneSchema tpchSchema = ArachneSchema.newBuilder("tpch")
            .addTable(ArachneTable.emps)
            .addTable(ArachneTable.depts)
            .addTable(ArachneTable.nation)
            .addTable(ArachneTable.region)
            .addTable(ArachneTable.part)
            .addTable(ArachneTable.supplier)
            .addTable(ArachneTable.partsupp)
            .addTable(ArachneTable.customer)
            .addTable(ArachneTable.orders)
            .addTable(ArachneTable.lineitem)
            .build();

    public static final ArachneSchema tpcdsSchema = ArachneSchema.newBuilder("tpcds")
            .addTable(Tables.call_center)
            .addTable(Tables.catalog_page)
            .addTable(Tables.catalog_returns)
            .addTable(Tables.catalog_sales)
            .addTable(Tables.customer)
            .addTable(Tables.customer_address)
            .addTable(Tables.customer_demographics)
            .addTable(Tables.date_dim)
            .addTable(Tables.household_demographics)
            .addTable(Tables.income_band)
            .addTable(Tables.inventory)
            .addTable(Tables.item)
            .addTable(Tables.promotion)
            .addTable(Tables.reason)
            .addTable(Tables.ship_mode)
            .addTable(Tables.store)
            .addTable(Tables.store_returns)
            .addTable(Tables.store_sales)
            .addTable(Tables.time_dim)
            .addTable(Tables.warehouse)
            .addTable(Tables.web_page)
            .addTable(Tables.web_returns)
            .addTable(Tables.web_sales)
            .addTable(Tables.web_site)
            .build();

    public static final ArachneSchema ldbcSchema = ArachneSchema.newBuilder("ldbc")
            .addTable(LDBCTables.post)
            .addTable(LDBCTables.comment)
            .addTable(LDBCTables.message)
            .addTable(LDBCTables.forum)
            .addTable(LDBCTables.forum_person)
            .addTable(LDBCTables.forum_tag)
            .addTable(LDBCTables.person)
            .addTable(LDBCTables.person_tag)
            .addTable(LDBCTables.knows)
            .addTable(LDBCTables.likes)
            .addTable(LDBCTables.person_university)
            .addTable(LDBCTables.person_company)
            .addTable(LDBCTables.message_tag)
            .addTable(LDBCTables.tagclass)
            .addTable(LDBCTables.organisation)
            .addTable(LDBCTables.place)
            .addTable(LDBCTables.tag)
            .build();
}
