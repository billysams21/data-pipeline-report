# DBT Models for Bank Marketing Dataset

This dbt project contains models for analyzing bank marketing campaign data. The project supports two different datasets with different column structures.

## Dataset Structure

### 1. Main Dataset (bank-full.csv)
Contains the core bank marketing data with the following columns:
- **age**: Age of the client (numeric)
- **job**: Type of job (categorical: admin., blue-collar, entrepreneur, housemaid, management, retired, self-employed, services, student, technician, unemployed, unknown)
- **marital**: Marital status (categorical: divorced, married, single, unknown; note: divorced means divorced or widowed)
- **education**: Education level (categorical: basic.4y, basic.6y, basic.9y, high.school, illiterate, professional.course, university.degree, unknown)
- **default**: Has credit in default? (categorical: no, yes, unknown)
- **balance**: Average yearly balance in euros (numeric)
- **housing**: Has housing loan? (categorical: no, yes, unknown)
- **loan**: Has personal loan? (categorical: no, yes, unknown)
- **contact**: Contact communication type (categorical: cellular, telephone)
- **day**: Last contact day of the month (numeric: 1-31)
- **month**: Last contact month of year (categorical: jan, feb, mar, ..., nov, dec)
- **duration**: Last contact duration in seconds (numeric) ⚠️ **IMPORTANT**: This attribute highly affects the output target and should be discarded for realistic predictive modeling
- **campaign**: Number of contacts performed during this campaign for this client (numeric, includes last contact)
- **pdays**: Number of days since client was last contacted from previous campaign (numeric; 999 means never contacted)
- **previous**: Number of contacts performed before this campaign for this client (numeric)
- **poutcome**: Outcome of previous marketing campaign (categorical: failure, nonexistent, success)
- **y**: Target variable - has the client subscribed a term deposit? (binary: yes, no)

### 2. Extended Dataset (bank-additional-full.csv)
Contains the same client and campaign data but with additional social and economic context attributes:
- All columns from the main dataset EXCEPT **balance** and **day**
- **day_of_week**: Last contact day of the week (categorical: mon, tue, wed, thu, fri) - replaces **day**
- **emp.var.rate**: Employment variation rate - quarterly indicator (numeric)
- **cons.price.idx**: Consumer price index - monthly indicator (numeric)
- **cons.conf.idx**: Consumer confidence index - monthly indicator (numeric)
- **euribor3m**: Euribor 3 month rate - daily indicator (numeric)
- **nr.employed**: Number of employees - quarterly indicator (numeric)

## Model Structure

### Staging Models
- **stg_main**: Processes the main dataset (bank-full.csv)
- **stg_metadata**: Processes the extended dataset (bank-additional-full.csv)

### Intermediate Models
- **int_customer_order_metrics**: Customer metrics from main dataset with calculated categories
- **int_customer_metrics_extended**: Customer metrics from extended dataset with economic indicators

### Mart Models

#### Core
- **fact_features**: Fact table from main dataset for analysis and modeling
- **fact_features_extended**: Fact table from extended dataset with economic indicators
- **dim_variables**: Dimension table with metadata for all variables

#### Reporting
- **report_summary**: Summary report of subscription rates by job and contact month (from main dataset)
- **report_economic_context**: Economic context analysis with subscription rates (from extended dataset)
- **report_full_dump**: Full data dump from main dataset

## Key Differences Between Datasets

| Feature | Main Dataset | Extended Dataset |
|---------|-------------|------------------|
| Balance information | ✅ | ❌ |
| Day of month | ✅ | ❌ |
| Day of week | ❌ | ✅ |
| Economic indicators | ❌ | ✅ |
| Use case | Basic analysis with financial info | Advanced analysis with economic context |

## Usage Notes

1. **Duration Variable**: The `duration` attribute should typically be excluded from predictive models as it's not known before making a call.

2. **Dataset Selection**: 
   - Use **main dataset models** for analysis requiring balance information
   - Use **extended dataset models** for analysis requiring economic context

3. **Economic Indicators**: Only available in the extended dataset and useful for understanding how macroeconomic factors affect subscription rates.

4. **Contact Day**: Different formats between datasets (day of month vs day of week) - choose based on your analysis needs.
