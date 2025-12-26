# Phase 4: Testing, Profiling, Monitoring & Production Deployment
# Comprehensive Documentation for All Phase 4 Deliverables

## Overview

Phase 4 transforms the production-validated codebase into a fully operational, monitored, and scalable system. This phase encompasses:

1. **End-to-End Testing** - Validate all 26 notebooks and pipeline components
2. **Performance Profiling** - Measure and optimize execution times
3. **Data Quality Reporting** - Continuous quality monitoring across layers
4. **Model Evaluation** - Compare versions and track performance
5. **GCP Deployment** - Migrate infrastructure from Azure to Google Cloud Platform

---

## Table of Contents

- [End-to-End Testing](#end-to-end-testing)
- [Performance Profiling](#performance-profiling)
- [Data Quality Reporting](#data-quality-reporting)
- [Model Evaluation & Comparison](#model-evaluation--comparison)
- [GCP Deployment](#gcp-deployment)
- [Integration with Master Pipeline](#integration-with-master-pipeline)
- [Monitoring & Alerting](#monitoring--alerting)
- [Troubleshooting](#troubleshooting)

---

## End-to-End Testing

### Overview

The E2E testing framework (`tests/test_pipeline_e2e.py`) validates the complete 26-notebook pipeline with:
- Notebook execution validation
- Data quality assertions
- Output verification
- Error tracking and reporting

### Architecture

```python
NOTEBOOK_MANIFEST = {
    # Pre-Pilot Phase (1 notebook)
    "00_Pre_Connectors": {
        "path": "00_Pre_Pilot/Jupyter Notebooks/VSCode_Notebooks/_00__Pre_Connectors.ipynb",
        "layer": "pre-pilot",
        "checks": ["connectivity", "credential_validation"]
    },
    
    # Bronze Layer (2 notebooks)
    "00_bronze_delta_data_load": {
        "path": "01_Bronze_Layer/Jupyter Notebooks/VSCode_Notebooks/_00_bronze_delta_data_load.ipynb",
        "layer": "bronze",
        "checks": ["data_ingestion", "schema_validation", "record_count"]
    },
    
    # ... [continues for all 26 notebooks]
}
```

### Running Tests

```bash
# Install testing dependencies
pip install pytest pytest-cov pytest-xdist

# Run all E2E tests
cd /Users/manojrammopati/Public/Projects/bupa_insurance_project
pytest tests/test_pipeline_e2e.py -v

# Run tests with coverage
pytest tests/test_pipeline_e2e.py --cov=src --cov-report=html

# Run specific layer tests
pytest tests/test_pipeline_e2e.py::PipelineE2ETest::test_bronze_layer -v

# Run with detailed output
pytest tests/test_pipeline_e2e.py -vv -s

# Run in parallel (faster execution)
pytest tests/test_pipeline_e2e.py -n auto
```

### Test Structure

```
Test Results
├── Pre-Pilot Tests (1 notebook)
│   └── Connectivity & Credential Validation
├── Bronze Layer Tests (2 notebooks)
│   └── Data Ingestion & Schema Validation
├── Silver Layer Tests (11 notebooks)
│   ├── Members Processing
│   ├── Policies Processing
│   ├── Claims Processing
│   └── Providers Processing
└── Gold Layer Tests (11 notebooks)
    └── Business-Ready Aggregations
```

### Key Test Methods

```python
# Test entire pipeline
test_result = tester.run_all_tests()

# Test specific layer
bronze_results = tester.test_layer("bronze")

# Test single notebook
notebook_result = tester.test_notebook("02_members_silver")

# Save and print results
tester.save_results(output_file)
tester.print_summary()
```

### Expected Output

```
E2E PIPELINE TEST RESULTS
==================================================
Total Notebooks Tested: 26
Passed: 26
Failed: 0
Skipped: 0
Duration: 3m 45s

Layer Breakdown:
  Pre-Pilot: 1/1 ✅
  Bronze: 2/2 ✅
  Silver: 11/11 ✅
  Gold: 11/11 ✅
  Reference: 1/1 ✅
```

---

## Performance Profiling

### Overview

The performance profiling system (`src/profiling.py`) tracks execution times and identifies bottlenecks:

- Function-level execution metrics
- Layer-wise performance aggregation
- Memory and CPU usage tracking
- Bottleneck identification

### Architecture

```python
class PipelineProfiler:
    """Main profiling orchestrator"""
    
    @profile_function
    def process_members():
        """Automatically timed function"""
        pass
    
    with profiler.profile_context("data_loading"):
        # Code block automatically timed
        spark_df = spark.read.parquet(path)
```

### Usage

#### Function Decorator

```python
from src.profiling import PipelineProfiler, profile_function

@profile_function
def load_bronze_data():
    """Automatically tracked execution time"""
    df = spark.read.format("delta").load("gs://bronze-bucket/members")
    return df

# Call function normally - timing is automatic
df = load_bronze_data()
```

#### Context Manager

```python
from src.profiling import get_profiler

profiler = get_profiler()

with profiler.profile_context("silver_transformation"):
    # This code block is automatically timed
    transformed_df = apply_transformations(df)
    transformed_df.write.mode("overwrite").format("delta").save(output_path)
```

#### Manual Profiling

```python
profiler = get_profiler()

# Manually record metrics
with profiler.track_execution("batch_scoring", "scoring"):
    predictions = model.transform(data)

# Get results
metrics = profiler.get_execution_metrics()
summary = profiler.get_layer_summary("silver")
```

### Running Profiling

```bash
# Profile entire pipeline
python scripts/profile_pipeline.py --environment prod

# Profile specific layer
python scripts/profile_pipeline.py --layer silver

# Generate performance report
python -m src.profiling --output=performance_report.json

# View profiling results
python -c "
from src.profiling import get_profiler
p = get_profiler()
p.print_summary()
"
```

### Metrics Captured

```
PERFORMANCE PROFILE
==================================================
Bronze Layer:
  load_policies: 45.2s (23% of total)
  load_members: 38.5s (19% of total)
  load_claims: 52.3s (26% of total)
  Total: 136.0s (68% of total)

Silver Layer:
  process_policies: 18.5s (9% of total)
  process_members: 22.1s (11% of total)
  process_claims: 19.8s (10% of total)
  Total: 60.4s (30% of total)

Gold Layer:
  aggregate_policies: 2.5s (1% of total)
  aggregate_members: 1.2s (1% of total)
  Total: 3.7s (2% of total)

Total Pipeline Time: 200.1s
Bottleneck: Bronze Layer (68%)
```

### Optimization Targets

Based on profiling results, optimize:

1. **Bronze Layer** - Data ingestion (biggest bottleneck)
   - Parallelize file reading
   - Optimize Delta table structure
   - Consider pre-aggregation

2. **Silver Layer** - Transformations
   - Cache intermediate results
   - Optimize join operations
   - Reduce shuffle operations

3. **Gold Layer** - Already optimized (<5% of total time)

---

## Data Quality Reporting

### Overview

The DQ reporting system (`src/dq_reporting.py`) continuously monitors data quality across all layers:

- Completeness scoring (null rates)
- Validity scoring (format, ranges)
- Freshness metrics (staleness)
- Issue detection and alerting
- Trend analysis

### Architecture

```python
class DataQualityChecker:
    """Comprehensive DQ analysis"""
    
    def check_table_quality(table_name):
        """Column-level quality metrics"""
        # Completeness: % of non-null values
        # Validity: % of values matching expected format
        # Uniqueness: distinct value count
        # Timeliness: freshness of data
    
    def check_referential_integrity(parent, child, key):
        """FK relationship validation"""
        # Orphaned record detection
        # Missing parent records
    
    def check_distribution_stats(table, columns):
        """Statistical analysis"""
        # Min/max/mean/stddev
        # Percentiles (p10, p25, p75, p90)
        # Outlier detection
```

### Running DQ Checks

```bash
# Check all tables
python -c "
from src.dq_reporting import get_dq_checker
checker = get_dq_checker()
report = checker.generate_pipeline_report([
    'members', 'policies', 'claims', 'providers'
])
checker.save_report(report)
"

# Check specific table
python -c "
from src.dq_reporting import get_dq_checker
checker = get_dq_checker()
members_quality = checker.check_table_quality('members')
print(f'Members Quality Score: {members_quality.overall_quality_score:.1f}/100')
"

# Check referential integrity
python -c "
from src.dq_reporting import get_dq_checker
checker = get_dq_checker()
fk_check = checker.check_referential_integrity(
    parent_table='members',
    child_table='claims',
    parent_key='member_id',
    child_key='member_id'
)
print(f'Orphaned records: {fk_check[\"orphaned_records\"]}')
"
```

### Quality Scoring

```
TABLE QUALITY SCORES
==================================================
Members Table:
  Completeness: 99.2% (5 nulls in 1000 records)
  Validity: 97.5% (25 invalid formats)
  Overall Score: 98.4/100

Policies Table:
  Completeness: 98.8% (12 nulls)
  Validity: 98.1% (19 invalid values)
  Overall Score: 98.4/100

Claims Table:
  Completeness: 96.3% (37 nulls)
  Validity: 94.2% (58 invalid)
  Overall Score: 95.2/100
  ⚠️  WARNING: Completeness below 97%

Providers Table:
  Completeness: 99.5% (5 nulls)
  Validity: 99.8% (2 invalid)
  Overall Score: 99.6/100

Pipeline Quality Score: 97.9/100
Status: 🟢 HEALTHY
```

### Alert Thresholds

```python
DQ_THRESHOLDS = {
    "CRITICAL": {
        "completeness_percent": 90,   # Alert if < 90%
        "validity_percent": 90,
        "orphan_percent": 2.0
    },
    "WARNING": {
        "completeness_percent": 95,   # Alert if < 95%
        "validity_percent": 95,
        "orphan_percent": 1.0
    }
}
```

### DQ Report Contents

```json
{
  "generated_at": "2024-01-15T10:30:00Z",
  "total_tables": 4,
  "pipeline_quality_score": 97.9,
  "tables": {
    "members": {
      "record_count": 10000,
      "overall_quality_score": 98.4,
      "columns": [
        {
          "column_name": "member_id",
          "completeness_score": 100.0,
          "validity_score": 99.8
        }
      ],
      "issues": [],
      "warnings": ["member_age has 3% nulls"]
    }
  },
  "critical_issues": [],
  "trends": {
    "quality_trend": "improving",
    "improvement_rate": 2.5
  }
}
```

---

## Model Evaluation & Comparison

### Overview

The model evaluator (`scripts/model_evaluation.py`) tracks and compares model versions:

- Performance metrics tracking (AUC, F1, precision, recall)
- Version comparison with recommendations
- Feature importance analysis
- Data drift detection
- Performance trend analysis

### Architecture

```python
class ModelEvaluator:
    """Evaluate and compare model versions"""
    
    def evaluate_model_version(version, metrics_dict):
        """Store metrics for a version"""
        # AUC, F1, Precision, Recall
        # Training/test performance
        # Inference latency
        # Feature importance
    
    def compare_versions(v1, v2):
        """Compare two versions"""
        # Metric deltas
        # Risk assessment
        # Upgrade recommendation
    
    def analyze_feature_importance():
        """Aggregate feature importance"""
        # Top features across versions
        # Feature stability
    
    def detect_performance_trend():
        """Analyze overall trend"""
        # Improving/stable/degrading
        # Improvement rate
```

### Running Model Evaluation

```bash
# Evaluate all model versions
python scripts/model_evaluation.py \
  --environment prod \
  --generate-report

# Compare specific versions
python scripts/model_evaluation.py \
  --compare v1.2.0 v1.3.0 \
  --show-recommendations

# Analyze feature importance
python scripts/model_evaluation.py \
  --feature-analysis \
  --output=feature_importance.json

# Track drift detection
python scripts/model_evaluation.py \
  --detect-drift \
  --threshold=0.1
```

### Example Usage

```python
from scripts.model_evaluation import get_model_evaluator

evaluator = get_model_evaluator()

# Evaluate version 1.2.0
v1_metrics = evaluator.evaluate_model_version("v1.2.0", {
    "auc_score": 0.88,
    "f1_score": 0.85,
    "precision": 0.86,
    "recall": 0.84,
    "accuracy": 0.87,
    "training_samples": 50000,
    "testing_samples": 10000,
    "feature_count": 45,
    "inference_latency_ms": 45.2,
    "data_drift_detected": False,
    "hyperparameters": {...}
})

# Evaluate version 1.3.0
v2_metrics = evaluator.evaluate_model_version("v1.3.0", {
    "auc_score": 0.90,
    "f1_score": 0.87,
    "precision": 0.88,
    "recall": 0.86,
    "accuracy": 0.89,
    "training_samples": 55000,
    "testing_samples": 11000,
    "feature_count": 48,
    "inference_latency_ms": 48.5,
    "data_drift_detected": False,
    "hyperparameters": {...}
})

# Compare versions
comparison = evaluator.compare_versions("v1.2.0", "v1.3.0")
print(f"Recommendation: {comparison.recommendation}")
print(f"AUC Delta: {comparison.auc_delta:+.4f}")
print(f"Confidence: {comparison.confidence_score:.0f}%")

# Generate report
report = evaluator.generate_evaluation_report(
    current_prod_version="v1.2.0"
)
evaluator.print_report(report)
```

### Example Output

```
MODEL EVALUATION & COMPARISON REPORT
==================================================
Generated: 2024-01-15T10:30:00Z
Versions Evaluated: 5
Performance Trend: improving
Best Version: v1.3.0
Current Production: v1.2.0

MODEL VERSIONS:
  v1.2.0:  AUC=0.8800, F1=0.8500, Precision=0.8600, Latency=45.2ms
  v1.3.0:  AUC=0.9000, F1=0.8700, Precision=0.8800, Latency=48.5ms  ← BEST
  v1.4.0:  AUC=0.8950, F1=0.8650, Precision=0.8750, Latency=46.1ms

VERSION COMPARISONS:
  v1.2.0 vs v1.3.0: recommend=upgrade, confidence=92%, risk=3%
  v1.3.0 vs v1.4.0: recommend=maintain, confidence=78%, risk=8%

TOP FEATURES:
  1. member_age               ████████████████░ 0.1800
  2. claim_amount             ██████████████░░░ 0.1500
  3. claim_frequency          ████████████░░░░░ 0.1200
  4. provider_quality_score   ██████████░░░░░░░ 0.1000
  5. network_status           █████████░░░░░░░░ 0.0900

RECOMMENDATIONS:
  → Upgrade to v1.3.0 for improved performance
  → Performance is improving - maintain current trajectory
```

---

## GCP Deployment

### Overview

Complete infrastructure migration from Azure ADLS to Google Cloud Platform:

- Cloud Storage for data layers (Bronze, Silver, Gold)
- BigQuery for analytics and ML
- Vertex AI for model training and serving
- Cloud Run for batch and real-time scoring
- Infrastructure as Code with Terraform

### Deployment Steps

See `gcp/README_GCP_SETUP.md` for detailed deployment instructions. Quick overview:

```bash
# 1. Set up GCP project
gcloud projects create bupa-insurance-prod
gcloud config set project bupa-insurance-prod
gcloud services enable storage.googleapis.com bigquery.googleapis.com aiplatform.googleapis.com

# 2. Deploy infrastructure with Terraform
cd gcp/terraform
terraform init
terraform plan -out=tfplan
terraform apply tfplan

# 3. Build and push Docker image
docker build -t gcr.io/bupa-insurance-prod/bupa-pipeline:latest gcp/docker
docker push gcr.io/bupa-insurance-prod/bupa-pipeline:latest

# 4. Deploy to Cloud Run
gcloud run deploy bupa-pipeline-service \
  --image=gcr.io/bupa-insurance-prod/bupa-pipeline:latest \
  --platform=managed \
  --region=us-central1

# 5. Migrate data from Azure
azcopy copy "https://bupaadls.blob.core.windows.net/bronze/*" \
  "gs://bupa-insurance-prod-bupa-bronze-prod/" \
  --recursive=true
```

### Infrastructure Components

```
GCP Project: bupa-insurance-prod
├── Cloud Storage (Data Layers)
│   ├── gs://bupa-insurance-prod-bupa-bronze-prod/
│   ├── gs://bupa-insurance-prod-bupa-silver-prod/
│   ├── gs://bupa-insurance-prod-bupa-gold-prod/
│   └── gs://bupa-insurance-prod-bupa-models-prod/
├── BigQuery (Analytics)
│   ├── bupa_bronze_prod
│   ├── bupa_silver_prod
│   ├── bupa_gold_prod
│   └── bupa_ml_prod
├── Vertex AI (ML)
│   ├── Notebooks for development
│   ├── Training pipelines
│   └── Model registry
└── Cloud Run (Serving)
    ├── Real-time scoring API
    ├── Batch scoring jobs
    └── Model retraining pipeline
```

### Estimated Costs

```
Monthly Cost Estimate (Production):
├── Cloud Storage:
│   ├── Data storage: $1,000/month (100GB)
│   ├── Data transfer: $500/month
│   └── Subtotal: $1,500
├── BigQuery:
│   ├── Queries: $2,000/month (500GB scanned)
│   ├── Storage: $300/month
│   └── Subtotal: $2,300
├── Vertex AI:
│   ├── Model training: $800/month
│   ├── Batch predictions: $600/month
│   └── Subtotal: $1,400
├── Cloud Run:
│   ├── Real-time scoring: $400/month
│   └── Subtotal: $400
└── Total: ~$5,600/month

Cost Optimization:
- Use preemptible instances: -30%
- Enable storage lifecycle: -20%
- Reserved slots (BigQuery): -25%
Total Potential Savings: -$1,400/month → $4,200/month
```

---

## Integration with Master Pipeline

### Master_Run_Pipeline.py Integration

```python
# master_run_pipeline.py
from tests.test_pipeline_e2e import PipelineE2ETest
from src.profiling import get_profiler
from src.dq_reporting import get_dq_checker
from scripts.model_evaluation import get_model_evaluator

def main():
    """Master pipeline orchestration"""
    
    # 1. Run pipeline
    logger.info("Starting production pipeline...")
    run_all_notebooks()
    
    # 2. Profile execution
    profiler = get_profiler()
    profile_report = profiler.get_layer_summary()
    logger.info(f"Pipeline completed in {profile_report['total_time']}s")
    
    # 3. Check data quality
    dq_checker = get_dq_checker()
    dq_report = dq_checker.generate_pipeline_report(TABLES_TO_CHECK)
    dq_checker.save_report(dq_report)
    
    if dq_report.pipeline_quality_score < 90:
        logger.error("DQ check failed - initiating rollback")
        raise RuntimeError("Data quality below threshold")
    
    # 4. Evaluate model
    evaluator = get_model_evaluator()
    eval_report = evaluator.generate_evaluation_report(
        current_prod_version=CURRENT_VERSION
    )
    evaluator.save_report(eval_report)
    
    if eval_report.performance_trend == "degrading":
        logger.warning("Model performance degrading - review needed")
    
    # 5. Run E2E tests
    tester = PipelineE2ETest()
    test_results = tester.run_all_tests()
    tester.save_results()
    
    if test_results.failed_count > 0:
        raise RuntimeError(f"{test_results.failed_count} tests failed")
    
    logger.info("✅ All Phase 4 validations passed")
    return True
```

---

## Monitoring & Alerting

### Cloud Monitoring Setup

```bash
# Create alert for high latency
gcloud monitoring policies create \
  --display-name="BUPA Pipeline High Latency" \
  --condition-display-name="Execution time > 300s" \
  --condition-threshold-filter='metric.type="custom.googleapis.com/bupa/execution_time"'

# Create alert for DQ degradation
gcloud monitoring policies create \
  --display-name="BUPA DQ Score Low" \
  --condition-display-name="Quality score < 90" \
  --condition-threshold-filter='metric.type="custom.googleapis.com/bupa/quality_score"'

# Create alert for model drift
gcloud monitoring policies create \
  --display-name="BUPA Model Drift Detected" \
  --condition-display-name="KL divergence > threshold"
```

### Logging Setup

```bash
# Stream logs to BigQuery
gcloud logging sinks create bupa-logs \
  bigquery.googleapis.com/projects/bupa-insurance-prod/datasets/bupa_ml_prod \
  --log-filter='resource.type="cloud_run_revision"'

# View real-time logs
gcloud logging read "resource.type=cloud_run_revision" \
  --limit=50 \
  --format=json \
  --freshness=10s
```

---

## Troubleshooting

### Common Issues and Solutions

#### 1. Test Failure: Notebook Execution Timeout

```bash
# Increase timeout
pytest tests/test_pipeline_e2e.py \
  --timeout=600 \
  --notebook="02_members_silver"

# Check notebook for infinite loops
jupyter nbconvert --to script 02_members_silver.ipynb
```

#### 2. DQ Check: High Null Rate

```python
# Investigate null columns
from src.dq_reporting import get_dq_checker
checker = get_dq_checker()
metrics = checker.check_table_quality("members")

for col in metrics.columns:
    if col['null_percent'] > 5:
        print(f"{col['column_name']}: {col['null_percent']}% nulls")
        # Drill down: SELECT * FROM members WHERE column IS NULL LIMIT 10
```

#### 3. Performance: Slow Bronze Load

```bash
# Profile bronze layer
python -c "
from src.profiling import get_profiler
p = get_profiler()
bronze_metrics = p.get_layer_summary('bronze')
print(f'Bronze time: {bronze_metrics[\"total_time\"]}s')
print(f'Slowest: {bronze_metrics[\"slowest_operation\"]}')
"

# Optimize:
# 1. Increase Spark parallelism: spark.conf.set('spark.sql.shuffle.partitions', '200')
# 2. Use Delta caching: delta_table.cache()
# 3. Parallelize multiple sources
```

---

## Success Metrics

Phase 4 is complete when:

- ✅ All 26 notebooks pass E2E tests
- ✅ Pipeline executes in < 4 hours (optimized)
- ✅ Data quality score > 95% across all layers
- ✅ Model performance trend is "improving"
- ✅ GCP infrastructure deployed and tested
- ✅ Monitoring and alerting configured
- ✅ Zero critical issues in production

---

## References

- [End-to-End Testing](tests/test_pipeline_e2e.py)
- [Performance Profiling](src/profiling.py)
- [Data Quality Reporting](src/dq_reporting.py)
- [Model Evaluation](scripts/model_evaluation.py)
- [GCP Setup Guide](gcp/README_GCP_SETUP.md)

---

**Document Version**: 1.0  
**Last Updated**: 2024  
**Maintained By**: Data Engineering Team
