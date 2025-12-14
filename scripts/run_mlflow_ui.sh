#!/bin/bash
PORT=${1:-5000}

mlflow ui \
  --backend-store-uri file:/Users/manojrammopati/Public/Projects/bupa_insurance_project/mlruns \
  --host 0.0.0.0 \
  --port $PORT