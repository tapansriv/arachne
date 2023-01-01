package org.arachne.execution;

import com.google.common.collect.ImmutableList;
import org.apache.calcite.plan.RelOptTable;
import org.apache.calcite.rel.core.TableScan;
import org.apache.calcite.rel.rel2sql.RelToSqlConverter;
import org.apache.calcite.sql.SqlDialect;
import org.apache.calcite.sql.SqlIdentifier;
import org.apache.calcite.sql.parser.SqlParserPos;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.schema.ArachneTable;

import java.util.List;

public class ArachneRelToSqlConverter {

    public static String convertQuery(String qry, MonetaryLocation location, String schemaName, boolean isProfile) {
        String[] lines = qry.split("\n");
        StringBuilder sb = new StringBuilder();
        for (String line : lines) {
            String newLine = line.replaceAll("(`\"|\"`|`)", "\"");
            if (isProfile && !location.equals(MonetaryLocation.BIG_QUERY)) { // we dont want to materialize outputs
                boolean profileDuck, profileRS;

                if (schemaName.equals("tpcds")) {
                    profileDuck = newLine.matches("(.*)\"tpcds\"\\.\"duck_table_(\\d*)_(\\d*)\"(.*)");
                    profileRS = newLine.matches("(.*)\"tpcds\"\\.\"rs_table_(\\d*)_(\\d*)\"(.*)");
                    if (profileDuck || profileRS) {
                        newLine = newLine.replaceAll("\"tpcds\"\\.\"duck_table_(\\d*)_(\\d*)\"", "\"duck_table_$1_$2\"");
                        newLine = newLine.replaceAll("\"tpcds\"\\.\"rs_table_(\\d*)_(\\d*)\"", "\"rs_table_$1_$2\"");
                    }
                } else if (schemaName.equals("ldbc")) {
                    profileDuck = newLine.matches("(.*)\"ldbc\"\\.\"duck_table_(\\d*)_(\\d*)\"(.*)");
                    profileRS = newLine.matches("(.*)\"ldbc\"\\.\"rs_table_(\\d*)_(\\d*)\"(.*)");
                    if (profileDuck || profileRS) {
                        newLine = newLine.replaceAll("\"ldbc\"\\.\"duck_table_(\\d*)_(\\d*)\"", "\"duck_table_$1_$2\"");
                        newLine = newLine.replaceAll("\"ldbc\"\\.\"rs_table_(\\d*)_(\\d*)\"", "\"rs_table_$1_$2\"");
                    }
                } else {
                    throw new RuntimeException("Illegal schema name dont be bad");
                }
            }

            String replacement = "";
            boolean needsAlias1, needsAlias2;
            if (schemaName.equals("tpcds")) {
                needsAlias1 = !newLine.matches("(.*)tpcds\\.(\\w*) AS(.*)");
                needsAlias2 = !newLine.matches("(.*)\"tpcds\"\\.\"(\\w*)\" AS(.*)");
            } else if (schemaName.equals("ldbc")) {
                needsAlias1 = !newLine.matches("(.*)ldbc\\.(\\w*) AS(.*)");
                needsAlias2 = !newLine.matches("(.*)\"ldbc\"\\.\"(\\w*)\" AS(.*)");
            } else {
                throw new RuntimeException("Illegal schema name dont be bad");
            }

            boolean needsAlias = (needsAlias1 && needsAlias2);
            switch (location) {
                case GCP_VM:
                    if (needsAlias) {
                        replacement = "'/mnt/disks/" + schemaName + "/parquet/$1.parquet' AS $1";
                        // replacement = "'/home/cc/$1.parquet' AS $1";
                    } else {
                        replacement = "'/mnt/disks/" + schemaName + "/parquet/$1.parquet'";
                        // replacement = "'/home/cc/$1.parquet'";
                    }
                    break;
                case BIG_QUERY:
                    if (needsAlias) {
                        replacement = "`arachne-multicloud." + schemaName + ".$1` AS $1";
                    } else {
                        replacement = "`arachne-multicloud." + schemaName + ".$1`";
                    }
                    break;
                case POSTGRES:
                case REDSHIFT:
                    replacement = "$1";
                    break;
                default:
                    break;
            }
            if (location.equals(MonetaryLocation.GCP_VM)) {
                newLine = newLine.replaceAll("\"\"\"", "\"");
                newLine = newLine.replaceAll("\"" + schemaName + "\"\\.\"(\\w*)\"", replacement);
            } else if (location.equals(MonetaryLocation.BIG_QUERY)) {
                newLine = newLine.replaceAll("SUM\\(\"\\$(\\w*)\"\\)", "SUM(_$1)");
                newLine = newLine.replaceAll("AVG\\(\"\\$(\\w*)\"\\)", "AVG(_$1)");
                newLine = newLine.replaceAll("COUNT\\(\"\\$(\\w*)\"\\)", "COUNT(_$1)");
                newLine = newLine.replaceAll("MAX\\(\"\\$(\\w*)\"\\)", "MAX(_$1)");
                newLine = newLine.replaceAll("MIN\\(\"\\$(\\w*)\"\\)", "MIN(_$1)");
                newLine = newLine.replaceAll(schemaName + "\\.(\\w*)", replacement);
                newLine = newLine.replaceAll("\"[^a-zA-Z0-9_]\"", "_");
                newLine = newLine.replaceAll("\"[^a-zA-Z0-9_][^a-zA-Z0-9_]\"", "__");
            } else if (location.equals(MonetaryLocation.REDSHIFT)) {
                // NOTE: We want this, otherwise Tapan goes insane bc t."*" resolves to t.* in RS (but not in Duck)
                // newLine = newLine.replaceAll("\"\"\"", "\"");
                newLine = newLine.replaceAll("([^\"])\"\\*\"", "$1\"\"\"\\*\"\"\"");
                newLine = newLine.replaceAll("\"" + schemaName + "\"\\.\"(\\w*)\"", replacement);
            } else if (location.equals(MonetaryLocation.POSTGRES)) {
                newLine = newLine.replaceAll("\"\"\"", "\"");
                newLine = newLine.replaceAll("\"" + schemaName + "\"\\.\"(\\w*)\"", replacement);
            }
            newLine = newLine + "\n";
            sb.append(newLine);
        }
        return sb.toString();
    }
}
