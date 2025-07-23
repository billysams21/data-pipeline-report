#!/bin/bash
docker-compose exec -T postgres psql -U airflow -d airflow -f /var/lib/postgresql/data/sample_data.sql
