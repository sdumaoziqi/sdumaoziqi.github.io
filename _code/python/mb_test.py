import torch
import torch.multiprocessing as mp
from torch.profiler import profile, record_function, ProfilerActivity

def memcpy(rank):
    torch.set_num_threads(16)
    device = f"cuda:{rank}"
    torch.cuda.set_device(device)
    data = torch.rand(4 * 1024 * 1024, 1024)
    with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA],
        record_shapes=True, profile_memory=True) as prof:
        for _ in range(5):
            data.to(device)
            data.to("cpu")
    prof.step()
    prof.export_chrome_trace(f"trace_rank_{rank}.json")

if __name__ == "__main__":
    world_size = torch.cuda.device_count()
    mp.spawn(
        memcpy,
        args=(),
        nprocs = world_size,
        join=True
    )