from pyspark.sql import SparkSession

def sparkSession():
    spark = SparkSession.builder \
        .config("spark.hadoop.fs.defaultFS", "s3a://platform") \
        .config("spark.hadoop.fs.s3a.impl", "org.apache.hadoop.fs.s3a.S3AFileSystem") \
        .config("spark.hadoop.fs.s3a.connection.ssl.enabled", "false") \
        .config("spark.hadoop.fs.s3a.aws.credentials.provider","org.apache.hadoop.fs.s3a.SimpleAWSCredentialsProvider") \
        .config("spark.hadoop.fs.s3a.endpoint","http://minio:9000") \
        .config("spark.hadoop.fs.s3a.path.style.access","true") \
        .config("spark.hadoop.fs.s3a.access.key","accesskey") \
        .config("spark.hadoop.fs.s3a.secret.key","secretkey") \
        .config("spark.sql.catalogImplementation","hive") \
        .config("spark.sql.hive.thriftServer.singleSession","false") \
        .config("spark.serializer","org.apache.spark.serializer.KryoSerializer") \
        .config("spark.hive.metastore.uris","thrift://hive-metastore2:9083") \
        .config("spark.hive.metastore.schema.verification","false") \
        .config("spark.sql.ansi.enabled","true") \
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
        .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog") \
        .config("spark.sql.catalog.spark_catalog.type","hive") \
        .config("spark.sql.catalog.spark_catalog.uri","thrift://hive-metastore:9083") \
        .master("spark://spark-master:7077").getOrCreate()
    return spark