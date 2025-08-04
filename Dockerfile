FROM apache/airflow:3.0.3

# Switch to root usetr to install system dependencies if needed
USER root

# Copy requirements file
COPY requirements.txt .

# Switch back to airflow user
USER airflow

# Install Python packages
RUN pip install --no-cache-dir -r requirements.txt