import os

def foo(file_path):
    target_file = None
    with open(file_path, "r") as f:
        for line in f.readlines():
            line = line.strip()
            # print(line)
            if line.startswith("../../blobs"):
                target_file = line
    print(target_file)
    cmd = f"rm {file_path} && ln -s {target_file} {file_path}"
    print(cmd)
    os.system(cmd)


root_dir= "/data/models--deepseek-ai--DeepSeek-R1-Distill-Llama-8B/snapshots/74fbf131a939963dd1e244389bb61ad0d0440a4d"

for file in os.listdir(root_dir):
    file_path = f"{root_dir}/{file}"
    file_size = os.stat(file_path).st_size
    # print(f"{file} {file_size}")
    if file_size == 1067 :
        foo(file_path)