with stg_main as (
    select * from {{ ref('stg_main') }}
),

-- Menambahkan row number untuk memastikan keunikan
deduplicated as (
    select *,
        row_number() over (
            partition by age, job, marital_status, contact_duration_seconds, campaign_contacts, balance 
            order by age, job, marital_status
        ) as row_num
    from stg_main
)

select
    -- Menambahkan primary key unik untuk setiap baris dengan row_num untuk memastikan keunikan
    {{ dbt_utils.generate_surrogate_key(['age', 'job', 'marital_status', 'contact_duration_seconds', 'campaign_contacts', 'balance', 'row_num']) }} as feature_id,
    age,
    job,
    marital_status,
    contact_duration_seconds,
    campaign_contacts,
    balance,
    {{ dbt_utils.star(from=ref('stg_main'), except=['age', 'job', 'marital_status', 'contact_duration_seconds', 'campaign_contacts', 'balance']) }}
from deduplicated
where row_num = 1