# BUPA Insurance ML Pipeline - Project Overview

This document is the end-to-end operational overview of the BUPA Insurance ML platform. It explains what the system does, how data moves through each layer, how models are trained/scored, and how to run and operate the project.

**Last Updated**: June 20, 2026  
**Project Status**: Production Ready (Curated Documentation Baseline)  
**Repository**: bupa_insurance_project

---

## 1. Executive Summary

The project implements a medallion architecture (Bronze, Silver, Gold) with integrated machine learning for healthcare insurance analytics.

Primary outcomes:

1. Policy churn prediction for retention targeting
2. Fraud risk prediction for investigation prioritization
3. High-cost claim prediction for proactive intervention

Current high-level metrics (documented baseline):

- Data volume: 62,000+ records processed
- Pipeline runtime: approximately 15 minutes end-to-end
- Model performance: AUC range 0.856 to 0.912
- Test baseline: 120+ to 127 test coverage references across project docs

---

## 2. Business Scope

### 2.1 Problems Solved

- Customer churn risk identification
- Suspicious claim detection support
- Large-claim early risk flagging
- Gold-layer business marts for downstream analytics

### 2.2 Users

- Data engineering teams operating data layers
- Data science teams training and validating models
- Risk, operations, and business analytics stakeholders consuming scores and marts

---

## 3. End-to-End Architecture

The platform is organized into sequential layers:

1. Ingestion and raw persistence
2. Cleansing and standardization
3. Business modeling and feature preparation
4. ML training and evaluation
5. Batch scoring and monitoring outputs

### 3.1 Layer Responsibilities

#### Bronze

- Raw data ingestion
- Source-accurate storage and schema continuity

#### Silver

- Data validation and cleaning
- Null handling, deduplication, and domain checks
- Standardized tables for feature engineering

#### Gold

- Fact and dimension tables
- Data marts and star-schema outputs
- ML-ready feature sets

#### ML and Scoring

- Train model families for churn and claims risk
- Evaluate and retain best models under configured rules
- Score incoming populations in batch workflows

#### Monitoring

- Data quality reporting
- Performance profiling
- Model evaluation artifacts

---

## 4. Pipeline Flow

```text
Source Data
  -> Bronze (raw)
  -> Silver (clean, validated)
  -> Gold (facts/dimensions/marts)
  -> ML features
  -> Model training/evaluation
  -> Batch scoring outputs
  -> Monitoring and run artifacts
```

Primary orchestrator:

- Master_Run_Pipeline.py

Key support modules:

- config/config.py
- src/dq_reporting.py
- src/profiling.py

---

## 5. Machine Learning Overview

### 5.1 Model Domains

1. Policy churn prediction
2. Fraudulent claim prediction
3. High-cost claim prediction

### 5.2 Typical Modeling Steps

1. Build train/test feature sets from Gold and Silver entities
2. Apply categorical/numerical preprocessing
3. Train configured estimators
4. Evaluate with AUC/F1 and related quality metrics
5. Persist model outputs and scoring results

### 5.3 Operational ML Notes

- Batch scoring is the primary serving mode
- Version-aware outputs are preserved for traceability
- Drift/performance monitoring hooks are available in project documentation and scripts

---

## 6. Repository Structure

```text
bupa_insurance_project/
  README.md
  Master_Run_Pipeline.py
  config/
  src/
  tests/
  _00_Pre_Pilot/
  _01_Bronze/
  _02_Silver/
  _03_Gold/
  Project_Documentation/
  .github/workflows/
```

---

## 7. Runbook

### 7.1 Local Environment Setup

```bash
python -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements-dev.txt
```

### 7.2 Run Full Pipeline

```bash
python Master_Run_Pipeline.py
```

### 7.3 Run Tests

```bash
pytest tests/
```

### 7.4 Docker Execution

```bash
docker build -t bupa-insurance-ml .
docker run --rm bupa-insurance-ml
```

---

## 8. CI/CD and Governance

The repository includes GitHub workflows for:

- CI validation and tests
- Code quality/security checks
- Documentation/link validation

Workflow files:

- .github/workflows/ci.yml
- .github/workflows/code-quality.yml
- .github/workflows/documentation.yml

Issue workflows are standardized through templates in:

- .github/ISSUE_TEMPLATE/

---

## 9. Documentation Canon

This repository intentionally uses a curated documentation model.

Read in order:

1. README.md
2. Project_Documentation/PROJECT_OVERVIEW.md
3. QUICK_REFERENCE.md
4. Project_Documentation/Architecture/ARCHITECTURE.md
5. Project_Documentation/Phase_4_Documentation/README_PRODUCTION.md
6. Project_Documentation/ML_TESTS_SUMMARY/ML_TESTS_QUICK_REFERENCE.md
7. _03_Gold/Gold_layer_documentation.md
8. DEPLOYMENT_ROADMAP.md

Rule:

- Add documentation only when it does not duplicate existing coverage in the canon above.

---

## 10. Operational Risks and Next Milestones

### 10.1 Known Focus Areas

- Notebook-to-managed-orchestration evolution
- Automated retraining triggers and lifecycle hardening
- Real-time serving layer for low-latency use cases
- Multi-region and resiliency extensions

### 10.2 Recommended Next Milestones

1. Formalize orchestration DAGs and scheduling policy
2. Standardize model promotion and rollback process
3. Add production SLO/SLA runbook checkpoints
4. Expand reliability testing under production-like loads

---

## 11. Ownership and Support

- Use issue templates in .github/ISSUE_TEMPLATE/ for bugs, features, test failures, and docs updates
- Follow CONTRIBUTING.md for collaboration and quality expectations

---

This overview is intentionally concise and operational. For implementation-level detail, use the architecture and production docs listed in Section 9.
