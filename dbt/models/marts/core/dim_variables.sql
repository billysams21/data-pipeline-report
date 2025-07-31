select * from (
    values
    -- Client data
    ('age', 'integer', 'Age of the client (numeric)'),
    ('job', 'string', 'Type of job (categorical: admin., blue-collar, entrepreneur, housemaid, management, retired, self-employed, services, student, technician, unemployed, unknown)'),
    ('marital_status', 'string', 'Marital status (categorical: divorced, married, single, unknown; note: divorced means divorced or widowed)'),
    ('education_level', 'string', 'Education level (categorical: basic.4y, basic.6y, basic.9y, high.school, illiterate, professional.course, university.degree, unknown)'),
    ('has_credit_in_default', 'string', 'Has credit in default (categorical: no, yes, unknown)'),
    ('balance', 'decimal', 'Average yearly balance in euros (numeric) - only in main dataset'),
    ('has_housing_loan', 'string', 'Has housing loan (categorical: no, yes, unknown)'),
    ('has_personal_loan', 'string', 'Has personal loan (categorical: no, yes, unknown)'),
    
    -- Contact data 
    ('contact_type', 'string', 'Contact communication type (categorical: cellular, telephone)'),
    ('contact_day_of_month', 'integer', 'Last contact day of the month (numeric: 1-31) - only in main dataset'),
    ('contact_month', 'string', 'Last contact month of year (categorical: jan, feb, mar, ..., nov, dec)'),
    ('contact_day_of_week', 'string', 'Last contact day of the week (categorical: mon, tue, wed, thu, fri) - only in metadata dataset'),
    ('contact_duration_seconds', 'integer', 'Last contact duration in seconds (numeric). IMPORTANT: highly affects output target, should be discarded for realistic predictive model'),
    
    -- Campaign data
    ('campaign_contacts', 'integer', 'Number of contacts performed during this campaign for this client (numeric, includes last contact)'),
    ('days_since_last_contact', 'integer', 'Number of days passed by after client was last contacted from previous campaign (numeric; 999 means client was not previously contacted)'),
    ('previous_contacts', 'integer', 'Number of contacts performed before this campaign for this client (numeric)'),
    ('previous_campaign_outcome', 'string', 'Outcome of the previous marketing campaign (categorical: failure, nonexistent, success)'),
    
    -- Social and economic context attributes (only in metadata dataset)
    ('employment_variation_rate', 'decimal', 'Employment variation rate - quarterly indicator (numeric)'),
    ('consumer_price_index', 'decimal', 'Consumer price index - monthly indicator (numeric)'),
    ('consumer_confidence_index', 'decimal', 'Consumer confidence index - monthly indicator (numeric)'),
    ('euribor_3_month_rate', 'decimal', 'Euribor 3 month rate - daily indicator (numeric)'),
    ('number_of_employees', 'decimal', 'Number of employees - quarterly indicator (numeric)'),
    
    -- Target variable
    ('has_subscribed', 'boolean', 'Has the client subscribed a term deposit? (binary: yes, no)')
) as t(variable_name, data_type, description)