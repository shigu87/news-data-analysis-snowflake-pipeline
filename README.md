# News Data Analysis with Snowflake Pipeline

## Table of Contents

- [Introduction](#introduction)
- [Technologies Used](#technologies-used)
- [Project Workflow](#project-workflow)
- [Setup Instructions](#setup-instructions)
- [Challenges Faced](#challenges-faced)
- [Outcome](#outcome)
- [Real-World Usefulness](#real-world-usefulness)
- [Future Improvements](#future-improvements)

---

## **Problem Statement**
In the world of news media and content aggregation, there is a constant need to collect, analyze, and store large volumes of news data in an efficient manner. Traditional methods of handling news data often involve batch processing, which can lead to delays in making data available for real-time analysis. Additionally, managing these data streams effectively and storing them in a structured and scalable manner is a critical challenge for any organization aiming to derive meaningful insights from real-time events.

The goal of this project is to streamline the collection and storage of news data by building an automated and event-driven pipeline that extracts data from a news API (NewsAPI), stores it in Google Cloud Storage (GCS) in Parquet format, and then loads it incrementally into Snowflake for analysis.

---

## **Goal**
The primary objective of this project is to create an end-to-end data pipeline that can:

1. Fetch real-time news data from the NewsAPI and process it.
2. Store the processed data in Google Cloud Storage (GCS) in Parquet format.
3. Load this data into Snowflake through an event-driven incremental load mechanism.
4. Implement a workflow using Apache Airflow to orchestrate the extraction, transformation, and loading (ETL) process.

By automating the data pipeline, the project aims to achieve real-time news data analysis that can scale as the volume of news articles increases, ensuring that the data stored in Snowflake is always up-to-date.

---

## **Technologies Used**
- **Airflow**: For scheduling and orchestrating the ETL pipeline.
- **Google Cloud Storage (GCS)**: To store news data in Parquet format.
- **Python**: To write the ETL script for fetching, processing, and storing data.
- **Snowflake**: To load the processed data and store it in an efficient, scalable database.
- **Pandas**: Pandas is used to clean, transform, and structure the raw news data into a DataFrame, which is then saved as a Parquet file for efficient storage and further processing.
- **NewsAPI**: To fetch news data from the News API.

---

## **Project Workflow**
The project consists of the following steps:

1. **Fetching News Data**: The NewsAPI is queried to fetch news data based on predefined parameters (e.g., keyword "apple", date range, language).
   - Sign up at [newsapi.org](https://newsapi.org) and get an API key.
3. **Data Transformation and Storage**: The raw data is transformed into a structured DataFrame using Pandas. The data is then stored as Parquet files locally.
4. **Upload to Google Cloud Storage (GCS)**: The local Parquet files are uploaded to a specific Google Cloud Storage bucket for further processing.
   - `snowflake_projects` in this case
6. **Incremental Data Load to Snowflake**: Using Apache Airflow, the data is loaded from Google Cloud Storage into Snowflake via an external stage. The data is then transformed and stored in the `news_api_data` table for analysis.
   - Place the `airflow_job.py` and `fetch_news.py` scripts in the DAGs folder.
   - Configure a connection in Airflow for Snowflake (`snowflake_conn_id`).
8. **Event-driven Workflow**: Airflow DAGs are set up to ensure that the process runs on a daily schedule and handles failures gracefully.
   - Trigger the `newsapi_to_gcs` DAG from the Airflow UI.

---
### Code Explanation

#### `airflow_job.py`
Orchestrates the entire pipeline:
- **`PythonOperator`** runs `fetch_news_data` from `fetch_news.py`.
- **`SnowflakeOperator`** executes SQL to create the table and copy data from GCS.

#### `fetch_news.py`
- **Fetches news data** from NewsAPI, parses it, and saves it as a Parquet file.
- **Uploads the file** to the specified GCS bucket.
- **Deletes the local file** after upload to save space.

#### `snowflake_commands.sql`
- **Creates Snowflake database** and table schema.
- **Defines the storage integration** and external stage.
- **Executes `COPY INTO` command** to load data from GCS to Snowflake.

---

## **Challenges Faced**
1. **API Rate Limits**: News APIs often have rate limits that restrict the number of API calls within a certain timeframe. To address this, we had to manage API call frequency and handle retries in the Airflow DAGs.
2. **Handling Large Data Volumes**: With increasing news articles, the data volume can quickly become large. Parquet format is used to efficiently store the data in Google Cloud Storage and Snowflake, ensuring that the system can scale with growing data.
3. **Data Cleaning and Transformation**: Data from APIs is often unstructured or semi-structured. We had to clean and transform the data, trimming content and handling missing fields to ensure the final dataset is structured and useful for downstream analysis.
4. **Snowflake Integration**: Setting up the integration between Google Cloud Storage and Snowflake required a clear understanding of Snowflake’s external stage feature, file formats, and how to set up the necessary credentials for seamless data loading.
5. **Error Handling and Monitoring**: Handling errors in the Airflow DAG, such as API failures or issues during data upload, was a critical challenge. To mitigate this, the system includes proper retries and alerts to notify the team of any issues.

---

## **Outcome**
The outcome of this project is a fully automated ETL pipeline that:

- Fetches news data daily from the NewsAPI.
- Processes and stores it in Parquet format on Google Cloud Storage.
- Automatically loads the processed data into Snowflake for further analysis.

This solution ensures that the news data is available for querying and analysis in near real-time, with minimal manual intervention.

The Snowflake data warehouse allows for fast querying, scalability, and easy integration with other business intelligence tools, making the data readily available for reporting, analysis, and decision-making.

---

## **Real-World Usefulness**
In the real world, this solution can be applied to a variety of use cases:

1. **Real-Time News Aggregation**: Companies and organizations can use this pipeline to aggregate and analyze real-time news data. For instance, media companies can monitor news trends and gather insights for their editorial teams.
2. **Sentiment Analysis**: By storing and analyzing news articles, businesses can implement sentiment analysis to track how news events influence public opinion on specific topics or products.
3. **Business Intelligence**: Data analysts can use the news data to enrich business intelligence dashboards and reports, providing valuable context about external events that might affect the business environment.
4. **Marketing and Branding Insights**: Brands can use the data to monitor media coverage, track competitors, and gain insights into consumer behavior and public opinion.
5. **Predictive Analytics**: By analyzing trends in the news, businesses can make predictive models that forecast future events or consumer behavior based on historical data.

---

## **How This Can Be Used for Further Improvements**
1. **Real-Time Data Ingestion**: Currently, the pipeline runs on a daily schedule. This can be enhanced to fetch data in near real-time using event-driven triggers or scheduled smaller intervals (e.g., hourly or even in response to specific events).
2. **Enhanced Data Processing**: More advanced data cleaning and enrichment can be added, including text mining techniques, NLP-based sentiment analysis, or the extraction of specific entities from articles for more advanced analytics.
3. **Scalability**: The architecture can be scaled to handle larger datasets or to query multiple news sources for more comprehensive data collection.

---

## **Instructions to Run**
### 1. **Set Up Snowflake**:
- Create a database and file format in Snowflake.
- Set up the necessary Snowflake credentials (username, password, account).

### 2. **Airflow Setup**:
- Install dependencies using:

    ```bash
    pip install -r requirements.txt
    ```

- Set up Airflow connections for Google Cloud and Snowflake.
- Set up the Airflow variables to store credentials like API keys, Snowflake configurations, etc.

### 3. **Run the DAG**:
- Trigger the `newsapi_to_gcs` DAG in Airflow.
- The DAG will automatically fetch data from NewsAPI, store it in Google Cloud Storage, and load it into Snowflake.

---

