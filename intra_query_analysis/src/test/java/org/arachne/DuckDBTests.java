package org.arachne;

import org.arachne.common.ArachneBaseTest;
import org.junit.Test;

import java.sql.*;

/**
 * Unit tests for individual functionality
 * Also tests to configure APIs, etc.
 */
public class DuckDBTests extends ArachneBaseTest {
    private void connectAndCreateTable(String jdbcURL) throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        Connection conn = DriverManager.getConnection(jdbcURL);
        Statement stmt = conn.createStatement();
        stmt.execute("CREATE TABLE items (item VARCHAR, value DECIMAL(10,2), count INTEGER)");
        // insert two items into the table
        stmt.execute("INSERT INTO items VALUES ('jeans', 20.0, 1), ('hammer', 42.2, 2)");
    }

    private void queryTable(String jdbcURL, String qry, String col) throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        Connection conn = DriverManager.getConnection(jdbcURL);
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(qry);
        while (rs.next()) {
            System.out.println(rs.getInt(col));
        }
        rs.close();
    }

    private void queryTable(String jdbcURL) throws ClassNotFoundException, SQLException {
        queryTable(jdbcURL, "SELECT * FROM items", "count");
    }

    @Test public void executeDuckDB() throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        Connection conn = DriverManager.getConnection("jdbc:duckdb:");
        Statement stmt = conn.createStatement();
        stmt.execute("CREATE TABLE items (item VARCHAR, value DECIMAL(10,2), count INTEGER)");
        // insert two items into the table
        stmt.execute("INSERT INTO items VALUES ('jeans', 20.0, 1), ('hammer', 42.2, 2)");
        ResultSet rs = stmt.executeQuery("SELECT * FROM items");
        while (rs.next()) {
            System.out.println(rs.getString(1));
            System.out.println(rs.getInt(3));
        }
        rs.close();
    }
    @Test public void testDuckDBReopen() throws ClassNotFoundException, SQLException {
        String jdbcURL = "jdbc:duckdb:/mnt/disks/tpcds/parquet/test.db";
        connectAndCreateTable(jdbcURL);
        queryTable(jdbcURL);
    }

    @Test public void testDuckDBParquet() throws ClassNotFoundException, SQLException {
        String jdbcURL = "jdbc:duckdb:/mnt/disks/tpcds/parquet/test.db";
        queryTable(jdbcURL, "SELECT * FROM '/mnt/disks/tpcds/parquet/item.parquet' LIMIT 10", "i_item_sk");
    }
}
