package org.arachne;

import com.google.cloud.bigquery.*;
import com.google.cloud.storage.*;

import com.google.cloud.storage.Blob;
import org.arachne.execution.ExecutionEngine;
import org.arachne.plan.MonetaryNodeType;
import org.junit.Test;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.sql.*;
import java.nio.file.Paths;
import java.math.BigInteger;
import java.util.Properties;

public class ExecutionTests {
    private void executeBQ(String qry) {
        BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();
    }

    @Test
    public void testProps() {
        Properties props = new Properties();
        FileInputStream input;
        try {
            String home = System.getProperty("user.home");
            input = new FileInputStream(home + "/arachneDB/config/config.properties");
            props.load(input);
            String id = props.getProperty("user");
            String secret = props.getProperty("password");
            secret = props.getProperty("jdbc_url");
            System.out.println("id: " + id + " secret: " + secret);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Test
    public void testLoad() {
        String sourceUri = "gs://arachne_tpcds_1tb/table1.parquet";
        String name = "table1";
        String objectName = name + ".parquet";
        String localFilename = "/mnt/disks/tpcds/" + objectName;
        ExecutionEngine.uploadFileToGCStorage(objectName, "arachne_tpcds_1tb/", localFilename);
        ExecutionEngine.loadBQ(sourceUri, name);
    }

    @Test
    public void testBash() throws IOException {
        ProcessBuilder pb = new ProcessBuilder("gsutil", "cp", "date_dim.parquet", "gs://arachne_tpcds_1tb/");
        pb.redirectOutput(new File("out.txt"));
        Process p = pb.start();
        ExecutionEngine.executeBQ("SELECT COUNT(*) FROM date_dim");
    }

    @Test
    public void testAWSUnload() throws ClassNotFoundException, SQLException {
        Statement stmt = ExecutionEngine.getAWSStatement();
        String auth = "'arn:aws:iam::552633893236:role/service-role/AmazonRedshift-CommandsAccessRole-20220225T121207' FORMAT AS PARQUET;";
        // String qry = "UNLOAD ('select * from users') TO 's3://arachne-multicloud/table_67_1/' iam_role " + auth;
        String qry = "COPY date_dim FROM 's3://arachne-multicloud/date_dim.parquet' iam_role " + auth;
        stmt.execute(qry);
    }

    @Test
    public void testAWSUpdate() throws ClassNotFoundException, SQLException {
        Statement stmt = ExecutionEngine.getAWSStatement();
        stmt.execute("CREATE TABLE t1 AS SELECT COUNT(*) FROM date_dim");
    }

    @Test
    public void testPSQL() throws ClassNotFoundException, SQLException {
        Statement stmt = ExecutionEngine.getPostgresStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM date_dim");
        while (rs.next())
            System.out.println(rs.getInt(1));
    }

    @Test
    public void testAWS() throws ClassNotFoundException, SQLException {
        Statement stmt = ExecutionEngine.getAWSStatement();
        ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM users");
        while (rs.next()) {
            System.out.println(rs.getInt(1));
        }
    }

    @Test
    public void testLoadBQ() throws ClassNotFoundException, SQLException {
        String sourceUri = "gs://arachne_redshift/test/*";
        String name = "test";
        ExecutionEngine.loadBQ(sourceUri, name);
    }

    @Test
    public void testMoveS3() throws IOException {
        ExecutionEngine.moveS3GCP("test");
    }

    @Test
    public void query() {
        try {
            String projectId = "arachne-multicloud";
            String datasetName = "tpcds";
            String tableName = "catalog_page2";
            String query = "SELECT * FROM `"
                            + projectId
                            + "."
                            + datasetName
                            + "."
                            + tableName
                            + "`"
                            + " LIMIT 20";

            // Initialize client that will be used to send requests. This client only needs to be created
            // once, and can be reused for multiple requests.
            BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();
            QueryJobConfiguration queryConfig = QueryJobConfiguration.newBuilder(query).build();
            TableResult results = bigquery.query(queryConfig);
            results
                    .iterateAll()
                    .forEach(row -> row.forEach(val -> System.out.printf("%s,", val.toString())));

            System.out.println("Query performed successfully.");
        } catch (BigQueryException | InterruptedException e) {
            System.out.println("Query not performed \n" + e.toString());
        }
    }

    @Test
    public void testSplit() {
        String qry = "SELECT * \nFROM tbl\nWHERE foo <= 10";
        String[] lines = qry.split("\n");
        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        for (String line : lines) {
            sb.append(line);
            sb2.append(line + "\n");
        }
        System.out.println(sb);
        System.out.println(sb2);
    }

    @Test
    public void downloadFile() {
        // TODO move table.parquet to linux VM (or have Duck use Arrow)
        String projectId = "arachne-multicloud";
        String bucketName = "arachne_tpcds";
        String objectName = "call_center.parquet";
        String destFilePath = "/mnt/disks/tpcds/call_center.parquet";
        Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();

        Blob blob = storage.get(BlobId.of(bucketName, objectName));
        blob.downloadTo(Paths.get(destFilePath));
        System.out.println("Downloaded object " + objectName + " from bucket name " + bucketName + " to " + destFilePath);
    }

    @Test
    public void uploadFile() throws Exception {
        String projectId = "arachne-multicloud";
        String bucketName = "arachne_tpcds";
        String objectName = "call_center.parquet";
        String filePath = "/mnt/disks/tpcds/parquet/call_center.parquet";

        Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();
        BlobId blobId = BlobId.of(bucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).build();
        storage.create(blobInfo, Files.readAllBytes(Paths.get(filePath)));
        System.out.println("File " + filePath + " uploaded to bucket " + bucketName + " as " + objectName);
    }

    @Test
    public void loadBQ() {
        try {
            // Initialize client that will be used to send requests. This client only needs to be created
            // once, and can be reused for multiple requests.
            BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();

            String datasetName = "tpcds";
            String sourceUri = "gs://arachne_tpcds/catalog_page.parquet";
            TableId tableId = TableId.of(datasetName, "catalog_page2");

            LoadJobConfiguration configuration =
                    LoadJobConfiguration.builder(tableId, sourceUri)
                            .setFormatOptions(FormatOptions.parquet())
                            .build();

            // For more information on Job see:
            // https://googleapis.dev/java/google-cloud-clients/latest/index.html?com/google/cloud/bigquery/package-summary.html
            // Load the table
            Job job = bigquery.create(JobInfo.of(configuration));

            // Blocks until this load table job completes its execution, either failing or succeeding.
            Job completedJob = job.waitFor();
            if (completedJob == null) {
                System.out.println("Job not executed since it no longer exists.");
                return;
            } else if (completedJob.getStatus().getError() != null) {
                System.out.println(
                        "BigQuery was unable to load the table due to an error: \n"
                                + job.getStatus().getError());
                return;
            }

            // Check number of rows loaded into the table
            BigInteger numRows = bigquery.getTable(tableId).getNumRows();
            System.out.printf("Loaded %d rows. \n", numRows);

            System.out.println("GCS parquet loaded successfully.");
        } catch (BigQueryException | InterruptedException e) {
            System.out.println("GCS Parquet was not loaded. \n" + e.toString());
        }
    }

    @Test
    public void exportBQ() {
        try {
            String projectId = "arachne-multicloud";
            String datasetName = "tpcds";
            String tableName = "catalog_page";
            String bucketName = "arachne_tpcds";
            String destinationUri = "gs://" + bucketName + "/catalog_page3.parquet";
            String dataFormat = "Parquet";
            String compressed = "snappy";
            // Initialize client that will be used to send requests. This client only needs to be created
            // once, and can be reused for multiple requests.
            BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();
            TableId tableId = TableId.of(projectId, datasetName, tableName);

            ExtractJobConfiguration extractConfig =
                    ExtractJobConfiguration.newBuilder(tableId, destinationUri)
                            .setCompression(compressed)
                            .setFormat(dataFormat)
                            .build();

            // Table table = bigquery.getTable(tableId);
            // Job job = table.extract(dataFormat, destinationUri);

            Job job = bigquery.create(JobInfo.of(extractConfig));
            // Blocks until this job completes its execution, either failing or succeeding.
            Job completedJob = job.waitFor();
            if (completedJob == null) {
                System.out.println("Job not executed since it no longer exists.");
                return;
            } else if (completedJob.getStatus().getError() != null) {
                System.out.println(
                        "BigQuery was unable to extract due to an error: \n" + job.getStatus().getError());
                return;
            }
            System.out.println(
                    "Table export successful. Check in GCS bucket for the " + dataFormat + " file.");
        } catch (BigQueryException | InterruptedException e) {
            System.out.println("Table extraction job was interrupted. \n" + e.toString());
        }
    }


    public void moveToBQ(String name, MonetaryNodeType source, MonetaryNodeType destination) throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        Connection conn = DriverManager.getConnection("jdbc:duckdb:tpcds.db");
        Statement stmt = conn.createStatement();
        String qry = new StringBuilder().append("COPY ").append(name).append(" TO '").append(name).append(".parquet' (FORMAT 'parquet')").toString();
        stmt.executeQuery(qry);

        // TODO move file to Google Storage
    }

    @Test
    public void testVersion() throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        Connection conn = DriverManager.getConnection("jdbc:duckdb:tpcds.db");
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT * FROM '/Users/Tapan/arachneDB/sqlconverter/item.parquet' LIMIT 10");
        // String qry = new StringBuilder().append("COPY ").append(name).append(" TO '").append(name).append(".parquet' (FORMAT 'parquet')").toString();
        // stmt.executeQuery(qry);

        // TODO move file to Google Storage
    }
}
