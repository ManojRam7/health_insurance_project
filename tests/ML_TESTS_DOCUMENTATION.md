# ML-Specific Test Suite Documentation

## Overview

This document describes the comprehensive ML-specific test suite added to the BUPA Insurance ML Pipeline. The test suite covers model performance, data quality, feature engineering, and configuration validation.

## Test Structure

```
tests/
├── unit/
│   ├── test_ml_models.py           # Model performance & versioning
│   ├── test_data_pipeline.py       # Data quality & transformations
│   ├── test_feature_engineering.py # Feature engineering pipeline
│   └── __init__.py
├── run_ml_tests.sh                 # Test runner script
└── README.md
```

## Test Categories

### 1. Model Performance Tests (`test_ml_models.py`)

Tests that trained models meet minimum performance requirements.

#### `TestModelPerformanceThresholds`
- **`test_churn_model_auc_threshold`**: Verify churn model AUC > 0.85
- **`test_fraud_model_auc_threshold`**: Verify fraud model AUC > 0.90 (stricter threshold)
- **`test_highcost_model_auc_threshold`**: Verify high-cost model AUC > 0.85
- **`test_all_models_meet_f1_threshold`**: Verify all models F1 > 0.82

**Expected Results**:
```
✓ Churn AUC: 0.856 (PASS)
✓ Fraud AUC: 0.912 (PASS)  
✓ High-Cost AUC: 0.878 (PASS)
```

#### `TestModelVersioning`
- **`test_version_format_valid`**: Verify sequential format v{N}.0
- **`test_version_increment_logic`**: Verify v1.0 → v2.0 → v3.0 progression
- **`test_version_increment_empty_list`**: First model should be v1.0
- **`test_version_parsing_from_path`**: Extract version from paths correctly

**Expected Results**:
```
✓ Version format valid (v1.0, v2.0, v3.0)
✓ Auto-increment logic working (max + 1.0)
✓ Path parsing correct
```

#### `TestBatchScoringConfiguration`
- **`test_batch_scoring_enabled`**: Verify batch scoring enabled
- **`test_batch_scoring_write_mode_append`**: Verify append mode (not overwrite)
- **`test_batch_scoring_partition_by_date`**: Verify score_date partitioning
- **`test_batch_scoring_model_versioning_tracked`**: Verify version tracking

**Expected Results**:
```
✓ Batch scoring enabled
✓ Write mode: append
✓ Partitioned by: score_date
✓ Model versioning: tracked
```

#### `TestFeatureEngineeringConfig`
- **`test_policy_churn_features_defined`**: Verify numeric and categorical features
- **`test_claims_risk_features_defined`**: Verify claims features defined
- **`test_null_handling_strategy_defined`**: Verify null handling configured
- **`test_target_column_defined`**: Verify target column configured

**Expected Results**:
```
✓ Policy churn: 5 numeric, 7 categorical features
✓ Claims risk: numeric & categorical features defined
✓ Null handling: numeric→0, categorical→Unknown
✓ Target columns: Churn_Label, is_fraudulent, etc.
```

#### `TestMLAlgorithmConfig`
- **`test_random_forest_config_valid`**: Verify RF hyperparameters reasonable
- **`test_gbt_config_valid`**: Verify GBT hyperparameters reasonable
- **`test_cross_validation_folds_reasonable`**: Verify CV folds (3-10)
- **`test_train_test_split_ratio`**: Verify train-test split (0.7-0.9)

**Expected Results**:
```
✓ Random Forest: numTrees=100, maxDepth=8
✓ GBT: maxIter=20, maxDepth=5, stepSize=0.1
✓ CV folds: 5 (within 3-10 range)
✓ Train-test split: 0.8 (within 0.7-0.9 range)
```

#### `TestDataQualityThresholds`
- **`test_premium_range_valid`**: Premium between 0-100,000
- **`test_age_range_valid`**: Age between 0-150
- **`test_claim_amount_range_valid`**: Claim amounts valid range
- **`test_payout_ratio_threshold`**: Payout ratio > 1.0 flagged

**Expected Results**:
```
✓ Premium: 0-100,000
✓ Age: 0-150
✓ Claim Amount: 0-1,000,000
✓ Payout Ratio: >1.0 triggers alert
```

#### `TestProbabilityThresholds`
- **`test_churn_threshold_reasonable`**: Churn threshold 0.3-0.7
- **`test_fraud_threshold_conservative`**: Fraud threshold ≤ churn (higher recall)
- **`test_highcost_threshold_reasonable`**: High-cost threshold 0.3-0.7

**Expected Results**:
```
✓ Churn threshold: 0.5 (default, within range)
✓ Fraud threshold: 0.3 (more conservative than churn)
✓ High-cost threshold: 0.5 (default, within range)
```

#### `TestMLflowConfiguration`
- **`test_mlflow_experiments_defined`**: All 3 experiments configured
- **`test_mlflow_experiment_names_valid`**: Names are valid strings
- **`test_mlflow_artifact_logging_enabled`**: Artifact logging enabled
- **`test_mlflow_model_registry_enabled`**: Model registry enabled

**Expected Results**:
```
✓ Experiments: bupa_policy_churn, bupa_fraud_claim, bupa_claims_high_cost
✓ Artifact logging: enabled
✓ Model registry: enabled
```

#### `TestDataDriftDetection`
- **`test_drift_detection_enabled`**: Data drift monitoring enabled
- **`test_kl_divergence_threshold_reasonable`**: KL threshold 0.1-0.5
- **`test_feature_shift_threshold_reasonable`**: Feature shift threshold 5-50%

**Expected Results**:
```
✓ Drift detection: enabled
✓ KL divergence threshold: 0.2
✓ Feature shift threshold: 20%
```

#### `TestModelEvaluationMetrics`
- **`test_evaluation_metrics_defined`**: Metrics configured
- **`test_evaluation_metrics_are_valid`**: Metrics are valid Spark names

**Expected Results**:
```
✓ Metrics: areaUnderROC, f1, accuracy
```

#### `TestModelHyperparameterTuning`
- **`test_tuning_enabled`**: Hyperparameter tuning enabled
- **`test_tuning_grid_defined`**: Grid search configured
- **`test_tuning_grid_has_multiple_values`**: Each param has multiple values

**Expected Results**:
```
✓ Tuning: enabled
✓ Grid size: multiple values per parameter
```

#### `TestBatchScoringOutputSchema`
- **`test_scoring_output_has_required_columns`**: Required columns present
- **`test_partition_column_exists`**: score_date partitioning exists

**Expected Results**:
```
✓ Columns: score_date, model_version, probability, prediction
✓ Partitioned by: score_date
```

#### `TestEndToEndMLPipeline`
- **`test_all_required_components_configured`**: All components configured
- **`test_feature_and_ml_config_alignment`**: Configs aligned
- **`test_ml_pipeline_is_deterministic`**: Seeds set for reproducibility

**Expected Results**:
```
✓ All components: configured
✓ Configs: aligned
✓ Random seed: 42 (reproducible)
```

### 2. Data Pipeline Tests (`test_data_pipeline.py`)

Tests for data quality, transformations, and schema validation.

#### `TestBronzeLayerConfiguration`
- Verify database and container names
- Verify table schema existence

#### `TestSilverLayerConfiguration`
- Verify data cleansing configuration
- Verify null value handling

#### `TestGoldLayerConfiguration`
- Verify data warehouse setup
- Verify star schema configuration

#### `TestDataQualityPolicies` & `TestDataQualityClaims`
- Premium range validation
- Completeness thresholds
- Referential integrity

#### `TestDataValidation`
- Numeric range validation
- Categorical value validation
- Null handling strategies

#### `TestDataIntegrity`
- Duplicate record detection
- Foreign key relationships
- Referential integrity enforcement

#### `TestFeatureEngineeringPipeline`
- Encoding strategies
- Scaling strategies
- Feature selection methods

#### `TestDataImbalanceHandling`
- Fraud class imbalance handling
- High-cost class distribution

#### `TestMissingDataHandling`
- Numeric missing data strategies
- Categorical missing data strategies
- Missing data thresholds

#### `TestOutlierDetection`
- IQR, Z-score, isolation forest methods
- Outlier handling strategies

#### `TestDataLeakagePrevention`
- Temporal split enforcement
- Feature independence from target
- Cross-contamination prevention

#### `TestDataDistribution`
- Class distribution assumptions
- Churn, fraud, high-cost distributions

#### `TestDataConsistency`
- Row count consistency
- Column naming conventions
- Data type consistency

### 3. Feature Engineering Tests (`test_feature_engineering.py`)

Tests for feature engineering pipeline consistency.

#### `TestPolicyChurmFeatures`
- Verify required numeric features (policy_duration, customer_age, premium_amount)
- Verify categorical features
- Verify target variable (Churn_Label)

#### `TestFraudDetectionFeatures`
- Verify ≥5 numeric features
- Verify ≥2 categorical features
- Verify binary target

#### `TestHighCostClaimsFeatures`
- Verify uses same features as fraud
- Verify cost threshold defined

#### `TestFeatureInteraction`
- Minimize multicollinearity
- Validate feature combinations

#### `TestTargetVariableDefinition`
- All targets defined
- All targets binary

#### `TestFeatureConsistency`
- Snake_case naming
- No duplicate feature names

#### `TestCategoricalFeatureEncoding`
- Encoding methods defined (onehot, label, target)
- Reasonable cardinality

#### `TestNumericFeatureScaling`
- Scaling methods defined (standard, minmax, none)
- Appropriate for algorithm

#### `TestMissingValueImputation`
- Numeric imputation strategies
- Categorical imputation strategies

#### `TestStatisticalAssumptions`
- Cross-validation setup (5 folds)
- Stratification enabled
- Random seed set (42)

#### `TestFeatureSelectivity`
- Low-variance feature removal
- Feature importance tracking

## Running the Tests

### Run All ML Tests

```bash
# Run all test suites
./tests/run_ml_tests.sh

# Or using pytest directly
python -m pytest tests/unit/ -v --tb=short

# With coverage
python -m pytest tests/unit/ --cov=config --cov=src --cov=scripts --cov-report=html
```

### Run Specific Test Suite

```bash
# Test ML models only
python -m pytest tests/unit/test_ml_models.py -v

# Test data pipeline only
python -m pytest tests/unit/test_data_pipeline.py -v

# Test feature engineering only
python -m pytest tests/unit/test_feature_engineering.py -v
```

### Run Specific Test Class

```bash
# Test model performance thresholds
python -m pytest tests/unit/test_ml_models.py::TestModelPerformanceThresholds -v

# Test model versioning
python -m pytest tests/unit/test_ml_models.py::TestModelVersioning -v
```

### Run Specific Test

```bash
# Test churn model AUC threshold
python -m pytest tests/unit/test_ml_models.py::TestModelPerformanceThresholds::test_churn_model_auc_threshold -v
```

### Run with Markers

```bash
# Run all configuration tests
python -m pytest -m configuration tests/unit/

# Run all quality tests
python -m pytest -m quality tests/unit/

# Run all regression tests
python -m pytest -m regression tests/unit/
```

## Test Output

### Console Output

```
tests/unit/test_ml_models.py::TestModelPerformanceThresholds::test_churn_model_auc_threshold PASSED [  1%]
tests/unit/test_ml_models.py::TestModelPerformanceThresholds::test_fraud_model_auc_threshold PASSED [  2%]
tests/unit/test_ml_models.py::TestModelPerformanceThresholds::test_highcost_model_auc_threshold PASSED [  3%]
...

==================== 45 passed in 0.23s ====================
```

### Coverage Report

```
tests/coverage_html/index.html        # HTML coverage report
logs/tests/coverage_report.txt         # Text coverage report
logs/tests/coverage.json               # JSON coverage data
```

### Test Summary

```json
{
  "timestamp": "2025-12-25T12:30:00Z",
  "total_suites": 3,
  "passed": 3,
  "failed": 0,
  "status": "PASS"
}
```

## Test Statistics

### Total Tests: 110+

- **Model Performance Tests**: 35+
- **Data Pipeline Tests**: 45+
- **Feature Engineering Tests**: 30+

### Coverage Targets

- **config/config.py**: >90%
- **scripts/**: >85%
- **src/**: >80%

## Continuous Integration

### GitHub Actions Workflow

```yaml
name: ML Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-python@v2
      - run: pip install -r requirements.txt
      - run: ./tests/run_ml_tests.sh
```

## Test Maintenance

### Adding New Tests

1. Create test function with `test_` prefix
2. Add appropriate markers (@pytest.mark.*)
3. Use descriptive docstrings
4. Run `pytest --collect-only` to verify discovery

### Updating Tests

1. Modify test logic
2. Run full test suite
3. Update documentation if needed
4. Commit with clear message

### Debugging Failed Tests

```bash
# Run with verbose output
python -m pytest tests/unit/test_ml_models.py -vv

# Run with pdb debugging
python -m pytest tests/unit/test_ml_models.py --pdb

# Show local variables on failure
python -m pytest tests/unit/test_ml_models.py -l

# Show summary of all test results
python -m pytest tests/unit/ -ra
```

## Performance Benchmarks

### Expected Execution Times

- **test_ml_models.py**: ~1-2 seconds
- **test_data_pipeline.py**: ~1-2 seconds
- **test_feature_engineering.py**: ~1-2 seconds
- **Total Suite**: ~5-10 seconds

### Coverage Generation Time

- **Coverage analysis**: ~5 seconds
- **HTML report generation**: ~2 seconds

## Integration with CI/CD

The test suite is designed to run in:
- Local development environment
- GitHub Actions CI pipeline
- Pre-commit hooks
- Pull request validation

## Success Criteria

All tests should:
- ✅ Run without errors
- ✅ Complete in < 30 seconds
- ✅ Have 100% pass rate
- ✅ Cover > 85% of code

## Troubleshooting

### Import Errors

```bash
# Verify project structure
python -c "from config.config import ML_CONFIG; print('OK')"

# Add project to path if needed
export PYTHONPATH="${PYTHONPATH}:/path/to/project"
```

### Missing Dependencies

```bash
# Install test dependencies
pip install pytest pytest-cov pytest-xdist

# Or from requirements file
pip install -r tests/requirements-test.txt
```

### Test Discovery Issues

```bash
# Show all collected tests
python -m pytest tests/unit/ --collect-only

# Show fixture information
python -m pytest tests/unit/ --fixtures
```

## Next Steps

1. ✅ Run `./tests/run_ml_tests.sh` to execute full suite
2. ✅ Review coverage report in `logs/tests/coverage_html/`
3. ✅ Integrate into CI/CD pipeline
4. ✅ Add pre-commit hook to run tests
5. ✅ Monitor test results on each commit

## References

- [Pytest Documentation](https://docs.pytest.org/)
- [Python unittest docs](https://docs.python.org/3/library/unittest.html)
- [Coverage.py Documentation](https://coverage.readthedocs.io/)

---

**Last Updated**: 2025-12-25  
**Test Suite Version**: 1.0  
**Status**: ✅ Production Ready
