# Schema Fixes Applied Based on Actual Data

## ✅ **Fixed Tests Based on Sample Data Analysis**

### **For stg_main model:**
1. **contact_type**: Added 'unknown' to accepted values ['cellular', 'telephone', 'unknown']
2. **education_level**: Changed from detailed categories to simplified ['primary', 'secondary', 'tertiary', 'unknown']  
3. **previous_campaign_outcome**: Added 'unknown' to accepted values ['failure', 'nonexistent', 'success', 'unknown']

### **For stg_metadata model:**
1. **age**: Re-enabled dbt_utils.accepted_range with expanded range (15-110) to accommodate potential outliers

### **For source tables:**
1. **main.education**: Updated to match actual data values ['primary', 'secondary', 'tertiary', 'unknown']
2. **main.contact**: Added 'unknown' to accepted values ['cellular', 'telephone', 'unknown']
3. **main.poutcome**: Added 'unknown' to accepted values ['failure', 'nonexistent', 'success', 'unknown']

## 📊 **Data Insights from Sample:**

### **Main Dataset Structure:**
- **Education levels**: Uses simplified categories (primary, secondary, tertiary, unknown)
- **Contact types**: Includes 'unknown' in addition to cellular/telephone
- **Previous outcomes**: Includes 'unknown' value
- **pdays**: Uses -1 to indicate "never contacted" (vs 999 in metadata dataset)

### **Metadata Dataset Structure:**  
- **Education levels**: Uses detailed categories (basic.4y, high.school, professional.course, etc.)
- **Contact types**: Only telephone in sample (but cellular might exist elsewhere)
- **Previous outcomes**: Uses 'nonexistent' (vs 'unknown' in main dataset)
- **pdays**: Uses 999 to indicate "never contacted"

## 🔄 **Key Differences Between Datasets:**

| Aspect | Main Dataset | Metadata Dataset |
|--------|-------------|------------------|
| Education | primary/secondary/tertiary | basic.4y/high.school/etc |
| Never contacted indicator | pdays = -1 | pdays = 999 |
| Unknown outcomes | 'unknown' | 'nonexistent' |
| Additional fields | balance, day (of month) | economic indicators, day_of_week |

## 🎯 **Tests Should Now Pass:**
- All accepted_values tests updated with correct values
- Age range expanded to realistic bounds
- Source table tests aligned with actual data structure

## 🔍 **Next Steps if Tests Still Fail:**
1. Check for additional edge cases in full dataset
2. Verify economic indicators don't have NULL values  
3. Check if there are more education categories in full data
4. Monitor for data quality issues (extra spaces, case sensitivity)
