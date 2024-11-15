CREATE DATABASE news_api;

USE news_api;

CREATE FILE FORMAT parquet_format TYPE=parquet;

CREATE OR REPLACE STORAGE INTEGRATION news_data_gcs_integration
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = GCS
ENABLED = TRUE
STORAGE_ALLOWED_LOCATIONS = ('gcs://snowflake_projects/news_data_analysis/parquet_files/')
;

DESC INTEGRATION news_data_gcs_integration; # To get the service account details, which will help later in establishing a stage 

CREATE OR REPLACE STAGE gcs_raw_data_stage
URL = 'gcs://snowflake_projects/news_data_analysis/parquet_files/'
STORAGE_INTEGRATION = news_data_gcs_integration
FILE_FORMAT = (TYPE = 'PARQUET')
;

show stages;

select * from news_api_data order by "newsTitle";
