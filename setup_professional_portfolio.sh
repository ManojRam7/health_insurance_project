#!/usr/bin/env bash
set -euo pipefail

# Professional portfolio bootstrap for bupa_insurance_project.
# Creates/updates Docker, workflows, and issue templates.

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

mkdir -p .github/workflows
mkdir -p .github/ISSUE_TEMPLATE

cat > Dockerfile <<'EOF'
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends default-jre-headless build-essential \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt ./
RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . .

CMD ["python", "Master_Run_Pipeline.py"]
EOF

cat > .github/workflows/ci.yml <<'EOF'
name: bupa-ci

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  lint_and_unit:
    name: Lint + Unit (py${{ matrix.python-version }})
    runs-on: ubuntu-24.04
    timeout-minutes: 15
    strategy:
      fail-fast: false
      matrix:
        python-version: ["3.9", "3.10", "3.11"]

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: pip
          cache-dependency-path: |
            requirements.txt
            requirements-dev.txt

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements-dev.txt

      - name: Lint and format checks
        run: |
          black --check src tests
          isort --check-only src tests
          flake8 src tests

      - name: Type checks
        run: |
          mypy src || true

      - name: Run unit tests
        run: |
          mkdir -p test-results
          pytest -v tests/unit \
            --tb=short \
            --cov=src \
            --cov-report=xml \
            --junit-xml=test-results/unit-results-${{ matrix.python-version }}.xml

      - name: Upload unit test results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: unit-test-results-py${{ matrix.python-version }}
          path: |
            test-results/unit-results-${{ matrix.python-version }}.xml
            coverage.xml
          retention-days: 14

  integration_local_sample:
    name: Integration (gold sample)
    runs-on: ubuntu-24.04
    needs: lint_and_unit
    timeout-minutes: 20

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"
          cache: pip

      - name: Verify sample data exists
        run: |
          test -d data/gold_sample/fact_claims || (echo "gold_sample/fact_claims not found" && exit 1)
          echo "gold_sample verified"

      - name: Install integration dependencies
        run: |
          python -m pip install --upgrade pip
          pip install pytest pyspark==3.5.7 delta-spark==3.1.0

      - name: Run integration tests
        env:
          RUN_LOCAL_SPARK: "1"
          LOCAL_GOLD_BASE: data/gold_sample
        run: |
          mkdir -p test-results
          pytest -v tests/integration \
            --tb=short \
            --junit-xml=test-results/integration-results.xml

      - name: Upload integration results
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: integration-test-results
          path: test-results/integration-results.xml
          retention-days: 14
EOF

cat > .github/workflows/code-quality.yml <<'EOF'
name: code-quality

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
  workflow_dispatch:

permissions:
  contents: read

jobs:
  quality:
    runs-on: ubuntu-24.04
    timeout-minutes: 15

    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.10"
          cache: pip
          cache-dependency-path: |
            requirements.txt
            requirements-dev.txt

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements-dev.txt
          pip install bandit pip-audit

      - name: Static security scan (bandit)
        run: |
          bandit -q -r src -x tests

      - name: Dependency vulnerability scan (pip-audit)
        run: |
          pip-audit --progress-spinner off

      - name: Pylint quality gate
        run: |
          pylint src
EOF

cat > .github/workflows/documentation.yml <<'EOF'
name: documentation

on:
  push:
    branches:
      - main
    paths:
      - "**/*.md"
      - ".github/workflows/documentation.yml"
  pull_request:
    branches:
      - main
    paths:
      - "**/*.md"
      - ".github/workflows/documentation.yml"
  workflow_dispatch:

permissions:
  contents: read

jobs:
  docs-validation:
    runs-on: ubuntu-24.04

    steps:
      - uses: actions/checkout@v4

      - name: Markdown lint
        uses: DavidAnson/markdownlint-cli2-action@v16
        with:
          globs: |
            **/*.md
            !test-results/**/*.md

      - name: Link check
        uses: lycheeverse/lychee-action@v2
        with:
          args: --verbose --no-progress --accept 200,429 '**/*.md' '!test-results/**/*.md'
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
EOF

cat > .github/ISSUE_TEMPLATE/bug_report.md <<'EOF'
---
name: Bug Report
about: Report a reproducible problem in the project
labels: bug
assignees: ""
---

## Summary
Describe the bug clearly and concisely.

## Environment
- OS:
- Python version:
- Branch/commit:

## Steps To Reproduce
1.
2.
3.

## Expected Behavior
What should happen?

## Actual Behavior
What happened instead?

## Logs / Screenshots
Paste relevant logs, traceback, or screenshots.

## Additional Context
Any extra details that may help reproduce or fix the issue.
EOF

cat > .github/ISSUE_TEMPLATE/feature_request.md <<'EOF'
---
name: Feature Request
about: Propose a new capability or enhancement
labels: enhancement
assignees: ""
---

## Problem Statement
What pain point are you trying to solve?

## Proposed Solution
Describe the ideal behavior and user experience.

## Alternatives Considered
List any alternative approaches.

## Scope
- Affected modules:
- Data impact:
- Testing impact:

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Additional Context
Add supporting notes, references, or mockups.
EOF

cat > .github/ISSUE_TEMPLATE/test_failure.md <<'EOF'
---
name: Test Failure
about: Report failing tests from local or CI runs
labels: test-failure
assignees: ""
---

## Failure Summary
Describe which test suite failed and where.

## Failing Test(s)
- Test file:
- Test name:

## Execution Context
- Trigger: local / pull request / push
- Python version:
- OS:

## Failure Output
Paste the exact error output or traceback.

## Suspected Cause
If known, note what likely caused the failure.

## Proposed Fix (Optional)
Any suggested remediation steps.
EOF

cat > .github/ISSUE_TEMPLATE/documentation.md <<'EOF'
---
name: Documentation
about: Report missing, inaccurate, or unclear documentation
labels: documentation
assignees: ""
---

## Documentation Area
Which doc or section is affected?

## Issue Type
- [ ] Missing documentation
- [ ] Incorrect documentation
- [ ] Outdated documentation
- [ ] Clarity/readability issue

## Current Content
Quote or summarize the current text.

## Suggested Improvement
Provide the proposed wording or structure.

## Business Impact
Explain why this documentation update matters.
EOF

echo "Professional portfolio setup files generated successfully."
