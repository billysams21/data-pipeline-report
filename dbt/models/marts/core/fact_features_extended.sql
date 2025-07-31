with stg_metadata as (
    select * from {{ ref('stg_metadata') }}
),

-- Menambahkan row number untuk memastikan keunikan
deduplicated as (
    select *,
        row_number() over (
            partition by age, job, marital_status, contact_duration_seconds, campaign_contacts, employment_variation_rate 
            order by age, job, marital_status -- atau gunakan kolom timestamp jika ada
        ) as row_num
    from stg_metadata
)

select
    -- Menambahkan sebuah primary key unik untuk setiap baris dengan row_num untuk memastikan keunikan
    {{ dbt_utils.generate_surrogate_key(['age', 'job', 'marital_status', 'contact_duration_seconds', 'campaign_contacts', 'employment_variation_rate', 'row_num']) }} as feature_id,
    age,
    job,
    marital_status,
    contact_duration_seconds,
    campaign_contacts,
    employment_variation_rate,
    -- tambahkan kolom lain yang diperlukan (kecuali row_num)
    {{ dbt_utils.star(from=ref('stg_metadata'), except=['age', 'job', 'marital_status', 'contact_duration_seconds', 'campaign_contacts', 'employment_variation_rate']) }}
from deduplicated
where row_num = 1  -- hanya ambil satu record per kombinasi
