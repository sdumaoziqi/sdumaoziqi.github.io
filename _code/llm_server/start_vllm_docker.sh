docker run     \
    --runtime nvidia --gpus all \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    -v /data1:/data1 \
    -p 23451:23451 \
    --ipc=host \
    vllm/vllm-openai:latest \
    --model /data1/models--deepseek-ai--DeepSeek-R1/snapshots/test \
    --served-model-name DeepSeek-R1\
    --port 23451 \
    --host 0.0.0.0  \
    -tp 8 \
    --trust-remote-code