# Changelog

All notable changes to the BUPA Insurance ML Pipeline project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Professional Portfolio Automation Assets**
  - Added `.github/ISSUE_TEMPLATE/bug_report.md`
  - Added `.github/ISSUE_TEMPLATE/feature_request.md`
  - Added `.github/ISSUE_TEMPLATE/test_failure.md`
  - Added `.github/ISSUE_TEMPLATE/documentation.md`
  - Added `.github/workflows/code-quality.yml`
  - Added `.github/workflows/documentation.yml`
  - Added root `Dockerfile`

### Changed
- Expanded `.github/workflows/ci.yml` to run lint + unit tests on Python 3.9, 3.10, and 3.11
- Updated `README.md` with GitHub badges and Docker quick-start section

## [1.0.0] - 2026-06-20

### Added
- **Professional Portfolio Optimization**
  - Added comprehensive requirements.txt with all ML dependencies
  - Created pyproject.toml for modern Python packaging
  - Added LICENSE (MIT)
  - Created CONTRIBUTING.md with collaboration guidelines
  - Added .editorconfig for consistent code formatting
  - Created .pre-commit-config.yaml for automated code quality checks
  - Added Makefile with common development commands
  - Created Dockerfile for reproducible environments
  - Added GitHub Actions workflows for CI/CD
  - Added GitHub issue templates
  - Updated README with badges and comprehensive documentation

- **CI/CD Pipeline**
  - GitHub Actions workflow for automated testing on push/PR
  - Code quality checks (black, flake8, pylint, mypy)
  - Test coverage reporting
  - Python 3.9, 3.10, 3.11 compatibility testing
  - Docker image building validation
  - Code security scanning with bandit
  - Dependency vulnerability checks with safety

- **Code Quality Tools**
  - Black for code formatting (line length: 100)
  - isort for import sorting
  - flake8 for linting
  - pylint for advanced linting
  - mypy for type checking
  - pytest for testing with coverage
  - Pre-commit hooks for automated checks

- **Development Documentation**
  - CONTRIBUTING.md with code style guidelines
  - Makefile with documented commands
  - .editorconfig for IDE consistency
  - .pre-commit-config.yaml for automated quality gates
  - Issue templates (bug report, feature request, test failure, documentation)

- **Docker Support**
  - Dockerfile for containerized environment
  - Python 3.9 slim base image for minimal footprint
  - Complete ML stack included
  - Pre-configured entry point for pipeline execution

- **GitHub Workflows**
  - `ci.yml` - Main CI pipeline with:
    - Multi-version Python testing (3.9, 3.10, 3.11)
    - Code linting and formatting checks
    - Type checking with mypy
    - pytest with coverage reporting
    - Codecov integration
    - Docker build caching
  - `code-quality.yml` - Additional quality checks:
    - Security scanning with bandit
    - Dependency vulnerability checks
    - Code quality metrics
  - `documentation.yml` - Documentation validation

### Changed
- Updated .gitignore with improved organization and comments
- Enhanced requirements.txt with version specifications
- requirements-dev.txt now includes all development dependencies
- README.md with professional badges and comprehensive structure

### Fixed
- Removed duplicate entries in .gitignore
- Organized dependencies by category for clarity

### Security
- Added .env handling in .gitignore
- Added secrets/ and credentials/ to .gitignore
- Added detection of private keys in pre-commit hooks
- Security scanning in CI/CD pipeline
- Dependency vulnerability checks

## [0.9.0] - 2026-01-19

### Added
- Initial enterprise-ready ML pipeline
- Multi-stage data processing (Bronze, Silver, Gold)
- ML model training and evaluation
- 127 unit tests with 100% pass rate
- Comprehensive project documentation
- Production monitoring setup

### Features
- Data Quality: 98.3/100 score
- Pipeline Speed: ~15 minutes end-to-end
- Model Performance: AUC 0.856-0.912
- Test Coverage: 127 tests

---

## Versioning

This project follows [Semantic Versioning](https://semver.org/):
- **MAJOR** version for incompatible API changes
- **MINOR** version for backwards-compatible functionality additions
- **PATCH** version for backwards-compatible bug fixes

## Release Process

1. Update version numbers in:
   - pyproject.toml
   - This CHANGELOG.md file
2. Create a git tag: `git tag v1.0.0`
3. Push changes and tags: `git push origin main --tags`
4. Create release notes on GitHub

## Future Roadmap

- [ ] MLflow integration for experiment tracking
- [ ] Advanced monitoring and alerting
- [ ] GCP deployment automation
- [ ] API endpoint for model serving
- [ ] Real-time predictions support
- [ ] Kubernetes deployment manifests
- [ ] Advanced data validation with Great Expectations
