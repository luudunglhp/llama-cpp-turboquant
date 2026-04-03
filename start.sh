#!/usr/bin/env bash
set -euo pipefail

MODEL_SOURCE="${MODEL_SOURCE:-hf}"   # hf | file
HF_REPO="${HF_REPO:-ggml-org/gemma-3-1b-it-GGUF:Q4_K_M}"
MODEL_FILE="${MODEL_FILE:-/models/model.gguf}"

HOST="${HOST:-0.0.0.0}"
PORT="${PORT:-8080}"

CTX_SIZE="${CTX_SIZE:-4096}"
THREADS="${THREADS:-6}"
THREADS_BATCH="${THREADS_BATCH:-8}"
THREADS_HTTP="${THREADS_HTTP:-2}"
BATCH_SIZE="${BATCH_SIZE:-256}"
UBATCH_SIZE="${UBATCH_SIZE:-128}"
PARALLEL="${PARALLEL:-1}"

CACHE_TYPE_K="${CACHE_TYPE_K:-tq3_0}"
CACHE_TYPE_V="${CACHE_TYPE_V:-tq3_0}"

MLOCK="${MLOCK:-0}"
EXTRA_ARGS="${EXTRA_ARGS:---jinja}"

cd /app/llama-turboquant

ARGS=(
  --host "$HOST"
  --port "$PORT"
  --ctx-size "$CTX_SIZE"
  --threads "$THREADS"
  --threads-batch "$THREADS_BATCH"
  --threads-http "$THREADS_HTTP"
  --batch-size "$BATCH_SIZE"
  --ubatch-size "$UBATCH_SIZE"
  --parallel "$PARALLEL"
  --cache-type-k "$CACHE_TYPE_K"
  --cache-type-v "$CACHE_TYPE_V"
)

if [ "$MLOCK" = "1" ]; then
  ARGS+=(--mlock)
fi

if [ "$MODEL_SOURCE" = "hf" ]; then
  exec ./build/bin/llama-server \
    "${ARGS[@]}" \
    --hf-repo "$HF_REPO" \
    $EXTRA_ARGS
else
  exec ./build/bin/llama-server \
    "${ARGS[@]}" \
    --model "$MODEL_FILE" \
    $EXTRA_ARGS
fi
