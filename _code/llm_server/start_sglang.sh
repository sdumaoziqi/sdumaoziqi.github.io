python3 -m sglang.launch_server \
 --model-path /data1/models--deepseek-ai--DeepSeek-R1/snapshots/test \
 --served-model-name DeepSeek-R1\
 --port 23451 \
 --host 0.0.0.0  \
 --tp 8 \
 --trust-remote-code  