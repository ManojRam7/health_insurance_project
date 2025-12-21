#!/bin/bash
# Fix protobuf compatibility issues before running pipeline
# This resolves "libprotobuf.31.dylib" not found errors in MLflow

echo "🔧 Fixing protobuf compatibility..."

# Reinstall protobuf to fix binary compatibility
pip install --quiet --force-reinstall --no-cache-dir protobuf 2>/dev/null

# If that doesn't work, try the specific version
if ! python -c "import google.protobuf" 2>/dev/null; then
    echo "   Installing protobuf 4.24.4 (stable version)..."
    pip install --quiet --force-reinstall "protobuf==4.24.4" 2>/dev/null
fi

# Verify protobuf works
if python -c "import google.protobuf; print(f'✅ Protobuf {google.protobuf.__version__} loaded')" 2>/dev/null; then
    echo "✅ Protobuf fixed successfully"
    exit 0
else
    echo "⚠️  Could not fully fix protobuf - continuing anyway"
    exit 0
fi
