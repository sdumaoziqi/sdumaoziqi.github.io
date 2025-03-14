docker run      \
    --runtime=nvidia \
    --gpus all  \
    -it --rm    \
    lmsysorg/sglang:latest bash


# curl -fsSL nvidia.github.io/libnvi | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
# && curl -s -L mirrors.ustc.edu.cn/lib | \
# sed 's#deb nvidia.github.io# [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] USTC Open Source Software Mirror' | \
# sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list


# deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] nvidia.github.io/libnvi$(ARCH) /
# #deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] nvidia.github.io/libnvi$(ARCH) /