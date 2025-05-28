#!/usr/bin/env bash
set -euo pipefail

SCRIPT_INVOKED_NAME=$(basename "$0")

MODEL_NAME=""

if [[ "$SCRIPT_INVOKED_NAME" == "run.sh" ]]; then
    MODEL_NAME="meta-llama/Llama-2-7b-chat-hf"
elif [[ "$SCRIPT_INVOKED_NAME" == "run-smaller.sh" ]]; then
    MODEL_NAME="TheBloke/Llama-2-7B-Chat-AWQ"
else
    # Fallback or error if invoked by an unexpected name
    echo "Error: Script was invoked by an unexpected name: '$SCRIPT_INVOKED_NAME'" >&2
    exit 1
fi


if huggingface-cli whoami 2>&1 | grep -q "Not logged in"; then
    echo "Error: No active Hugging Face login detected."
    echo "Ready your credential from huggingface.co"
    echo "Make sure the account has access to: $MODEL_NAME"
    echo "Run: huggingface-cli login"
    exit 1
fi


LOG_FILE="server.log"
#TIMEOUT=300

#Start vLLM server in background, log stdout/stderr
vllm serve "$MODEL_NAME" --chat-template ./llama2_template.jinja &> "$LOG_FILE" &
VLLM_PID=$!

echo "Starting vLLM server (PID $VLLM_PID). This may require downloading the model and could take a while.  logged to $LOG_FILE..."

# Clean up background vLLM server on exit or interrupt
cleanup() {
    echo "Shutting down vLLM server (PID $VLLM_PID)..."
    kill "$VLLM_PID" 2>/dev/null || true
    wait "$VLLM_PID" 2>/dev/null || true
}
trap cleanup EXIT INT TERM

#START_TIME=$(date +%s)
SUCCESS_KEYWORDS=("Application startup complete" "Uvicorn running")
SERVER_READY=0

while true; do
    sleep 1
    if ! kill -0 "$VLLM_PID" 2>/dev/null; then
        echo "vLLM server process exited unexpectedly. Log output:"
        cat "$LOG_FILE"
        exit 1
    fi

    if grep -q -e "${SUCCESS_KEYWORDS[0]}" -e "${SUCCESS_KEYWORDS[1]}" "$LOG_FILE"; then
        SERVER_READY=1
        break
    fi

#    NOW=$(date +%s)
#    if (( NOW - START_TIME > TIMEOUT )); then
#        echo "Timeout: vLLM server did not start in $TIMEOUT seconds. Log output:"
#        cat "$LOG_FILE"
#        kill "$VLLM_PID" 2>/dev/null || true
#        exit 1
#    fi
done

echo "vLLM server is ready. Exit this script with ctrl-c when done to kill the server. Launching Gradio..."

# Run Gradio script
python ./gradio_openai_chatbot_webserver.py -m "$MODEL_NAME"
