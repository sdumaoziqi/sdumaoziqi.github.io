docker run \
    --shm-size 32g \
    -p 23451:23451 \
    -v ~/.cache/huggingface:/root/.cache/huggingface \
    -v /data1:/data1 \
    --ipc=host \
    lmsysorg/sglang:latest \
    python3  -m sglang.launch_server \
    --model-path /data1/models--deepseek-ai--DeepSeek-R1/snapshots/test \
    --served-model-name DeepSeek-R1\
    --port 23451 \
    --host 0.0.0.0  \
    --tp 8 \
    --trust-remote-code  

    # --gpus all \