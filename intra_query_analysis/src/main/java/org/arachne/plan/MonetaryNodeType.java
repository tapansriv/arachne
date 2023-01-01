package org.arachne.plan;

import com.amazonaws.services.medialive.model.AacRateControlMode;
import org.apache.calcite.sql.SqlDialect;
import org.apache.calcite.sql.dialect.BigQuerySqlDialect;
import org.apache.calcite.sql.dialect.MysqlSqlDialect;
import org.apache.calcite.sql.dialect.PostgresqlSqlDialect;
import org.apache.calcite.sql.dialect.RedshiftSqlDialect;
import org.arachne.dialect.ArachneRedshiftSqlDialect;

public enum MonetaryNodeType {
    SPECTRUM(0),
    DC2(1),
    DC28(2),
    DS2(3),
    DS28(4),
    GCP(5),
    RA3x1(6),
    RA34(7),
    RA136(8),
    BQ(9),
    RS(10),
    PSQL(11)
    ;

    private final int value;
    MonetaryNodeType(int value) {
        this.value = value;
    }

    public SqlDialect getOutputDialect() {
        switch (this) {
            case DC2:
            case PSQL:
            case GCP:
                return PostgresqlSqlDialect.DEFAULT;
            case RS:
                return ArachneRedshiftSqlDialect.DEFAULT;
            case DC28:
            case DS2:
            case DS28:
            case RA3x1:
            case RA34:
            case RA136:
            case BQ:
                return BigQuerySqlDialect.DEFAULT;
            case SPECTRUM:
            default:
                return MysqlSqlDialect.DEFAULT;
        }
    }

    public String getInputString() {
        switch (this) {
            case PSQL: // just to make it use duckdb baselines or whatever; i dont want to reprofile on postgres that could take forever.
                return "psql";
            case GCP:
                return "duck";
            case RS:
                return "rs";
            case DC2:
            case DC28:
            case DS2:
            case DS28:
            case RA3x1:
            case RA34:
            case RA136:
            case SPECTRUM:
            case BQ:
                return "bq";
            default:
                return "";
        }
    }
}
