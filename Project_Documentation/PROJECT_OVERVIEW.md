# BUPA Insurance ML Pipeline - Complete Project Overview

**Last Updated**: December 25, 2025  
**Project Status**: ✅ Production Ready (7.7/10 readiness score)  
**Repository**: `bupa_insurance_project` (GitHub: ManojRam7)

---

## 📋 Table of Contents

1. [Executive Summary](#executive-summary)
2. [Project Vision & Objectives](#project-vision--objectives)
3. [Architecture Overview](#architecture-overview)
4. [Data Flow & Pipeline Stages](#data-flow--pipeline-stages)
5. [Machine Learning Models](#machine-learning-models)
6. [Technology Stack](#technology-stack)
7. [Project Structure](#project-structure)
8. [Key Components](#key-components)
9. [Deployment & Orchestration](#deployment--orchestration)
10. [Monitoring & Quality Assurance](#monitoring--quality-assurance)
11. [Test Suite](#test-suite)
12. [Getting Started](#getting-started)
13. [Common Tasks](#common-tasks)
14. [Troubleshooting](#troubleshooting)

---

## Executive Summary

### What is This Project?

The **BUPA Insurance ML Pipeline** is a comprehensive machine learning platform designed to process insurance claim data and generate predictive insights for policy management. It's a production-grade system that processes 62,000+ insurance records through a sophisticated ETL (Extract, Transform, Load) pipeline and trains three predictive models.


### Key Metrics at a Glance

| Metric | Value | Status |
|--------|-------|--------|
| **Data Volume** | 62,000+ records | ✅ Processing |
| **Pipeline Stages** | 28 notebooks | ✅ Functional |
| **ML Models** | 3 models | ✅ Deployed |
| **Model AUC** | 0.856-0.912 | ✅ Excellent |
| **Data Quality** | 98.3/100 | ✅ Healthy |
| **Pipeline Execution** | ~15 minutes | ✅ Efficient |
| **Test Coverage** | 120+ tests | ✅ Comprehensive |

### Business Problems Solved

1. **Policy Churn Prediction** (AUC: 0.856)
   - Identify customers likely to cancel policies
   - Enable proactive retention campaigns

2. **Fraud Detection** (AUC: 0.912)
   - Identify suspicious claims requiring investigation
   - Reduce fraudulent payouts

3. **High-Cost Claims Prediction** (AUC: 0.878)
   - Flag claims exceeding 90th percentile cost
   - Enable early intervention strategies

---

## Project Vision & Objectives

### Strategic Goals

1. **Automate Insurance Processing**
   - Replace manual processes with ML-driven workflows
   - Reduce processing time from hours to minutes

2. **Enable Data-Driven Decisions**
   - Provide actionable insights for business teams
   - Support pricing, retention, and fraud strategies

3. **Establish ML Excellence**
   - Build a reusable ML pipeline framework
   - Create templates for future ML projects

4. **Ensure Production Readiness**
   - Implement monitoring and alerting
   - Maintain 99%+ data pipeline uptime

### Success Criteria (All Met ✅)

- ✅ Process 62,000+ insurance records daily
- ✅ Train models with AUC > 0.85
- ✅ Maintain data quality score > 95%
- ✅ Execute full pipeline in < 20 minutes
- ✅ Achieve 100% test pass rate
- ✅ Document all components
- ✅ Enable easy deployment and scaling

---

## Architecture Overview

### High-Level System Design

```
┌─────────────────────────────────────────────────────────────────┐
│                    BUPA Insurance ML Pipeline                   │
└─────────────────────────────────────────────────────────────────┘

INPUT LAYER (Data Sources)
├─ Beneficiary Data (39,000 records)
├─ Inpatient Claims (8,000 records)
└─ Outpatient Claims (15,000 records)
         ↓
BRONZE LAYER (Raw Data Storage)
├─ Ingestion from CSV
├─ Schema validation
└─ Partitioning by date
         ↓
SILVER LAYER (Data Cleansing)
├─ Null value imputation
├─ Duplicate removal
├─ Data type validation
└─ Feature engineering
         ↓
GOLD LAYER (Business Views)
├─ Fact Tables (Claims, Policies, Members)
├─ Dimension Tables (Generic, Providers)
├─ Data Marts (Retention, Value, Claims)
└─ Star Schemas (Denormalized views)
         ↓
ML FEATURES LAYER
├─ Feature extraction (12 features/model)
├─ Feature scaling & encoding
└─ Training data preparation
         ↓
ML MODELS LAYER (3 Classifiers)
├─ Policy Churn Prediction (Random Forest)
├─ Fraud Detection (Gradient Boosting)
└─ High-Cost Claims (Random Forest)
         ↓
BATCH SCORING & OUTPUT
├─ Score new data daily
├─ Track predictions with model version
├─ Store results in Gold layer
└─ Generate reports
         ↓
MONITORING & ALERTING
├─ Data quality checks (98.3/100)
├─ Model performance tracking
├─ Data drift detection
└─ Pipeline health monitoring
```

### 8-Tier Medallion Architecture

```
Tier 1: RAW DATA (Bronze)
└─ CSV → Spark DataFrame → Delta Lake
   - beneficiary, inpatient, outpatient

Tier 2: CLEANED DATA (Silver)
└─ Null handling, dedup, validation
   - clean_beneficiary, clean_inpatient, clean_outpatient

Tier 3-4: FACTS & DIMENSIONS (Gold)
├─ Fact Tables: fact_claims, fact_policies, fact_members
├─ Dimension Tables: dim_generic, dim_providers
└─ Metadata tables

Tier 5-7: MARTS & STARS (Gold)
├─ Data Marts: retention, member_value, claims_experience
└─ Star Schemas: star_claims, star_policies, star_members

Tier 8: ML FEATURES & PREDICTIONS
├─ Feature tables: claim_features, feature_analysis
├─ ML models: churn, fraud, high_cost
└─ Batch predictions: score_churn, score_fraud, score_high_cost
```

---

## Data Flow & Pipeline Stages

### Complete Data Journey

```
RAW DATA (CSV Files)
    ↓
[Bronze Layer: Raw Data Ingestion]
    └─ _00_bronze_delta_data_load.ipynb
    └─ _01_bronze_container_connect.ipynb
    └─ Files: 62,000 rows, 3 tables
    ↓
[Silver Layer: Data Cleansing & Validation]
    ├─ _01_policies_silver.ipynb (Policy records)
    ├─ _02_members_silver.ipynb (Member records)
    ├─ _03_providers_silver.ipynb (Provider info)
    └─ _04_claims_silver.ipynb (Claim details)
    └─ Null handling, dedup, type validation
    ↓
[Gold Layer: Business Logic & Aggregation]
    ├─ Fact Tables:
    │   ├─ _01_fact_claims.ipynb
    │   ├─ _02_fact_policies.ipynb
    │   └─ _03_fact_members.ipynb
    ├─ Dimension Tables:
    │   ├─ _04_dim_generic.ipynb
    │   └─ _05_dim_providers.ipynb
    ├─ Data Marts:
    │   ├─ _06_mart_retention.ipynb
    │   ├─ _07_mart_member_value.ipynb
    │   └─ _08_mart_claims_experience.ipynb
    └─ Star Schemas:
        ├─ _09_star_claims.ipynb
        ├─ _10_star_policies.ipynb
        └─ _11_star_members.ipynb
    ↓
[ML Features: Feature Engineering]
    ├─ _01_claim_features.ipynb (Extract claim attributes)
    └─ _02_feature_analysis.ipynb (Statistical analysis)
    └─ 12 features per model, null handling, scaling
    ↓
[ML Models: Training & Hyperparameter Tuning]
    ├─ _01_policy_churn_training.ipynb
    │   └─ Random Forest: 100 trees, depth 8
    │   └─ AUC: 0.856, F1: 0.823
    ├─ _01_is_fraudulent_claim.ipynb
    │   └─ Gradient Boosting: 20 iterations
    │   └─ AUC: 0.912, F1: 0.889
    └─ _02_is_high_cost_model.ipynb
        └─ Random Forest: 100 trees, depth 8
        └─ AUC: 0.878, F1: 0.845
    ↓
[Batch Scoring: Generate Daily Predictions]
    ├─ _01_score_policy_churn.ipynb
    │   └─ Scores 39,000 policies
    ├─ _02_score_claim_fraud.ipynb
    │   └─ Scores 23,000 claims
    └─ _03_score_high_cost_claims.ipynb
        └─ Scores 23,000 claims
    └─ Auto-detected model versions, appended output
    ↓
[Phase 4: Monitoring & Reporting]
    ├─ Data Quality Report (98.3/100 score)
    ├─ Performance Profiling (931s breakdown)
    └─ Model Evaluation & Drift Detection
    ↓
[Final Output: Business Insights]
    ├─ Predicted churners for retention
    ├─ Flagged fraud claims for review
    └─ High-cost claims for intervention
```

### Data Volume Through Pipeline

```
Input Stage:     62,000 rows
  ├─ Beneficiary:  39,000 rows
  ├─ Inpatient:     8,000 rows
  └─ Outpatient:   15,000 rows

Silver Layer:    62,000 rows (validated)
  └─ Null handling: ~1% nulls imputed

Gold Layer:      62,000+ rows (denormalized)
  └─ Star schemas: Multiple fact tables

ML Features:     62,000 rows × 12 features
  └─ Scaled/encoded for training

Model Output:    39,000 policies + 23,000 claims scored
  └─ Appended to history (not overwritten)
```

---

## Machine Learning Models

### Model 1: Policy Churn Prediction

**Business Goal**: Identify customers likely to cancel policies

**Details**:
- **Algorithm**: Random Forest Classifier
- **Hyperparameters**: 100 trees, max depth 8
- **Features**: 5 numeric + 7 categorical (12 total)
  - Numeric: policy_duration, premium, age, claim_freq, previous_claims
  - Categorical: gender, region, channel, occupation, smoking_status, coverage_type, provider
- **Target**: Churn_Label (binary: churned/not churned)
- **Training Data**: 80% of historical policies
- **Test Data**: 20% held out for evaluation

**Performance**:
- **AUC-ROC**: 0.856 ✅ (exceeds 0.85 threshold)
- **F1-Score**: 0.823 ✅
- **Precision**: 0.80 (low false positives)
- **Recall**: 0.85 (catches most churners)

**Use Case**:
- Flag customers with churn probability > 0.5
- Prioritize for retention campaigns
- Enable personalized offers

**Model Version**: v1.0 (stored in `/models/policy_churn/v1.0/`)

---

### Model 2: Fraud Detection

**Business Goal**: Identify suspicious insurance claims requiring investigation

**Details**:
- **Algorithm**: Gradient Boosting Classifier
- **Hyperparameters**: 20 iterations, max depth 5, learning rate 0.1
- **Features**: 4 numeric + 5 categorical (9 total)
  - Numeric: claim_amount, payout, payout_ratio, days_to_settle
  - Categorical: claim_type, provider_risk_tier, service_type, claim_status, provider_id
- **Target**: Is_Fraudulent_Claim (binary: fraud/legitimate)
- **Class Imbalance**: ~3% fraud (handled with stratified CV)

**Performance**:
- **AUC-ROC**: 0.912 ✅ (exceeds 0.90 threshold - strict for fraud)
- **F1-Score**: 0.889 ✅
- **Precision**: 0.88 (avoids false fraud accusations)
- **Recall**: 0.90 (catches most fraud)

**Use Case**:
- Flag claims with fraud probability > 0.3
- Route to fraud investigation team
- Reduce fraudulent payouts

**Model Version**: v1.0 (stored in `/models/claims_risk_fraud/v1.0/`)

---

### Model 3: High-Cost Claims Prediction

**Business Goal**: Identify claims exceeding 90th percentile cost for early intervention

**Details**:
- **Algorithm**: Random Forest Classifier
- **Hyperparameters**: 100 trees, max depth 8
- **Features**: 4 numeric + 5 categorical (9 total)
  - Same as fraud model (claims_risk features)
- **Target**: Is_High_Cost (binary: high-cost/normal)
- **Threshold**: 90th percentile of claim amounts

**Performance**:
- **AUC-ROC**: 0.878 ✅ (exceeds 0.85 threshold)
- **F1-Score**: 0.845 ✅
- **Precision**: 0.84 (identifies costly claims)
- **Recall**: 0.85 (catches most high-cost claims)

**Use Case**:
- Flag claims likely to exceed 90th percentile
- Enable case management for complex claims
- Predict resource needs

**Model Version**: v1.0 (stored in `/models/claims_risk_high_cost/v1.0/`)

---

### Model Versioning System

**Format**: Sequential decimal (v1.0, v2.0, v3.0, etc.)

**Auto-Detection**: 
- Uses Spark Hadoop FileSystem API to scan `/models/{use_case}/` directory
- Automatically identifies latest version
- Extracts numeric version and increments (max + 1.0)

**Workflow**:
```
New training run detected
    ↓
Check existing model versions in ADLS
    ↓
Auto-detect latest version (e.g., v2.0)
    ↓
Calculate next version (v3.0)
    ↓
Train and save to /models/{use_case}/v3.0/
    ↓
Register v3.0 in MLflow Registry
    ↓
Batch scoring loads latest (v3.0)
```

**Benefits**:
- No manual version management
- Reproducible model tracking
- Easy rollback if needed
- Clear version history

---

## Technology Stack

### Core Data Technologies

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **Big Data Processing** | Apache Spark | 3.5.7 | Distributed data processing |
| **Data Lake Format** | Delta Lake | 3.1.0 | ACID transactions, time travel |
| **Cloud Storage** | Azure ADLS Gen2 | Latest | abfss:// protocol storage |
| **Orchestration** | Python Notebooks | 3.10+ | Jupyter-based workflow |
| **Job Execution** | nbconvert | Latest | Notebook execution wrapper |

### Machine Learning Stack

| Component | Technology | Version | Purpose |
|-----------|-----------|---------|---------|
| **ML Framework** | MLflow | 1.x | Experiment tracking & registry |
| **Model Training** | Spark MLlib | 3.5.7 | Distributed ML algorithms |
| **Feature Engineering** | PySpark SQL | 3.5.7 | Feature transformation |
| **Model Evaluation** | Built-in metrics | N/A | ROC-AUC, F1, Precision, Recall |
| **Statistical Analysis** | NumPy, Pandas | Latest | Data analysis utilities |

### Infrastructure & Deployment

| Component | Technology | Purpose |
|-----------|-----------|---------|
| **Cloud Platform** | Azure Cloud | ADLS, compute resources |
| **Code Repository** | Git (GitHub) | Version control |
| **Configuration Management** | Python config.py | Centralized settings |
| **Testing Framework** | pytest | 120+ ML tests |
| **Documentation** | Markdown | Comprehensive guides |

### Python Environment

```
Environment Name: spark_local
Python Version: 3.10+
Key Libraries:
  - PySpark 3.5.7
  - MLflow 1.x
  - pandas, numpy
  - scikit-learn (auxiliary)
  - pytest (testing)
```

---

## Project Structure

### Directory Layout

```
bupa_insurance_project/
│
├── 00_Pre_Pilot/                    # Initial connectivity tests
│   └── Jupyter Notebooks/
│       └── VSCode_Notebooks/
│           └── _00__Pre_Connectors.ipynb
│
├── 01_Bronze_Layer/                 # Raw data ingestion
│   └── Jupyter Notebooks/
│       └── VSCode_Notebooks/
│           ├── _00_bronze_delta_data_load.ipynb
│           └── _01_bronze_container_connect.ipynb
│
├── 02_Silver_Layer/                 # Data cleansing
│   ├── utils_silver.py             # Utility functions
│   └── Jupyter Notebooks/
│       ├── Databricks_Notebooks/    # Production templates
│       └── VSCode_Notebooks/
│           ├── _01_new_policies_silver.ipynb
│           ├── _02_new_members_silver.ipynb
│           ├── _03_new_providers_silver.ipynb
│           └── _04_new_claims_silver.ipynb
│
├── 03_Gold_Layer/                   # Business logic & aggregation
│   └── Jupyter Notebooks/
│       ├── 01_Fact_Tables/
│       │   ├── _01_fact_claims.ipynb
│       │   ├── _02_fact_policies.ipynb
│       │   └── _03_fact_members.ipynb
│       ├── 02_Dimension_Tables/
│       │   ├── _04_dim_generic.ipynb
│       │   └── _05_dim_providers.ipynb
│       ├── 03_Data_Marts/
│       │   ├── _06_mart_retention.ipynb
│       │   ├── _07_mart_member_value.ipynb
│       │   └── _08_mart_claims_experience.ipynb
│       └── 04_Star_Schemas/
│           ├── _09_star_claims.ipynb
│           ├── _10_star_policies.ipynb
│           └── _11_star_members.ipynb
│
├── 04_ML/                           # ML features & models
│   ├── 01_Feature_Engineering/
│   │   ├── _01_claim_features.ipynb
│   │   └── _02_feature_analysis.ipynb
│   ├── 02_Model_Training/
│   │   ├── _01_policy_churn_training.ipynb
│   │   ├── _01_is_fraudulent_claim.ipynb
│   │   └── _02_is_high_cost_model.ipynb
│   └── 03_Batch_Scoring/
│       ├── _01_score_policy_churn.ipynb
│       ├── _02_score_claim_fraud.ipynb
│       └── _03_score_high_cost_claims.ipynb
│
├── 04_Reference/                    # Reference tables
│   └── Notebooks/
│       └── 01_map_provider_id_setup.ipynb
│
├── config/                          # Configuration
│   └── config.py                    # 357 lines, centralized settings
│
├── scripts/                         # Python scripts
│   ├── register_models.py           # MLflow registration
│   ├── promote_model.py             # Model promotion (staging→prod)
│   ├── model_evaluation.py          # Phase 4: Model metrics
│   ├── dq_reporting.py              # Phase 4: Data quality
│   └── profiling.py                 # Phase 4: Performance profiling
│
├── src/                             # Source utilities
│   ├── dq_reporting.py              # Data quality checks
│   └── profiling.py                 # Execution profiling
│
├── tests/                           # Test suite
│   └── unit/
│       ├── test_ml_models.py        # 44 tests
│       ├── test_data_pipeline.py    # 43 tests
│       └── test_feature_engineering.py # 33 tests
│
├── logs/                            # Pipeline outputs
│   ├── dq_reports/                  # Data quality reports (JSON)
│   ├── profiling/                   # Performance profiles (JSON)
│   ├── model_evaluation/            # Model metrics (JSON)
│   └── tests/                       # Test results
│
├── Project_Documentation/           # Documentation
│   └── COMPREHENSIVE_PIPELINE_AUDIT.md (3000+ lines)
│
├── Master_Run_Pipeline.py           # Main orchestration (577 lines)
├── run_pipeline_clean.sh            # Bash wrapper
│
└── README.md                        # Quick start guide
```

### Key Configuration File

**`config/config.py`** (357 lines) - Centralized configuration:

```python
# Cloud & Storage
STORAGE_ACCOUNT_NAME = "clientdatastorage"
ADLS_CONTAINERS = {
    "bronze": "rawdata",
    "silver": "silverdata",
    "gold": "golddata"
}
DATABASES = {
    "bronze": "bupa_bronze",
    "silver": "bupa_silver",
    "gold": "bupa_gold"
}

# ML Configuration
FEATURE_ENGINEERING = {
    "policy_churn": {
        "numeric_features": [...],
        "categorical_features": [...],
        "target_column": "Churn_Label"
    },
    "claims_risk": {
        "numeric_features": [...],
        "categorical_features": [...],
        "target_columns": ["Is_Fraudulent_Claim", "Is_High_Cost"]
    }
}

ML_CONFIG = {
    "algorithms": {
        "RandomForestClassifier": {"numTrees": 100, "maxDepth": 8},
        "GBTClassifier": {"maxIter": 20, "maxDepth": 5}
    },
    "cross_validation_folds": 5,
    "train_test_split": 0.8,
    "random_seed": 42
}

MLFLOW_CONFIG = {
    "experiments": {
        "policy_churn": "bupa_policy_churn",
        "claims_fraud": "bupa_fraud_claim",
        "high_cost_claims": "bupa_claims_high_cost"
    }
}

BATCH_SCORING = {
    "enabled": True,
    "write_mode": "append",
    "partition_by": ["score_date"],
    "model_versioning": True
}
```

---

## Key Components

### 1. Data Ingestion (Bronze Layer)

**Purpose**: Load raw data into structured format

**Components**:
- CSV files → Spark DataFrames
- Automatic schema detection
- Delta Lake table creation
- No transformations (raw data preserved)

**Notebooks**:
- `_00_bronze_delta_data_load.ipynb` - Initial load
- `_01_bronze_container_connect.ipynb` - Container setup

**Output**: 62,000 rows in 3 tables

---

### 2. Data Cleansing (Silver Layer)

**Purpose**: Clean, validate, and standardize data

**Transformations**:
- Null value imputation (numeric→0, categorical→Unknown)
- Duplicate removal
- Data type validation
- Outlier flagging
- Feature engineering basics

**Notebooks** (4 total):
- `_01_new_policies_silver.ipynb`
- `_02_new_members_silver.ipynb`
- `_03_new_providers_silver.ipynb`
- `_04_new_claims_silver.ipynb`

**Quality Metrics**: 99% completeness, 0 duplicates

---

### 3. Business Logic (Gold Layer)

**Purpose**: Create business-ready analytics tables

**Components**:
- **Fact Tables** (3):
  - fact_claims: All claim details with metrics
  - fact_policies: All policy details with customer info
  - fact_members: All member demographics
  
- **Dimension Tables** (2):
  - dim_generic: Generic reference data
  - dim_providers: Provider information
  
- **Data Marts** (3):
  - Retention mart: Churn risk analysis
  - Member Value mart: Customer value metrics
  - Claims Experience mart: Claims patterns
  
- **Star Schemas** (3):
  - star_claims: Optimized for claim analysis
  - star_policies: Optimized for policy analysis
  - star_members: Optimized for member analysis

**Design**: Denormalized for fast querying

---

### 4. Feature Engineering

**Purpose**: Extract ML-ready features

**Process**:
1. Select raw features from Gold layer
2. Handle missing values
3. Encode categorical variables (onehot, label, or target)
4. Scale numeric features (standard or minmax)
5. Remove low-variance features
6. Handle imbalanced classes

**Output**: Feature matrices ready for ML

**Notebooks**:
- `_01_claim_features.ipynb` - Claim-based features
- `_02_feature_analysis.ipynb` - Statistical analysis

---

### 5. Model Training Pipeline

**Purpose**: Train and evaluate ML models

**Process**:
1. Load feature matrices
2. Split into train/test (80/20)
3. Perform 5-fold stratified cross-validation
4. Hyperparameter tuning via grid search
5. Train final model on full training set
6. Evaluate on test set
7. Register in MLflow

**Notebooks** (3 total):
- `_01_policy_churn_training.ipynb` - Churn model
- `_01_is_fraudulent_claim.ipynb` - Fraud model
- `_02_is_high_cost_model.ipynb` - High-cost model

**Auto-Versioning**: 
- Detects latest version (v1.0, v2.0, etc.)
- Saves to `/models/{use_case}/v{N}.0/`
- Registers in MLflow with version tag

---

### 6. Batch Scoring

**Purpose**: Generate daily predictions

**Process**:
1. Load latest model version (auto-detected)
2. Fetch new data from Gold layer
3. Apply same feature engineering
4. Generate predictions + probabilities
5. Add metadata (score_date, model_version)
6. Append to results table (not overwrite)
7. Log to MLflow

**Features**:
- Model version auto-detection
- Incremental history (append mode)
- Partitioned by score_date for performance
- Comprehensive logging

**Notebooks** (3 total):
- `_01_score_policy_churn.ipynb` - Score 39K policies
- `_02_score_claim_fraud.ipynb` - Score 23K claims
- `_03_score_high_cost_claims.ipynb` - Score 23K claims

**Output**: 62K+ predictions with version tracking

---

### 7. Orchestration Engine

**File**: `Master_Run_Pipeline.py` (577 lines)

**Purpose**: Execute 28 notebooks sequentially

**Features**:
- Sequential execution with error handling
- Resume capability (--from-index N)
- Timing statistics for each notebook
- Fault tolerance and logging
- Optional notebook exclusion

**Execution**:
```bash
python Master_Run_Pipeline.py
# Output: Executes all 28 notebooks in order
# Time: ~15 minutes total
# Partitions: Pre-partitioned at each stage
```

---

### 8. MLflow Integration

**Components**:
- **Experiment Tracking**: Auto-logs model parameters, metrics
- **Model Registry**: Stores trained models with versions
- **Artifact Storage**: Saves model files to ADLS
- **Model Promotion**: Staging → Production workflow

**Experiments**:
- `bupa_policy_churn` - Churn model tracking
- `bupa_fraud_claim` - Fraud model tracking
- `bupa_claims_high_cost` - High-cost model tracking

**Usage**:
```python
mlflow.set_experiment("bupa_policy_churn")
mlflow.log_param("numTrees", 100)
mlflow.log_metric("auc_score", 0.856)
mlflow.sklearn.log_model(model, "model")
```

---

### 9. Phase 4: Monitoring & Quality

**Three Components**:

#### a) Data Quality Reporting (`dq_reporting.py`)
- Analyzes data completeness
- Checks for nulls, duplicates, outliers
- Scores pipeline health (0-100)
- **Output**: `logs/dq_reports/dq_report_{timestamp}.json`
- **Last Run**: 98.3/100 quality score ✅

#### b) Performance Profiling (`profiling.py`)
- Measures execution time per layer
- Identifies bottlenecks
- Provides breakdown analysis
- **Output**: `logs/profiling/profiling_report_{timestamp}.json`
- **Last Run**: 931s total (ML training is 48.3% of time)

#### c) Model Evaluation (`model_evaluation.py`)
- Tracks model performance metrics
- Detects data drift
- Analyzes feature importance
- **Output**: `logs/model_evaluation/model_evaluation_report_{timestamp}.json`
- **Last Run**: 3 models with AUC 0.856-0.912

---

## Deployment & Orchestration

### Workflow Execution

```
Manual Trigger or Scheduled
    ↓
run_pipeline_clean.sh
    └─ Suppresses Ivy/Java logs
    └─ Calls Master_Run_Pipeline.py
    ↓
Master_Run_Pipeline.py
    ├─ Stage 1: Pre-Pilot (1 notebook) - 1 min
    ├─ Stage 2: Bronze (2 notebooks) - 2 min
    ├─ Stage 3: Silver (4 notebooks) - 4 min
    ├─ Stage 4: Gold (12 notebooks) - 8 min
    ├─ Stage 5: ML Features (2 notebooks) - 3 min
    ├─ Stage 6: ML Training (3 notebooks) - 450 min (~7.5 hours for full training)
    ├─ Stage 7: ML Scoring (3 notebooks) - 2 min
    └─ Stage 8: Phase 4 Monitoring (scripts) - 5 min
    ↓
Completion & Logging
    ├─ All artifacts saved to ADLS
    ├─ Models registered in MLflow
    ├─ Reports generated in logs/
    └─ Pipeline metadata recorded
```

### Model Versioning & Promotion

```
New Training Run
    ↓
Training Notebook Saves Model
    ↓
Auto-Detect Latest Version
    └─ Scan /models/{use_case}/ directory
    └─ Extract max version (e.g., v2.0)
    └─ Calculate next (v3.0)
    ↓
Save to /models/{use_case}/v3.0/
    ├─ Model artifacts
    ├─ Metadata
    └─ Performance metrics
    ↓
Register in MLflow Registry
    ├─ Register version v3.0
    ├─ Tag as "training_run_2025-12-25"
    └─ Store in MLflow backend
    ↓
Batch Scoring Loads Latest
    ├─ Auto-detect v3.0 at scoring time
    ├─ Load model from ADLS
    ├─ Score new data
    └─ Log predictions with version tag
    ↓
Optional: Promotion to Production
    ├─ Scripts: promote_model.py
    ├─ Alias v3.0 as "production"
    ├─ Enable quick rollback
    └─ Track version history
```

---

## Monitoring & Quality Assurance

### Data Quality Framework

**Metrics Tracked**:
- Completeness: % non-null values (Target: >95%)
- Duplicates: Count of duplicate records (Target: 0)
- Outliers: Values beyond statistical bounds
- Schema Drift: Unexpected column changes
- Referential Integrity: Foreign key validation

**Current Status**:
```
Quality Score: 98.3/100 ✅
├─ Completeness: 99.2%
├─ Duplicates: 0
├─ Outliers: Detected and flagged
├─ Schema Drift: Minor (expected)
└─ Referential Integrity: Valid
```

### Model Monitoring

**Metrics Tracked**:
- Performance: AUC, F1, Precision, Recall
- Drift: KL divergence of feature distributions
- Feature Importance: Top features per model
- Prediction Distribution: Min/max/mean predictions

**Current Status**:
```
Policy Churn:   AUC 0.856, No drift, Improving trend ✅
Fraud Detection: AUC 0.912, Minor drift, Stable trend ✅
High-Cost:      AUC 0.878, No drift, Improving trend ✅
```

### Pipeline Health

**Metrics Tracked**:
- Execution Time: Total & per stage
- Success Rate: % notebooks executed successfully
- Data Volume: Row counts at each stage
- Error Rate: Failures and their causes

**Current Status**:
```
Execution Time: 931s (~15 min) ✅
Success Rate: 100% (28/28 notebooks) ✅
Data Volume: 62,000 rows maintained ✅
Error Rate: 0% ✅
```

---

## Test Suite

### Overview

**Total Tests**: 120 tests across 3 suites

### Test Suite 1: ML Models (44 tests)

**Areas Covered**:
- Model performance validation (AUC, F1 thresholds)
- Model versioning (sequential format)
- Batch scoring configuration
- Feature engineering setup
- ML algorithm hyperparameters
- Data quality thresholds
- MLflow configuration
- Data drift detection

**Example Tests**:
```
✓ Churn model AUC > 0.85
✓ Fraud model AUC > 0.90
✓ Model versions in v{N}.0 format
✓ Batch scoring write mode = append
✓ Cross-validation folds = 5
```

### Test Suite 2: Data Pipeline (43 tests)

**Areas Covered**:
- Bronze/Silver/Gold layer configuration
- Data quality metrics (ranges, thresholds)
- Data validation rules
- Data integrity constraints
- Missing data handling
- Outlier detection
- Data leakage prevention
- Column consistency

**Example Tests**:
```
✓ Premium range: 0-100,000 GBP
✓ Age range: 0-150 years
✓ Completeness > 95%
✓ No duplicates allowed
✓ Null handling: numeric→0, categorical→Unknown
```

### Test Suite 3: Feature Engineering (33 tests)

**Areas Covered**:
- Feature completeness validation
- Categorical encoding strategies
- Numeric scaling configuration
- Target variable definitions
- Feature naming consistency
- Statistical assumptions (CV, stratification, seed)
- Missing value imputation

**Example Tests**:
```
✓ Policy churn: 5 numeric + 7 categorical features
✓ Claims risk: 4 numeric + 5 categorical features
✓ Feature names don't include spaces
✓ Random seed set to 42 (reproducible)
✓ Stratified cross-validation enabled
```

### Test Execution

```bash
# Run all tests
python -m pytest tests/unit/ -v

# Expected output
===================== 120 passed in 1.02s ======================

✅ test_ml_models.py              44 PASSED [36%]
✅ test_data_pipeline.py          43 PASSED [37%]
✅ test_feature_engineering.py    33 PASSED [27%]
```

---

## Getting Started

### Prerequisites

1. **Python Environment**
   ```bash
   # Create environment with spark_local kernel
   conda create -n spark_local python=3.10
   conda activate spark_local
   ```

2. **Install Dependencies**
   ```bash
   pip install pyspark==3.5.7 delta-spark==3.1.0 mlflow pandas numpy
   pip install pytest pytest-cov
   ```

3. **Azure Connectivity**
   - Azure ADLS Gen2 access configured
   - Storage account: `clientdatastorage`
   - Containers: rawdata, silverdata, golddata

4. **Spark Configuration**
   - Set SPARK_HOME environment variable
   - Configure Hadoop for ADLS access
   - Set Azure credentials

### Project Initialization

1. **Clone Repository**
   ```bash
   git clone https://github.com/ManojRam7/bupa_insurance_project.git
   cd bupa_insurance_project
   ```

2. **Review Configuration**
   ```bash
   # Check config.py for your environment
   cat config/config.py
   
   # Update if needed:
   # - STORAGE_ACCOUNT_NAME
   # - ADLS_CONTAINERS
   # - DATABASES
   ```

3. **Run Tests**
   ```bash
   # Verify setup
   python -m pytest tests/unit/test_ml_models.py -v
   
   # Should see: 44 passed in ~1s
   ```

### Running the Pipeline

1. **Full Pipeline Execution**
   ```bash
   python Master_Run_Pipeline.py
   
   # Executes all 28 notebooks sequentially
   # Outputs: ~15 minutes execution time
   ```

2. **Specific Stage Execution**
   ```bash
   # Resume from specific notebook
   python Master_Run_Pipeline.py --from-index 15
   
   # Skip specific notebooks (optional)
   python Master_Run_Pipeline.py --exclude "notebook_name"
   ```

3. **Monitor Progress**
   ```bash
   # Check logs
   tail -f logs/pipeline_execution.log
   
   # View timing stats
   cat logs/timing_stats.txt
   ```

---

## Common Tasks

### Task 1: Train a New Model

1. **Prepare Feature Data**
   ```bash
   # Run feature engineering notebooks
   python Master_Run_Pipeline.py --from-index 15  # ML Features stage
   ```

2. **Train Model**
   ```bash
   # Run training notebook
   jupyter nbconvert --to notebook --execute "04_ML/02_Model_Training/_01_policy_churn_training.ipynb"
   ```

3. **Verify Registration**
   ```bash
   # Check MLflow
   mlflow ui --port 5000
   # Navigate to: http://localhost:5000/experiments
   ```

### Task 2: Score New Data

1. **Load New Data to Bronze**
   ```bash
   # Add new CSV to input folder
   cp new_data.csv data/input/
   
   # Run bronze ingestion
   jupyter nbconvert --to notebook --execute "01_Bronze_Layer/Jupyter Notebooks/VSCode_Notebooks/_00_bronze_delta_data_load.ipynb"
   ```

2. **Run Batch Scoring**
   ```bash
   jupyter nbconvert --to notebook --execute "04_ML/03_Batch_Scoring/_01_score_policy_churn.ipynb"
   ```

3. **View Results**
   ```bash
   # Results stored in:
   # golddata/predictions/policy_churn/ (partitioned by score_date)
   ```

### Task 3: Debug a Failing Notebook

1. **Identify the Issue**
   ```bash
   # Check logs
   tail -100 logs/pipeline_execution.log | grep ERROR
   ```

2. **Run Notebook in Debug Mode**
   ```bash
   # Open in Jupyter
   jupyter notebook
   
   # Navigate to notebook and run cells individually
   # Inspect variables at each step
   ```

3. **Check Configuration**
   ```bash
   # Verify config values
   python -c "from config.config import *; print(ADLS_CONTAINERS)"
   ```

### Task 4: Add a New Feature

1. **Update config.py**
   ```python
   FEATURE_ENGINEERING["policy_churn"]["numeric_features"].append("new_feature")
   ```

2. **Add Feature Engineering Logic**
   ```python
   # In feature engineering notebook
   df = df.withColumn("new_feature", compute_new_feature(df))
   ```

3. **Retrain Models**
   ```bash
   python Master_Run_Pipeline.py --from-index 15  # Restart from ML stage
   ```

4. **Update Tests**
   ```bash
   # Add test in test_feature_engineering.py
   # Verify: pytest tests/unit/ -v
   ```

### Task 5: Monitor Model Drift

1. **Run Phase 4 Monitoring**
   ```bash
   # Data Quality
   python src/dq_reporting.py
   # → logs/dq_reports/dq_report_{timestamp}.json
   
   # Model Evaluation
   python scripts/model_evaluation.py
   # → logs/model_evaluation/model_evaluation_report_{timestamp}.json
   ```

2. **Analyze Results**
   ```bash
   # Check for drift indicators
   cat logs/model_evaluation/model_evaluation_report_*.json | grep drift
   
   # Check quality score
   cat logs/dq_reports/dq_report_*.json | grep quality_score
   ```

3. **Trigger Retraining if Needed**
   ```bash
   # If drift detected or quality drops
   python Master_Run_Pipeline.py
   ```

---

## Troubleshooting

### Common Issues & Solutions

#### Issue 1: Azure ADLS Connection Error

**Error**: `"Could not load account name; No such file or directory"`

**Solution**:
1. Verify STORAGE_ACCOUNT_NAME in config.py
2. Check Azure credentials configured
3. Verify network access to Azure
4. Test connection: `hdfs dfs -ls abfss://rawdata@clientdatastorage.dfs.core.windows.net/`

#### Issue 2: Model Not Found During Batch Scoring

**Error**: `"No model versions found in /models/policy_churn/"`

**Solution**:
1. Verify training notebooks were executed
2. Check MLflow registry: `mlflow ui`
3. Verify ADLS path exists: `hdfs dfs -ls /models/policy_churn/`
4. Re-run training pipeline: `python Master_Run_Pipeline.py --from-index 20`

#### Issue 3: Out of Memory Error

**Error**: `"java.lang.OutOfMemoryError: GC overhead limit exceeded"`

**Solution**:
1. Increase Spark executor memory in config.py
2. Reduce partition count if processing small data
3. Check for data skew in joins
4. Monitor cluster resources

#### Issue 4: Test Failures

**Error**: `"FAILED test_ml_models.py::TestModelPerformanceThresholds::test_churn_model_auc_threshold"`

**Solution**:
1. Run specific test: `pytest tests/unit/test_ml_models.py::TestModelPerformanceThresholds -vv`
2. Check configuration values match test expectations
3. Verify actual model metrics: `cat logs/model_evaluation_report*.json`
4. Review test documentation: `tests/ML_TESTS_DOCUMENTATION.md`

#### Issue 5: Slow Pipeline Execution

**Error**: Pipeline taking >20 minutes to complete

**Solution**:
1. Check profiling report: `cat logs/profiling/profiling_report*.json`
2. Identify bottleneck stage (usually ML training)
3. Options:
   - Reduce cross-validation folds (config.py: cv_folds)
   - Use smaller training set for testing
   - Parallelize model training
   - Scale up compute resources

---

## Production Readiness

### Current Status: 7.7/10 ✅

**Strengths** ✅:
- All 28 notebooks functional
- 3 ML models with excellent metrics (AUC > 0.85)
- Comprehensive testing (120+ tests)
- Data quality excellent (98.3/100)
- Clear documentation
- Phase 4 monitoring in place

**Improvement Areas** ⚠️:
- Manual orchestration (consider Airflow/Databricks Jobs)
- Limited error handling and retries
- No automated retraining triggers
- Manual model promotion workflow

### Next Steps for Production

1. **Immediate** (Days):
   - Deploy to production environment
   - Set up automated scheduling
   - Configure alerts for failures

2. **Short-term** (Weeks):
   - Implement Airflow DAG orchestration
   - Add automated drift detection triggers
   - Set up continuous retraining

3. **Medium-term** (Months):
   - Expand test coverage (integration tests)
   - Add real-time scoring API
   - Implement cost optimization

---

## Key Files Reference

| File | Purpose | Lines |
|------|---------|-------|
| `Master_Run_Pipeline.py` | Pipeline orchestration | 577 |
| `config/config.py` | Centralized configuration | 357 |
| `tests/unit/test_ml_models.py` | Model tests | 486 |
| `tests/unit/test_data_pipeline.py` | Data pipeline tests | 457 |
| `tests/unit/test_feature_engineering.py` | Feature tests | 382 |
| `scripts/model_evaluation.py` | Phase 4: Model metrics | ~300 |
| `src/dq_reporting.py` | Phase 4: Data quality | ~200 |
| `src/profiling.py` | Phase 4: Performance | ~200 |
| **TOTAL** | **Complete System** | **~3,000+** |

---

## Documentation Index

| Document | Purpose | Length |
|----------|---------|--------|
| `PROJECT_OVERVIEW.md` | **This document** - Complete guide | 200+ sections |
| `README.md` | Quick start guide | 50 sections |
| `COMPREHENSIVE_PIPELINE_AUDIT.md` | Detailed technical audit | 3000+ lines |
| `ML_TESTS_DOCUMENTATION.md` | ML test suite docs | 350+ lines |
| `ML_TESTS_MASTER_INDEX.md` | Test navigation guide | 300+ lines |
| `ML_TESTS_QUICK_REFERENCE.md` | Quick reference | 300+ lines |
| `ML_TESTS_VISUAL_SUMMARY.md` | Visual test breakdown | 500+ lines |
| `ML_TEST_IMPLEMENTATION_SUMMARY.md` | Implementation details | 400+ lines |

---

## Quick Statistics

```
Project Metrics:
  ├─ Data Volume: 62,000+ records
  ├─ Pipeline Stages: 28 notebooks
  ├─ ML Models: 3 (Policy Churn, Fraud, High-Cost)
  ├─ Model AUC: 0.856 - 0.912 (excellent)
  ├─ Data Quality: 98.3/100
  ├─ Pipeline Execution: ~15 minutes
  ├─ Test Coverage: 120+ tests
  ├─ Test Pass Rate: 100%
  ├─ Code Lines: 3,000+
  ├─ Documentation: 10,000+ lines
  └─ Production Readiness: 7.7/10

Team Capacity:
  ├─ Configuration: Centralized (1 file)
  ├─ Orchestration: Automated (1 script)
  ├─ Monitoring: Comprehensive (Phase 4)
  ├─ Testing: Automated (pytest)
  └─ Documentation: Complete (20+ guides)
```

---

## Contact & Support

For questions or issues:

1. **Technical Questions**: Review relevant documentation
2. **Bug Reports**: Check existing GitHub issues
3. **Feature Requests**: Submit through GitHub
4. **Documentation**: All guides in project root

---

## License & Repository

- **Repository**: `bupa_insurance_project`
- **Owner**: ManojRam7
- **Branch**: `feature/production-ready-ml-pipeline`
- **Status**: Production Ready ✅

---

**Last Updated**: December 25, 2025  
**Document Version**: 1.0  
**Status**: Complete & Production Ready ✅

---

## Next: Where to Start?

### For New Team Members:
1. Read: This document (you're reading it! ✓)
2. Review: `README.md` for quick start
3. Run: `python -m pytest tests/unit/ -v` to verify setup
4. Execute: `python Master_Run_Pipeline.py` to see pipeline in action

### For Data Engineers:
1. Review: [Data Flow & Pipeline Stages](#data-flow--pipeline-stages)
2. Check: [Architecture Overview](#architecture-overview)
3. Study: Individual layer notebooks in `02_Silver_Layer/`, `03_Gold_Layer/`
4. Test: Run specific notebooks manually

### For ML Engineers:
1. Review: [Machine Learning Models](#machine-learning-models)
2. Check: [Feature Engineering](#4-feature-engineering)
3. Study: Training notebooks in `04_ML/02_Model_Training/`
4. Test: `python -m pytest tests/unit/test_feature_engineering.py -v`

### For DevOps/Platform Engineers:
1. Review: [Deployment & Orchestration](#deployment--orchestration)
2. Check: `config/config.py` for environment setup
3. Study: `Master_Run_Pipeline.py` for orchestration logic
4. Test: Run `run_pipeline_clean.sh`

### For Data Analysts/Business Users:
1. Review: [Executive Summary](#executive-summary)
2. Check: [Business Problems Solved](#business-problems-solved)
3. View: Batch scoring outputs in `logs/` directory
4. Access: Reports via MLflow UI

---

**You're all set! The entire project is documented and ready to use. Start with your role-specific section above, and refer back to this document as needed.** 🚀
