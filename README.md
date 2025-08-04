# Data Pipeline Report

A comprehensive data pipeline project that integrates Apache Airflow, dbt, and machine learning to process banking data, generate analytics models, and produce automated reports.

## 🏗️ Architecture Overview

This project implements a modern data pipeline with the following components:

- **Apache Airflow**: Orchestrates the entire data pipeline workflow
- **dbt (Data Build Tool)**: Handles data transformations and modeling
- **PostgreSQL**: Primary data warehouse
- **Machine Learning**: Automated model training and evaluation
- **Report Generation**: PDF and Excel report automation
- **Docker**: Containerized deployment with Docker Compose

## 📁 Project Structure

```
data-pipeline-report/
├── dags/                     # Airflow DAG definitions
│   ├── pipeline_dag.py       # Main data pipeline DAG
│   ├── dbt_cosmos_dag.py     # dbt integration with Cosmos
│   ├── function/             # Custom Python functions
│   │   ├── pdf_generator.py  # PDF report generation
│   │   ├── model_trainer.py  # ML model training
│   │   └── ml_report_integration.py
│   └── data/                 # Source data files
├── dbt/                      # dbt project configuration
│   ├── models/               # dbt models (staging, intermediate, marts)
│   ├── dbt_project.yml       # dbt project configuration
│   └── profiles/             # Database connection profiles
├── config/                   # Configuration files
├── output/                   # Generated reports and models
├── assets/                   # Static assets (fonts, images)
├── logs/                     # Application logs
└── docker-compose.yaml       # Docker orchestration
```

## 🚀 Features

### Data Pipeline
- **Automated Data Ingestion**: Processes banking data from ZIP archives
- **Data Transformation**: Multi-layered dbt models (staging → intermediate → marts)
- **Data Quality**: Built-in data validation and testing
- **Orchestration**: Airflow DAGs for workflow management

### Machine Learning
- **Model Training**: Automated ML model training and evaluation
- **Model Comparison**: Performance metrics and visualization
- **Model Persistence**: Saves trained models for future use

### Reporting
- **PDF Reports**: Automated generation of comprehensive data reports
- **Excel Output**: Structured data export with formatting
- **Visualizations**: Charts and graphs for data insights
- **Custom Styling**: Professional report formatting with custom fonts

## 🛠️ Technology Stack

- **Python 3.12**: Primary programming language
- **Apache Airflow**: Workflow orchestration
- **dbt-core**: Data transformation
- **PostgreSQL**: Data warehouse
- **Docker & Docker Compose**: Containerization
- **Pandas**: Data manipulation
- **Scikit-learn**: Machine learning
- **ReportLab**: PDF generation
- **Matplotlib**: Data visualization
- **OpenPyXL**: Excel file handling

## 📋 Prerequisites

- Docker and Docker Compose
- Python 3.12+
- PostgreSQL database
- Git

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/billysams21/data-pipeline-report.git
cd data-pipeline-report
```

### 2. Environment Setup
```bash
# Create and activate virtual environment
python -m venv vit
vit\Scripts\activate  # Windows
# source vit/bin/activate  # Linux/Mac

# Install dependencies
pip install -r requirements.txt
```

### 3. Docker Setup
```bash
# Start the services
docker-compose up -d

# Check service status
docker-compose ps
```

### 4. dbt Setup
```bash
# Navigate to dbt directory
cd dbt

# Install dbt dependencies
dbt deps

# Run dbt models
dbt run

# Test data quality
dbt test
```

### 5. Access Airflow
- Open your browser to `http://localhost:8080`
- Default credentials: `admin/admin`
- Trigger the `data_ingestion_pipeline` DAG

## 📊 Data Pipeline Workflow

1. **Data Ingestion**: Extract data from ZIP archives in the `dags/data/` directory
2. **Data Loading**: Load raw data into PostgreSQL staging tables
3. **dbt Transformations**: 
   - **Staging**: Clean and standardize raw data
   - **Intermediate**: Business logic and calculations
   - **Marts**: Final analytical models
4. **Machine Learning**: Train and evaluate predictive models
5. **Report Generation**: Create PDF and Excel reports with insights
6. **Quality Checks**: Validate data quality and pipeline success

## 🔧 Configuration

### Database Connection
Update `dbt/profiles/profiles.yml` with your PostgreSQL connection details:

```yaml
my_dbt_project:
  outputs:
    dev:
      type: postgres
      host: localhost
      user: your_username
      password: your_password
      port: 5432
      dbname: your_database
      schema: public
```

### Airflow Configuration
- Main configuration: `config/airflow.cfg`
- Connection settings: Configure in Airflow UI under Admin → Connections

## 📈 Monitoring and Logging

- **Airflow Logs**: Available in the Airflow UI and `logs/` directory
- **dbt Logs**: Located in `dbt/logs/dbt.log`
- **Pipeline Metrics**: Dashboard available in Airflow UI
- **Data Quality**: dbt test results and documentation

## 🧪 Testing

### dbt Tests
```bash
cd dbt
dbt test
```

### Data Validation
- Custom data quality checks in dbt models
- Airflow sensor validation
- ML model performance validation

## 📖 Documentation

- **dbt Documentation**: Run `dbt docs generate && dbt docs serve`
- **Airflow DAGs**: Documented within the Airflow UI
- **API Documentation**: Available in function docstrings

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Create a Pull Request

## 📝 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🚨 Troubleshooting

### Common Issues

1. **Docker Services Not Starting**
   - Check Docker daemon is running
   - Verify port availability (8080 for Airflow)
   - Check logs: `docker-compose logs`

2. **dbt Connection Issues**
   - Verify PostgreSQL connection in `profiles.yml`
   - Test connection: `dbt debug`

3. **Data Pipeline Failures**
   - Check Airflow logs in the UI
   - Verify data file formats and paths
   - Ensure sufficient disk space for outputs

### Support
For detailed troubleshooting, see `dbt/TROUBLESHOOTING.md` and check the logs directory.

## 📊 Sample Outputs

The pipeline generates:
- **PDF Reports**: Comprehensive data analysis with visualizations
- **Excel Files**: Structured data exports with formatting
- **ML Models**: Trained models saved in `output/models/`
- **Charts**: Performance metrics and data visualizations

---