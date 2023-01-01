package org.arachne.dialect;

import org.apache.calcite.sql.SqlDialect;
import org.apache.calcite.sql.dialect.RedshiftSqlDialect;

public class ArachneRedshiftSqlDialect extends RedshiftSqlDialect {
    public static final SqlDialect DEFAULT = new ArachneRedshiftSqlDialect(DEFAULT_CONTEXT);
    public ArachneRedshiftSqlDialect(Context context) {
        super(context);
    }

    @Override
    public boolean supportsAggregateFunctionFilter() {
        return false;
    }
}
