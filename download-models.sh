#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/models"

# Format: "<url> <expected_size_bytes>"
# Recommended models for a laptop with ~16GB of free RAM (Ryzen 5500U / Radeon Vega iGPU).
FILES=(
  "https://huggingface.co/Qwen/Qwen2.5-Coder-7B-Instruct-GGUF/resolve/main/qwen2.5-coder-7b-instruct-q4_k_m.gguf 4683073536"
  "https://huggingface.co/Qwen/Qwen3-8B-GGUF/resolve/main/Qwen3-8B-Q4_K_M.gguf 5027783488"
  "https://huggingface.co/Qwen/Qwen2.5-Coder-1.5B-Instruct-GGUF/resolve/main/qwen2.5-coder-1.5b-instruct-q4_k_m.gguf 1117320768"
)

for entry in "${FILES[@]}"; do
  url="${entry%% *}"
  expected="${entry##* }"
  file="${url##*/}"

  if [ -f "$file" ]; then
    actual=$(stat -c%s "$file")
    if [ "$actual" -eq "$expected" ]; then
      echo "==> $file OK (already downloaded)"
      continue
    else
      echo "==> $file incomplete ($actual/$expected bytes), resuming..."
    fi
  fi

  curl -L -C - --retry 3 --retry-all-errors --fail \
    --progress-bar "$url" -o "$file"

  actual=$(stat -c%s "$file")
  if [ "$actual" -eq "$expected" ]; then
    echo "    OK ($actual bytes)"
  else
    echo "    WARNING: size mismatch. Expected $expected, got $actual bytes." >&2
  fi
done

echo "Done."