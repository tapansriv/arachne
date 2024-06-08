package org.arachne.optimizer;

import org.apache.calcite.sql.*;
import org.apache.calcite.sql.util.SqlBasicVisitor;
import org.apache.calcite.sql.util.SqlVisitor;
import org.checkerframework.checker.nullness.qual.Nullable;

public class ArachneSqlVisitor extends SqlBasicVisitor<Void> {
    public ArachneSqlVisitor() {}

    public void print (SqlNode node) {
        System.out.println(node.toSqlString((SqlDialect) null));
    }

    public Void visit(SqlLiteral literal) {
        print(literal);
        return null;
    }

    public Void visit(SqlCall call) {
        return call.getOperator().acceptCall(this, call);
    }

    public Void visit(SqlNodeList nodeList) {
        Void result = null;
        for(int i = 0; i < nodeList.size(); ++i) {
            SqlNode node = nodeList.get(i);
            result = node.accept(this);
        }
        return result;
    }

    public Void visit(SqlIdentifier id) {
        print(id);
        return null;
    }

    public Void visit(SqlDataTypeSpec type) {
        print(type);
        return null;
    }

    public Void visit(SqlDynamicParam param) {
        print(param);
        return null;
    }

    public Void visit(SqlIntervalQualifier intervalQualifier) {
        print(intervalQualifier);
        return null;
    }
}
