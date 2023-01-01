package org.arachne.common;

import org.apache.calcite.sql.type.SqlTypeName;
import org.arachne.schema.ArachneTable;

public final class IMDBTables {
    private IMDBTables() {
    }
    public static final ArachneTable aka_name = ArachneTable.newBuilder("aka_name")
            .addField("id", SqlTypeName.INTEGER)
            .addField("person_id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("imdb_index", SqlTypeName.VARCHAR)
            .addField("name_pcode_cf", SqlTypeName.VARCHAR)
            .addField("name_pcode_nf", SqlTypeName.VARCHAR)
            .addField("surname_pcode", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable aka_title = ArachneTable.newBuilder("aka_title")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("title", SqlTypeName.VARCHAR)
            .addField("imdb_index", SqlTypeName.VARCHAR)
            .addField("kind_id", SqlTypeName.INTEGER)
            .addField("production_year", SqlTypeName.INTEGER)
            .addField("phonetic_code", SqlTypeName.VARCHAR)
            .addField("episode_of_id", SqlTypeName.INTEGER)
            .addField("season_nr", SqlTypeName.INTEGER)
            .addField("episode_nr", SqlTypeName.INTEGER)
            .addField("note", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable cast_info = ArachneTable.newBuilder("cast_info")
            .addField("id", SqlTypeName.INTEGER)
            .addField("person_id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("person_role_id", SqlTypeName.INTEGER)
            .addField("note", SqlTypeName.VARCHAR)
            .addField("nr_order", SqlTypeName.INTEGER)
            .addField("role_id", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable char_name = ArachneTable.newBuilder("char_name")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("imdb_index", SqlTypeName.VARCHAR)
            .addField("imdb_id", SqlTypeName.INTEGER)
            .addField("name_pcode_nf", SqlTypeName.VARCHAR)
            .addField("surname_pcode", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable comp_cast_type = ArachneTable.newBuilder("comp_cast_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("kind", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable company_name = ArachneTable.newBuilder("company_name")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("country_code", SqlTypeName.VARCHAR)
            .addField("imdb_id", SqlTypeName.INTEGER)
            .addField("name_pcode_nf", SqlTypeName.VARCHAR)
            .addField("name_pcode_sf", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable company_type = ArachneTable.newBuilder("company_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("kind", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable complete_cast = ArachneTable.newBuilder("complete_cast")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("subject_id", SqlTypeName.INTEGER)
            .addField("status_id", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable info_type = ArachneTable.newBuilder("info_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("info", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable keyword = ArachneTable.newBuilder("keyword")
            .addField("id", SqlTypeName.INTEGER)
            .addField("keyword", SqlTypeName.VARCHAR)
            .addField("phonetic_code", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable kind_type = ArachneTable.newBuilder("kind_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("kind", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable link_type = ArachneTable.newBuilder("link_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("link", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable movie_companies = ArachneTable.newBuilder("movie_companies")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("company_id", SqlTypeName.INTEGER)
            .addField("company_type_id", SqlTypeName.INTEGER)
            .addField("note", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable movie_info_idx = ArachneTable.newBuilder("movie_info_idx")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("info_type_id", SqlTypeName.INTEGER)
            .addField("info", SqlTypeName.VARCHAR)
            .addField("note", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable movie_keyword = ArachneTable.newBuilder("movie_keyword")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("keyword_id", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable movie_link = ArachneTable.newBuilder("movie_link")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("linked_movie_id", SqlTypeName.INTEGER)
            .addField("link_type_id", SqlTypeName.INTEGER)
            .withRowCount(1L)
            .build();

    public static final ArachneTable name = ArachneTable.newBuilder("name")
            .addField("id", SqlTypeName.INTEGER)
            .addField("name", SqlTypeName.VARCHAR)
            .addField("imdb_index", SqlTypeName.VARCHAR)
            .addField("imdb_id", SqlTypeName.INTEGER)
            .addField("gender", SqlTypeName.VARCHAR)
            .addField("name_pcode_cf", SqlTypeName.VARCHAR)
            .addField("name_pcode_nf", SqlTypeName.VARCHAR)
            .addField("surname_pcode", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable role_type = ArachneTable.newBuilder("role_type")
            .addField("id", SqlTypeName.INTEGER)
            .addField("role", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable title = ArachneTable.newBuilder("title")
            .addField("id", SqlTypeName.INTEGER)
            .addField("title", SqlTypeName.VARCHAR)
            .addField("imdb_index", SqlTypeName.VARCHAR)
            .addField("kind_id", SqlTypeName.INTEGER)
            .addField("production_year", SqlTypeName.INTEGER)
            .addField("imdb_id", SqlTypeName.INTEGER)
            .addField("phonetic_code", SqlTypeName.VARCHAR)
            .addField("episode_of_id", SqlTypeName.INTEGER)
            .addField("season_nr", SqlTypeName.INTEGER)
            .addField("episode_nr", SqlTypeName.INTEGER)
            .addField("series_years", SqlTypeName.VARCHAR)
            .addField("md5sum", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable movie_info = ArachneTable.newBuilder("movie_info")
            .addField("id", SqlTypeName.INTEGER)
            .addField("movie_id", SqlTypeName.INTEGER)
            .addField("info_type_id", SqlTypeName.INTEGER)
            .addField("info", SqlTypeName.VARCHAR)
            .addField("note", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();

    public static final ArachneTable person_info = ArachneTable.newBuilder("person_info")
            .addField("id", SqlTypeName.INTEGER)
            .addField("person_id", SqlTypeName.INTEGER)
            .addField("info_type_id", SqlTypeName.INTEGER)
            .addField("info", SqlTypeName.VARCHAR)
            .addField("note", SqlTypeName.VARCHAR)
            .withRowCount(1L)
            .build();
}
