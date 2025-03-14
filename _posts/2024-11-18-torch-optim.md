---
layout: post
title: torch capturable
date: 2024-11-18
author: sdumaoziqi
categories:
tags: [Float]
comments: true
toc: true
pinned: false
---

# torch capturable

最近在模型训练使用cuda graph时候发现，torch中的优化器RAdam需要开启`capturable=True`, 否则graph capture会失败。
但是开启了`capturable=True`后，模型train的结果与`capturable=False`不一样，即使不用cuda graph也不一样。

最后定位发现的RAdam中更新状态参数时候使用了不用的方法导致的。
* capturable=True
  - 由于参数都是GPU上，计算时都用torch实现
* capturable=False
  - 参数都在cpu上，计算使用python实现

下面是复现代码，代码来自`torch/optim/radam.py`
```py
import torch
def run_opt(capturable, step):
    def _get_value(x):
        return x.item()
    beta2 = 0.999
    grouped_state_steps = [torch.tensor(step, dtype=torch.float32)] * 2
    rho_inf = 2 / (1 - beta2) - 1
    # compute the length of the approximated SMA
    if capturable:
        bias_correction1 = torch._foreach_pow(beta2, grouped_state_steps)
        torch._foreach_neg_(bias_correction1)
        torch._foreach_add_(bias_correction1, 1)
        bias_correction2 = torch._foreach_pow(beta2, grouped_state_steps)
        torch._foreach_mul_(bias_correction2, grouped_state_steps)
        torch._foreach_mul_(bias_correction2, 2)
        torch._foreach_div_(bias_correction2, bias_correction1)
        torch._foreach_neg_(bias_correction2)
        torch._foreach_add_(bias_correction2, rho_inf)
        rho_t_list = bias_correction2
    else:
        # print(rho_inf, beta2)
        rho_t_list = [rho_inf - 2 * _get_value(step) * (beta2 ** _get_value(step)) /
                        (1 - beta2 ** _get_value(step)) for step in grouped_state_steps]
    return rho_t_list

for step in range(1, 10000, 1000):
    a = run_opt(False, step)[0]
    b = run_opt(True, step)[0].item()
    print(a, b, (abs(a - b) / a))
```

运行上面代码，可以发现两种实现在step较小的时候误差比较大，后面逐渐接近0。

