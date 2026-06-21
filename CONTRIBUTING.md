# Contributing to Health Insurance ML Pipeline

Thank you for your interest in contributing! This document provides guidelines and instructions for contributing to the project.

## 📋 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on code, not the person

## 🔄 How to Contribute

### 1. Fork & Clone
```bash
git clone https://github.com/ManojRam7/health_insurance_project.git
cd health_insurance_project
```

### 2. Set Up Development Environment
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements-dev.txt
```

### 3. Create a Feature Branch
```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/issue-name
```

### 4. Make Changes
- Follow PEP 8 style guidelines
- Add type hints where applicable
- Write clear commit messages
- Update documentation as needed

### 5. Run Tests & Quality Checks
```bash
# Format code
black src/ tests/
isort src/ tests/

# Lint
flake8 src/ tests/
pylint src/

# Type checking
mypy src/

# Run tests
pytest tests/ -v --cov=src
```

### 6. Commit & Push
```bash
git add .
git commit -m "feat: Add new feature" # Use conventional commits
git push origin feature/your-feature-name
```

### 7. Create Pull Request
- Use a descriptive title
- Reference any related issues
- Describe changes and testing done
- Ensure all checks pass

## 📝 Commit Message Guidelines

Use conventional commits format:
- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, missing semicolons, etc.)
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `test:` - Test additions/updates
- `chore:` - Build process, dependencies

Example:
```
feat: Add cross-validation to model training pipeline

- Implemented k-fold cross-validation
- Added performance metrics logging
- Updated documentation
```

## 🧪 Testing Requirements

- Write tests for new features
- Maintain or improve code coverage
- All tests must pass: `pytest tests/ -v`
- Minimum coverage: 80%

## 📚 Documentation

- Update README.md if adding features
- Add docstrings to functions/classes
- Update relevant documentation files
- Include examples where appropriate

## 🐛 Reporting Issues

Create an issue with:
1. **Description** - What's the problem?
2. **Steps to Reproduce** - How can others reproduce it?
3. **Expected Behavior** - What should happen?
4. **Actual Behavior** - What actually happens?
5. **Environment** - Python version, OS, dependencies

## 📦 Project Structure

```
health_insurance_project/
├── src/                    # Source code
├── tests/                  # Test suite
├── notebooks/              # Jupyter notebooks
├── data/                   # Data files (not tracked)
├── config/                 # Configuration files
├── scripts/                # Utility scripts
├── docs/                   # Documentation
└── Project_Documentation/  # Project guides
```

## 🚀 Code Style

### Python Style Guide
- Follow PEP 8
- Use 4 spaces for indentation
- Maximum line length: 100 characters
- Use type hints in new code

### Example:
```python
def calculate_metrics(
    predictions: np.ndarray,
    actuals: np.ndarray,
    threshold: float = 0.5
) -> Dict[str, float]:
    """
    Calculate classification metrics.
    
    Args:
        predictions: Model predictions
        actuals: Ground truth values
        threshold: Classification threshold
        
    Returns:
        Dictionary of metrics
    """
    # Implementation here
    pass
```

## 🔍 Review Process

1. **Automated Checks** - All CI/CD must pass
2. **Code Review** - At least one approval required
3. **Testing** - Coverage maintained or improved
4. **Documentation** - Updated if needed
5. **Merge** - Squash & merge into main

## ✅ Checklist Before Submitting PR

- [ ] Code follows style guidelines
- [ ] All tests pass locally
- [ ] New tests added for new features
- [ ] Documentation updated
- [ ] No new warnings introduced
- [ ] Commit messages are clear
- [ ] No large files added (< 50MB)
- [ ] Branch is up to date with main

## 📞 Questions?

- Check existing issues/discussions
- Review documentation
- Open a discussion for questions
- Be respectful and patient

Thank you for contributing! 🎉
