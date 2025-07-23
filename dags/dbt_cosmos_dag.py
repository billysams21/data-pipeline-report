from __future__ import annotations
import pendulum
from airflow.models.dag import DAG
from cosmos import DbtDag

# sesuai dbt_project.yml
profile_config = {
  "profile_name": "analytics_project",
  "target_name": "dev",
  "profiles_yml_path": "/opt/airflow/dbt/profiles/profiles.yml",
}

# Definisikan DAG dbt
dbt_cosmos_dag = DbtDag(
  # Konfigurasi DAG
  dag_id="dbt_cosmos_dag",
  schedule_interval="@daily",
  start_date=pendulum.datetime(2023, 1, 1, tz="UTC"),
  catchup=False,
  tags=["dbt", "cosmos"],
  # Konfigurasi Proyek dbt
  project_dir="/opt/airflow/dbt",
  # Konfigurasi Profil dbt
  profile_config=profile_config,
  # Konfigurasi Eksekusi
  dbt_command="run",  # Perintah dbt yang akan dijalankan
  # Cosmos akan menjalankan 'dbt run' secara default
)