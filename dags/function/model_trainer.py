import pandas as pd
import joblib
import matplotlib.pyplot as plt
import numpy as np
from io import BytesIO
import os

from airflow.providers.postgres.hooks.postgres import PostgresHook
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.metrics import accuracy_score, f1_score, roc_auc_score

from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.ensemble import GradientBoostingClassifier

OUTPUT_PATH = "/opt/airflow/output/models"
ASSET_PATH = f"{os.environ['AIRFLOW_HOME']}/assets"

def train_and_evaluate_models(postgres_conn_id: str):
    """
    Fungsi untuk mengambil data, melatih, mengevaluasi,
    dan menyimpan model machine learning.
    """
    os.makedirs(OUTPUT_PATH, exist_ok=True)
    
    # 1. Mengambil data dari tabel fact_features
    hook = PostgresHook(postgres_conn_id=postgres_conn_id)
    df = hook.get_pandas_df(sql="SELECT * FROM public.fact_features")
    print(f"Data shape: {df.shape}")
    print(f"Columns: {list(df.columns)}")
    print(f"First few rows:")
    print(df.head())
    
    target_column = None
    possible_target_names = ['y', 'label', 'outcome', 'result', 'has_subscribed']
    
    for col_name in possible_target_names:
        if col_name in df.columns:
            target_column = col_name
            print(f"Found target column: {target_column}")
            break
    
    if target_column is None:
        print("Available columns:", list(df.columns))
        raise ValueError("Target column not found. Please check the column names in fact_features table.")
    
    # Ganti target menjadi biner (0 atau 1) 
    print(f"Target column '{target_column}' unique values:", df[target_column].unique())
    if target_column == 'has_subscribed':
        df['y'] = df[target_column].astype(int)
    else:
        df['y'] = df[target_column].apply(lambda x: 1 if str(x).lower() in ['yes', '1', 'true', 'positive'] else 0)
    
    # Hapus kolom target asli jika berbeda dari 'y'
    if target_column != 'y':
        df = df.drop(columns=[target_column])
    
    # Validasi data
    print(f"Final dataset shape: {df.shape}")
    print(f"Target distribution: {df['y'].value_counts()}")
    
    if df.empty:
        raise ValueError("No data retrieved from fact_features table")
    
    if 'y' not in df.columns:
        raise ValueError("Target column 'y' not found after processing")

    # 2. Preprocessing Data
    print("Preprocessing data...")
    X = df.drop('y', axis=1)
    y = df['y']
    
    # Hapus feature_id jika ada (karena tidak berguna untuk ML)
    if 'feature_id' in X.columns:
        X = X.drop('feature_id', axis=1)
        print("Removed feature_id column from features")

    # Identifikasi kolom numerik dan kategorikal
    numeric_features = X.select_dtypes(include=['int64', 'float64']).columns
    categorical_features = X.select_dtypes(include=['object']).columns

    # Buat pipeline preprocessing
    preprocessor = ColumnTransformer(
        transformers=[
            ('num', StandardScaler(), numeric_features),
            ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features)
        ])

    # 3. Membagi data train dan test
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)

    # 4. Mendefinisikan dan melatih 4 model
    models = {
        'Logistic Regression': LogisticRegression(random_state=42),
        'Decision Tree': DecisionTreeClassifier(random_state=42),
        'Random Forest': RandomForestClassifier(random_state=42),
        'Gradient Boosting': GradientBoostingClassifier(random_state=42)
    }

    results = {}
    best_model_name = ''
    best_model_f1 = 0.0

    print("Training and evaluating models...")
    for name, model in models.items():
        # Buat pipeline lengkap dengan preprocessor dan model
        pipeline = Pipeline(steps=[('preprocessor', preprocessor),
                                   ('classifier', model)])
        
        # Latih model
        pipeline.fit(X_train, y_train)
        
        # Prediksi
        y_pred = pipeline.predict(X_test)
        
        # Evaluasi
        accuracy = accuracy_score(y_test, y_pred)
        f1 = f1_score(y_test, y_pred)
        auc = roc_auc_score(y_test, y_pred)
        results[name] = {'Accuracy': accuracy, 'F1-Score': f1, 'AUC': auc}
        print(f"{name} -> F1-Score: {f1:.4f}, Accuracy: {accuracy:.4f}, AUC: {auc:.4f}")

        # Simpan model terbaik berdasarkan F1-Score
        if f1 > best_model_f1:
            best_model_f1 = f1
            best_model_name = name
            model_path = os.path.join(OUTPUT_PATH, 'best_model.joblib')
            joblib.dump(pipeline, model_path)
            print(f"New best model found: {name}. Saved to {model_path}")

    # Simpan metadata model untuk PDF generator
    metadata_path = os.path.join(OUTPUT_PATH, 'model_metadata.txt')
    with open(metadata_path, 'w') as f:
        f.write(f"Best Model: {best_model_name}\n")
        if best_model_name in results:
            best_metrics = results[best_model_name]
            f.write(f"Accuracy: {best_metrics['Accuracy']:.4f}\n")
            f.write(f"F1-Score: {best_metrics['F1-Score']:.4f}\n")
            f.write(f"AUC: {best_metrics['AUC']:.4f}\n")
    print(f"Model metadata saved to {metadata_path}")

    # 5. Membuat Visualisasi Perbandingan Model dengan styling konsisten
    print("Creating model comparison chart...")
    results_df = pd.DataFrame(results).T.reset_index().rename(columns={'index': 'Model'})
    
    # Set matplotlib to use transparent background matching other charts
    plt.style.use('default')
    fig, ax = plt.subplots(figsize=(12, 7))
    fig.patch.set_facecolor('none')
    fig.patch.set_alpha(0)
    ax.patch.set_facecolor('none')
    ax.patch.set_alpha(0)
    
    models = results_df['Model']
    f1_scores = results_df['F1-Score']
    
    # Use consistent color scheme with other charts
    colors_palette = ['#09CFF7', '#FF6B6B', '#4ECDC4', '#45B7D1']
    bars = ax.bar(models, f1_scores, color=colors_palette, alpha=0.95, 
                  edgecolor='white', linewidth=2, width=0.7)
    
    # F1-Score labels with consistent white styling
    for i, (bar, score) in enumerate(zip(bars, f1_scores)):
        height = bar.get_height()
        ax.text(bar.get_x() + bar.get_width()/2., height + 0.01,
                f'{score:.3f}', ha='center', va='bottom', 
                fontsize=12, fontweight='bold', color='white')
    
    ax.set_xlabel('Algorithm', fontsize=14, color='white', fontweight='bold')
    ax.set_ylabel('F1-Score', fontsize=14, color='white', fontweight='bold')
    
    # Consistent grid styling
    ax.grid(True, alpha=0.7, linestyle='-', linewidth=1.0, color='white')
    ax.set_axisbelow(True)
    
    # Remove all spines for consistency
    for spine in ax.spines.values():
        spine.set_visible(False)
    
    # White ticks for consistency
    plt.xticks(rotation=0, ha='center', fontsize=11, color='white')
    plt.yticks(color='white', fontsize=11)
    
    # Set y-axis limit for consistent spacing
    max_score = max(f1_scores)
    ax.set_ylim(0, max_score * 1.15)
    
    plt.tight_layout()
    
    chart_path = os.path.join(OUTPUT_PATH, 'model_comparison.png')
    plt.savefig(chart_path, dpi=300, bbox_inches='tight',
                transparent=True, facecolor='none', edgecolor='none',
                pad_inches=0.0)
    plt.close()
    
    return chart_path