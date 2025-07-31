from __future__ import annotations
import pendulum
from cosmos import ProjectConfig, ProfileConfig
from cosmos import DbtDag
import os

dbt_project_path = f"{os.environ['AIRFLOW_HOME']}/dbt"
dbt_profiles_path = f"{os.environ['AIRFLOW_HOME']}/dbt/profiles"

# Definisikan DAG dbt
dbt_cosmos_dag = DbtDag(
    # Konfigurasi DAG
    dag_id="dbt_cosmos_dag",
    schedule="@daily",
    start_date=pendulum.datetime(2025 , 1, 1, tz="UTC"),
    catchup=False,
    tags=["dbt", "cosmos"],
    # Konfigurasi Profil dbt
    profile_config=ProfileConfig(
        profile_name="analytics_project",
        target_name="dev",
        profiles_yml_filepath=os.path.join(dbt_profiles_path, "profiles.yml"),
    ),
    project_config=ProjectConfig(
        dbt_project_path=dbt_project_path,
    )
)

# wait_for_files >> [stage_main_table, stage_metadata_table] >> dbt_run >> [make_excel, make_pdf]