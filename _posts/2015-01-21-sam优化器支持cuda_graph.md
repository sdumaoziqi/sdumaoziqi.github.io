

最近使用[sam](https://github.com/davda54/sam)优化器，发现其在[cuda graph](https://pytorch.org/blog/accelerating-pytorch-with-cuda-graphs/)模式下训练的结果差了非常多。

最后定位到在first_step()内，会通过clone()将原有的参数保存下来,在second_step()中恢复。通过log，发现在capture模式下，一个tensor clone()，新的tensor全部都是0，导致在second_step()中恢复的都是0。

修复方案：
提前申请显存空间，clone()替换为copy_(), 在capture内避免cudaMemoryMalloc。修复参考链接: https://github.com/sdumaoziqi/sam/commit/f0e8f5974a28c09e10f1b27f7662b57737fdf118