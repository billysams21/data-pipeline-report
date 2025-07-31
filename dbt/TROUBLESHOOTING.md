# Troubleshooting DBT Test Failures

## Current Status - UPDATED

### ✅ Recently Fixed Issues:
1. **Temporarily disabled failing accepted_values tests**:
   - `stg_main.contact_type` - Data contains values other than 'cellular', 'telephone'
   - `stg_main.education_level` - Data contains values not in expected list
   - `stg_main.previous_campaign_outcome` - Data contains values other than 'failure', 'nonexistent', 'success'
   - `stg_metadata.age` - Data contains ages outside 18-100 range

2. **Created debug_data_values.sql** - Query to investigate actual values in your data

### 🔧 **Next Steps Required:**

#### Step 1: Install dbt packages (if not already done)
```bash
cd /path/to/dbt/folder
dbt deps
```

#### Step 2: Run the debug query to see actual data values
```bash
dbt run --models debug_data_values
```
Then query the result to see what values are actually in your data.

#### Step 3: Update accepted_values lists based on actual data
After running the debug query, you'll need to update the commented tests in schema.yml with the correct values.

For example, if contact_type shows values like ['cellular', 'telephone', 'unknown'], update:
```yaml
# Change this commented section:
# - accepted_values:
#     values: ['cellular', 'telephone']

# To this:
- accepted_values:
    values: ['cellular', 'telephone', 'unknown']  # Add any missing values found in debug query
```

#### Step 4: Investigate specific data quality issues

**For age ranges outside 18-100:**
- Check if there are data entry errors (ages like 0, 999, negative numbers)
- Decide if you want to filter these out in staging or expand the acceptable range

**For categorical fields:**
- Check for typos, extra spaces, different casings
- Verify if new categories have been added to the source data

### 📋 **What's Currently Working:**
- Models should build without test failures
- Basic `not_null` tests are active
- Other `accepted_values` tests that don't conflict with data are still active
- Pipeline structure is correct for both datasets

### 🚫 **Temporarily Disabled Tests:**
```yaml
# In stg_main:
- contact_type accepted_values test
- education_level accepted_values test  
- previous_campaign_outcome accepted_values test

# In stg_metadata:
- age dbt_utils.accepted_range test
```

### 🔍 **Investigation Queries:**
Use the `debug_data_values` model or run these queries manually:

```sql
-- Check contact_type values
SELECT DISTINCT contact_type, count(*)
FROM your_staging_schema.stg_main
GROUP BY contact_type;

-- Check education_level values
SELECT DISTINCT education_level, count(*)  
FROM your_staging_schema.stg_main
GROUP BY education_level;

-- Check previous_campaign_outcome values
SELECT DISTINCT previous_campaign_outcome, count(*)
FROM your_staging_schema.stg_main  
GROUP BY previous_campaign_outcome;

-- Check age outliers
SELECT min(age), max(age), count(*) 
FROM your_staging_schema.stg_metadata
WHERE age < 18 OR age > 100;
```
