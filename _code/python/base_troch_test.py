import torch

a = torch.ones(3, 1)
print(f'{torch.__version__}')
print(f'{torch.ones(3, 1)=}')
print(f'{torch.cuda.device_count()=}')