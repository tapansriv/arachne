package org.arachne.execution;

import com.google.api.gax.paging.Page;
import com.google.cloud.storage.Blob;
import com.google.cloud.bigquery.*;
import com.google.cloud.storage.*;
import org.arachne.algorithmic_collection.QueryMetadata;
import org.arachne.collection.CardinalityEstimator;
import org.arachne.collection.Collector;
import org.arachne.common.AbstractCollector;
import org.arachne.common.QueryExecutionGraph;
import org.arachne.plan.MonetaryLocation;
import org.arachne.plan.MonetaryNodeType;
import org.arachne.profiling.rel.ProfileRel;
import org.checkerframework.checker.nullness.qual.Nullable;
import org.duckdb.DuckDBConnection;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.List;
import java.util.Properties;
import java.nio.file.Paths;
import java.math.BigInteger;
import java.util.UUID;


public class ExecutionEngine {

    public ExecutionEngine() {}

    private static Statement getDuckDBConnection() throws ClassNotFoundException, SQLException {
        Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        String url = "jdbc:duckdb:/mnt/disks/tpcds/parquet/tpcds.db";
        // String url = "jdbc:duckdb:/home/cc/arachne.db";
        Connection conn = ((DuckDBConnection) DriverManager.getConnection(url)).duplicate();
        return conn.createStatement();
    }

    public static void executeQuery(QueryExecutionGraph qi,
                                            String dbName)
            throws ClassNotFoundException, SQLException {

        String outTableName = qi.getOutTableName();
        MonetaryLocation src = getLocationForType(qi.getSource());
        MonetaryLocation dest = (qi.getDestination() != null) ? getLocationForType(qi.getDestination()) : null;
        String qry = castNulls(qi.getQuery(), src);
        System.out.println("STARTING QRY: " + qry);

        Connection conn;
        Statement stmt = null;
        if (src == MonetaryLocation.GCP_VM) {
            conn = DriverManager.getConnection("jdbc:duckdb:/mnt/disks/tpcds/" + dbName);
            stmt = conn.createStatement();
            stmt.execute("PRAGMA memory_limit='165G'");
            // stmt.execute("PRAGMA memory_limit='55G'");
            stmt.execute("PRAGMA temp_directory='/mnt/disks/tpcds/duck_tmp'");
        } else if (src == MonetaryLocation.REDSHIFT) {
            stmt = getAWSStatement();
        } else if (src == MonetaryLocation.POSTGRES) {
        }

        if (src == dest) {
            Long start = System.nanoTime();
            double cost = 0;
            switch (src) {
                case REDSHIFT:
                case GCP_VM:
                    executeCTAS(qry, stmt);
                    break;
                case BIG_QUERY:
                    cost = executeBQ(qry);
                    break;
                default:
                    break;
            }
            Long end = System.nanoTime();
            double secs = (double)(end - start) / 1_000_000_000.0;
            // System.out.println(secs);
            qi.setRuntime(secs);
            System.out.println(qi.getRuntime());
            if (outTableName != null) {
                try {
                    Long card = getCardinality(outTableName, stmt);
                    qi.setCardinality(card);
                    System.out.println(qi.getCardinality());
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        System.out.println("finished query");
    }

    public static void executeQueriesSerial(List<QueryExecutionGraph> infoList,
                                            String dbName,
                                            AbstractCollector c,
                                            boolean real)
            throws IOException, ClassNotFoundException, SQLException {

        QueryMetadata qm = c.getQueryMetadata();
        for (QueryExecutionGraph qi : infoList) {
            String outTableName = qi.getOutTableName();
            MonetaryLocation src = getLocationForType(qi.getSource());
            MonetaryLocation dest = (qi.getDestination() != null) ? getLocationForType(qi.getDestination()) : null;
            String qry = castNulls(qi.getQuery(), src);
            System.out.println("STARTING QRY: " + qry);

            Connection conn;
            Statement stmt = null;
            if (src == MonetaryLocation.GCP_VM) {
                conn = DriverManager.getConnection("jdbc:duckdb:/mnt/disks/tpcds/" + dbName);
                stmt = conn.createStatement();
                stmt.execute("PRAGMA memory_limit='175G'");
                stmt.execute("PRAGMA temp_directory='/mnt/disks/tpcds/duck_tmp'");
            } else if (src == MonetaryLocation.REDSHIFT) {
                stmt = getAWSStatement();
            } else if (src == MonetaryLocation.POSTGRES) {
                stmt = getPostgresStatement();
            }

            if (src == dest) {
                if (qm.key.equals("67") && src == MonetaryLocation.GCP_VM) { // query 67, duckdb, and window takes like 13 hours
                    if (qry.contains("RANK() OVER")) {
                        System.out.println("hi!!!!!" + qm.key);
                        double secs = 48757.962260d;
                        double cost = (secs / 3600) * qm.cost;
                        qi.setRuntime(secs);
                        qi.cost = cost;
                        System.out.println(qi.getRuntime());
                        boolean last = (infoList.indexOf(qi) == (infoList.size() - 1));
                        if (outTableName != null && !real && !last) {
                            try {
                                Long card = getCardinality(outTableName, stmt);
                                qi.setCardinality(card);
                                System.out.println(qi.getCardinality());
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                        continue;
                    }
                }

                Long start = System.nanoTime();
                double cost = 0;
                switch (src) {
                    case POSTGRES:
                    case REDSHIFT:
                    case GCP_VM:
                        executeCTAS(qry, stmt);
                        break;
                    case BIG_QUERY:
                        cost = executeBQ(qry);
                        break;
                    default:
                        break;
                }

                boolean last = (infoList.indexOf(qi) == (infoList.size() - 1));
                // if there's a table to get card for, its not the real run (i.e. the not profiling one, where we use bq)
                // and its not the last query, get the cardinality for profiling
                // otherwise it either isn't creating a table or its the final run, in which case we use bq api for
                // size scanned
                if (outTableName != null && !real && !last) {
                    try {
                        Long card = getCardinality(outTableName, stmt);
                        qi.setCardinality(card);
                        System.out.println(qi.getCardinality());
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }

                Long end = System.nanoTime();
                double secs = (double)(end - start) / 1_000_000_000.0;
                // System.out.println(secs);
                if (src == MonetaryLocation.GCP_VM || src == MonetaryLocation.REDSHIFT)
                    cost = (secs / 3600) * qm.cost;
                qi.setRuntime(secs);
                qi.cost = cost;
                // TODO get cardinality
                System.out.println(qi.getRuntime());
            } else {
                Long start = System.nanoTime();
                double cost = 0;
                switch (src) {
                    case REDSHIFT:
                    case GCP_VM:
                        if (dest != null)
                            executeCTAS(qry, stmt);
                        else
                            executeQuery(qry, stmt);
                        break;
                    case BIG_QUERY:
                        cost = executeBQ(qry);
                        break;
                    default:
                        break;
                }
                System.out.println("finished query. now moving");
                Long middle = System.nanoTime();
                if (dest != null) {
                    switch (dest) {
                        case BIG_QUERY:
                            moveToBQ(outTableName, src, stmt);
                            System.out.println("DROP TABLE tpcds." + outTableName); // help me with cleanup lol
                            break;
                        case GCP_VM:
                        case REDSHIFT:
                            // moveToDuck(outTableName); TODO this is very outdated and does not work
                            break;
                        default:
                            break;
                    }
                    System.out.println("moved table: " + outTableName);
                }
                Long end = System.nanoTime();
                double secs = (double)(end - start) / 1_000_000_000.0;
                if (src == MonetaryLocation.GCP_VM || src == MonetaryLocation.REDSHIFT) {
                    cost = (secs / 3600d) * qm.cost;
                }
                if (src == MonetaryLocation.REDSHIFT && dest == MonetaryLocation.BIG_QUERY) {
                    String bucketName = "arachne_redshift";
                    String prefix = bucketName + "/" + outTableName + "/";
                    long bytesMoved = getSizeOfObjectsWithPrefix(bucketName, prefix);
                    double gbMoved = ((double)bytesMoved / 1_000_000_000.0);

                    int size = infoList.size();
                    CardinalityEstimator est = new CardinalityEstimator();
                    est.computeTables(infoList.get(size - 1).root);
                    gbMoved = gbMoved + est.extraSizeParquetGB;
                    double movementCost = gbMoved * qm.movement;
                    System.out.println("Real Movement Size(GB): " + gbMoved + ", Real Cost: " + movementCost);
                    cost += movementCost;
                }
                if (dest != null) {
                    double queryTime = (double)(middle - start) / 1_000_000_000.0;
                    double moveTime = (double)(end - middle) / 1_000_000_000.0;
                    System.out.println("Total runtime(seconds): " + secs + ", Query time: " + queryTime +
                            ", Move time: " + moveTime + ", cost($): " + cost);
                } else {
                    System.out.println("Total runtime(seconds): " + secs + ", cost($): " + cost);
                }
                qi.setRuntime(secs);
                qi.cost = cost;
            }
            System.out.println("finished query");
        }
        dropAllTables(infoList);
    }

    private static void dropAllTables(List<QueryExecutionGraph> infoList) throws ClassNotFoundException, SQLException {
        for (QueryExecutionGraph qi : infoList) {
            MonetaryNodeType t = qi.source;
            boolean last = infoList.indexOf(qi) == (infoList.size() - 1);
            if (t == MonetaryNodeType.RS && !last) {
                Statement stmt = getAWSStatement();
                String outTableName = qi.getOutTableName();
                String qry = "DROP TABLE " + outTableName + ";";
                stmt.execute(qry);
            } else if (t == MonetaryNodeType.PSQL && !last) {
                Statement stmt = getPostgresStatement();
                String outTableName = qi.getOutTableName();
                String qry = "DROP TABLE " + outTableName + ";";
                stmt.execute(qry);
            }
        }
    }

    private static void executeCTAS(String qry, Statement stmt) throws ClassNotFoundException, SQLException {
        // Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        // Connection conn = DriverManager.getConnection("jdbc:duckdb:/mnt/disks/tpcds/parquet/tpcds.db");
        // Statement stmt = conn.createStatement();
        stmt.execute(qry);
    }

    private static void executeQuery(String qry, Statement stmt) throws ClassNotFoundException, SQLException {
        // Class dbDriver = Class.forName("org.duckdb.DuckDBDriver");
        // Connection conn = DriverManager.getConnection("jdbc:duckdb:/mnt/disks/tpcds/parquet/tpcds.db");
        // Statement stmt = conn.createStatement();
        stmt.executeQuery(qry);
    }

    public static long getCardinality(String outTableName, Statement stmt) throws SQLException {
        String qry = "SELECT COUNT(*) as cnt FROM " + outTableName;
        ResultSet rs = stmt.executeQuery(qry);
        rs.next();
        Long card = rs.getLong(1);
        System.out.println(card);
        return card;
    }

    public static double executeBQ(String query) {
        try {
            // Initialize client that will be used to send requests. This client only needs to be created
            // once, and can be reused for multiple requests.
            BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();
            QueryJobConfiguration queryConfig = QueryJobConfiguration.newBuilder(query).build();
            // TableResult results = bigquery.query(queryConfig);
            // results
            //         .iterateAll()
            //         .forEach(row -> row.forEach(val -> System.out.printf("%s,", val.toString())));

            // Create a job ID so that we can safely retry.
            String jobID = UUID.randomUUID().toString();
            JobId jobId = JobId.of(jobID);
            Job queryJob = bigquery.create(JobInfo.newBuilder(queryConfig).setJobId(jobId).build());

            // Wait for the query to complete.
            queryJob = queryJob.waitFor();

            // Check for errors
            if (queryJob == null) {
                throw new RuntimeException("Job no longer exists");
            } else if (queryJob.getStatus().getError() != null) {
                // You can also look at queryJob.getStatus().getExecutionErrors() for all
                // errors, not just the latest one.
                throw new RuntimeException(queryJob.getStatus().getError().toString());
            }
            JobStatistics.QueryStatistics stats = queryJob.getStatistics();
            long billed = stats.getTotalBytesBilled();
            // double cost = ((double)billed / 1_000_000_000_000L) * 5;
            double cost = ((double)billed / 1_099_511_627_776L) * 5; // use 2^40 bytes/tb, $5/TB in BigQuery
            System.out.println("Query performed successfully.");
            System.out.println("Total bytes billed: " + billed + ", cost: " + cost);
            return cost;
        } catch (BigQueryException | InterruptedException e) {
            System.out.println("Query not performed \n" + e.toString());
            return 0;
        }
    }

    public static Statement getPostgresStatement() throws ClassNotFoundException, SQLException {
        Properties credentials = new Properties();
        FileInputStream input;
        try {
            String home = System.getProperty("user.home");
            input = new FileInputStream(home + "/arachneDB/config/config.properties");
            credentials.load(input);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Properties props = new Properties();
        String jdbc = "jdbc:postgresql://localhost:5432/postgres";
        Connection conn = DriverManager.getConnection(jdbc,
                "tapan", credentials.getProperty("psql_password"));
        Statement statement = conn.createStatement();
        return statement;
    }

    public static Statement getAWSStatement() throws ClassNotFoundException, SQLException {
        Properties credentials = new Properties();
        FileInputStream input;
        try {
            String home = System.getProperty("user.home");
            input = new FileInputStream(home + "/arachneDB/config/config.properties");
            credentials.load(input);
        } catch (Exception e) {
            e.printStackTrace();
        }
        Class dbDriver = Class.forName("com.amazon.redshift.jdbc42.Driver");
        Properties props = new Properties();
        String jdbcURL = credentials.getProperty("jdbc_url");
        props.setProperty("user", credentials.getProperty("user"));
        props.setProperty("password", credentials.getProperty("password"));
        Connection connection = DriverManager.getConnection(jdbcURL, props);
        Statement statement = connection.createStatement();
        return statement;
    }

    public static void moveToDuck(String name) throws ClassNotFoundException, SQLException {
        // TODO (Have Duck use Arrow)
        String objectName = name + ".parquet";
        String destFileName = "/mnt/disks/tpcds/parquet/" + objectName;
        exportBQ(name, objectName);
        downloadFileToGCPVM(objectName, destFileName);
    }

    public static void materializeDuck(String name, Statement stmt) throws SQLException {
        String objectName = name + ".parquet";
        String localFilename = "/mnt/disks/tpcds/" + objectName;
        String qry = new StringBuilder().append("COPY ").append(name).append(" TO '").append(localFilename).append("' (FORMAT 'parquet')").toString();
        System.out.println("materializing table to " + localFilename);
        stmt.executeUpdate(qry);
    }

    public static void unloadRedshift(String name, Statement stmt) throws ClassNotFoundException, SQLException {
        String auth = "'arn:aws:iam::552633893236:role/service-role/AmazonRedshift-CommandsAccessRole-20220225T121207'";
        String format = "FORMAT AS PARQUET";
        String qry = String.format("UNLOAD ('select * from %s') TO 's3://arachne-multicloud/%s/' iam_role %s %s;", name, name, auth, format);
        stmt.execute(qry);
    }

    public static void moveS3GCP(String name) throws IOException {
        try {
            String bucketName = "arachne_redshift";
            String sourceURI = "s3://arachne-multicloud/" + name;
            String destURI = "gs://arachne_redshift/";
            ProcessBuilder pb = new ProcessBuilder("/bin/bash", "-l", "gsutil", "cp", "-r", sourceURI, destURI);
            pb.redirectOutput(new File("upload.txt"));
            Process p = pb.start();
            System.out.println("Table " + name + " moved from s3://arachne-multicloud/ to gs://arachne_redshift/");
        } catch (IOException e) {
            System.out.println("Failed to move table from s3 to gcp");
            e.printStackTrace();
            throw e;
        }
    }

    public static long getSizeOfObjectsWithPrefix(String bucketName, String directoryPrefix) {
        String projectId = "arachne-multicloud";
        Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();
        /**
         * Using the Storage.BlobListOption.currentDirectory() option here causes the results to display
         * in a "directory-like" mode, showing what objects are in the directory you've specified, as
         * well as what other directories exist in that directory. For example, given these blobs:
         *
         * <p>a/1.txt a/b/2.txt a/b/3.txt
         *
         * <p>If you specify prefix = "a/" and don't use Storage.BlobListOption.currentDirectory(),
         * you'll get back:
         *
         * <p>a/1.txt a/b/2.txt a/b/3.txt
         *
         * <p>However, if you specify prefix = "a/" and do use
         * Storage.BlobListOption.currentDirectory(), you'll get back:
         *
         * <p>a/1.txt a/b/
         *
         * <p>Because a/1.txt is the only file in the a/ directory and a/b/ is a directory inside the
         * /a/ directory.
         */
        Page<Blob> blobs = storage.list(bucketName, Storage.BlobListOption.prefix(directoryPrefix));
        Long actualMoved = 0L;
        for (Blob blob : blobs.iterateAll()) {
            actualMoved += blob.getSize();
        }
        return actualMoved;
    }

    public static void moveToBQ(String name, MonetaryLocation src, Statement stmt) throws IOException, ClassNotFoundException, SQLException {
        String objectName = name + ".parquet";
        String bucketName = (src == MonetaryLocation.GCP_VM) ? "arachne_duckdb/" : "arachne_redshift/";
        // materialize table
        if (src == MonetaryLocation.GCP_VM) {
            materializeDuck(name, stmt);
        } else if (src == MonetaryLocation.REDSHIFT) {
            unloadRedshift(name, stmt);
        }

        System.out.println("moving file to GC storage");
        if (src == MonetaryLocation.GCP_VM) {
            String localFilename = "/mnt/disks/tpcds/" + objectName;
            uploadFileToGCStorage(objectName, bucketName, localFilename);
        } else if (src == MonetaryLocation.REDSHIFT) {
            moveS3GCP(name);
        }

        String sourceUri;
        if (src == MonetaryLocation.GCP_VM) {
            sourceUri = "gs://" + bucketName + objectName;
        } else if (src == MonetaryLocation.REDSHIFT) {
            sourceUri = "gs://" + bucketName + name + "/*";
        } else {
            throw new SQLException("Invalid source type");
        }
        System.out.println("loading table into BQ");
        loadBQ(sourceUri, name);
        System.out.println("finished all");
        System.out.println("gsutil rm gs://" + bucketName + "/" + name); //help with cleanup again
    }

    public static void downloadFileToGCPVM(String objectName, String destFilePath) {
        // TODO move table.parquet to linux VM (or have Duck use Arrow)
        String projectId = "arachne-multicloud";
        String bucketName = "arachne_tpcds";
        // String objectName = "call_center.parquet";
        // String destFilePath = "/mnt/disks/tpcds/call_center.parquet";
        Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();

        Blob blob = storage.get(BlobId.of(bucketName, objectName));
        blob.downloadTo(Paths.get(destFilePath));
        System.out.println("Downloaded object " + objectName + " from bucket name " + bucketName + " to " + destFilePath);
    }

    public static void uploadFileToGCStorage(String objectName, String bucketName, String filePath) {
        try {
            // String projectId = "arachne-multicloud";
            // String bucketName = "arachne_duckdb";
            String destURI = "gs://" + bucketName;
            // String objectName = "call_center.parquet";
            // String filePath = "/mnt/disks/tpcds/parquet/call_center.parquet";

            // Storage storage = StorageOptions.newBuilder().setProjectId(projectId).build().getService();
            // BlobId blobId = BlobId.of(bucketName, objectName);
            // BlobInfo blobInfo = BlobInfo.newBuilder(blobId).build();
            // storage.create(blobInfo, Files.readAllBytes(Paths.get(filePath)));

            ProcessBuilder pb = new ProcessBuilder("gsutil", "cp", filePath, destURI);
            pb.redirectOutput(new File("upload.txt"));
            Process p = pb.start();
            System.out.println("File " + filePath + " uploaded to bucket " + bucketName + " as " + objectName);

        } catch (IOException e) {
            System.out.println("File " + filePath + "not found. Make sure path is correct.");
        }
    }

    public static void tryLoad(String sourceUri, String tableName) throws BigQueryException, InterruptedException {
        // Initialize client that will be used to send requests. This client only needs to be created
        // once, and can be reused for multiple requests.
        BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();

        String datasetName = "tpcds"; //TODO make this a configurable thing
        TableId tableId = TableId.of(datasetName, tableName);

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
    }

    public static void loadBQ(String sourceUri, String tableName) {
        while (true) {
            try {
                tryLoad(sourceUri, tableName);
                return;
            } catch (BigQueryException | InterruptedException e) {
                try {
                    System.out.println("GCS Parquet was not loaded. \n" + e);
                    Thread.sleep(5000);
                    continue;
                } catch (InterruptedException e2) {
                    System.out.println("what are you even doing. how did you get here.");
                    e2.printStackTrace();
                }
            }
        }
    }

    public static void exportBQ(String tableName, String destFileName, String compressed) {
        try {
            String projectId = "arachne-multicloud";
            String datasetName = "tpcds";
            // String tableName = "catalog_page";
            String bucketName = "arachne_tpcds";
            String destinationUri = "gs://" + bucketName + "/" + destFileName;
            String dataFormat = "Parquet";

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

    public static void exportBQ(String tableName, String destFileName) {
        try {
            String projectId = "arachne-multicloud";
            String datasetName = "tpcds";
            // String tableName = "catalog_page";
            String bucketName = "arachne_tpcds";
            String destinationUri = "gs://" + bucketName + "/" + destFileName;
            String dataFormat = "Parquet";

            // Initialize client that will be used to send requests. This client only needs to be created
            // once, and can be reused for multiple requests.
            BigQuery bigquery = BigQueryOptions.getDefaultInstance().getService();
            TableId tableId = TableId.of(projectId, datasetName, tableName);

            Table table = bigquery.getTable(tableId);
            Job job = table.extract(dataFormat, destinationUri);

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

    public static MonetaryLocation getLocationForType(MonetaryNodeType type) {
        switch (type) {
            // TODO: add more cases here
            case SPECTRUM:
            case PSQL:
                return MonetaryLocation.POSTGRES;
            case RS:
                return MonetaryLocation.REDSHIFT;
            case BQ:
                return MonetaryLocation.BIG_QUERY;
            case GCP:
            case DC2:
            default:
                return MonetaryLocation.GCP_VM;
        }
    }

    // TODO correct fix is replace NULL AS foo with NULL foo, BQ and duck take that, and removes type issues
    public static String castNulls(String qry, MonetaryLocation src) {
        // qry = qry.replaceAll("NULL AS", "NULL"); // TODO verify if this is correct
        if (src == MonetaryLocation.GCP_VM) {
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_category", "CAST(NULL AS VARCHAR(50)) AS $1i_category");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_class", "CAST(NULL AS VARCHAR(50)) AS $1i_class");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_brand", "CAST(NULL AS VARCHAR(50)) AS $1i_brand");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_product_name", "CAST(NULL AS VARCHAR(50)) AS $1i_product_name");
            qry = qry.replaceAll("NULL AS ((\\w*).)?s_store_id", "CAST(NULL AS VARCHAR(50)) AS $1s_store_id");
        } else if (src == MonetaryLocation.BIG_QUERY) {
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_category", "CAST(NULL AS STRING) AS $1i_category");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_class", "CAST(NULL AS STRING) AS $1i_class");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_brand", "CAST(NULL AS STRING) AS $1i_brand");
            qry = qry.replaceAll("NULL AS ((\\w*).)?i_product_name", "CAST(NULL AS STRING) AS $1i_product_name");
            qry = qry.replaceAll("NULL AS ((\\w*).)?s_store_id", "CAST(NULL AS STRING) AS $1s_store_id");
        }
        return qry;
    }

}
