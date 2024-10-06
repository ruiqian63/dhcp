#!/bin/bash
#SBATCH --job-name=BEN_all             # 作业名称
#SBATCH --output=BEN_all.out           # 输出文件
#SBATCH --error=BEN_all.err            # 错误日志文件
#SBATCH --nodes=1                       # 使用的节点数
#SBATCH --ntasks=1                      # 每个节点上运行的任务数
#SBATCH --cpus-per-task=16              # 为每个任务分配的 CPU 核心数
#SBATCH --time=120:00:00                 # 作业运行的最大时间 (hh:mm:ss)
#SBATCH --mem=512GB                      # 申请的内存

# 加载 MATLAB 模块 (如果需要)
module load matlab

# 执行 MATLAB 脚本
matlab -nodisplay -r "run('BEN_calculate.m'); exit;"
