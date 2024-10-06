#!/bin/bash
#SBATCH --job-name=BEN_test_1             # 作业名称
#SBATCH --output=BEN_test_1.out           # 输出文件
#SBATCH --error=BEN_test_1.err            # 错误日志文件
#SBATCH --nodes=1                       # 使用的节点数
#SBATCH --ntasks=1                      # 每个节点上运行的任务数
#SBATCH --cpus-per-task=16              # 为每个任务分配的 CPU 核心数
#SBATCH --time=24:00:00                 # 作业运行的最大时间 (hh:mm:ss)
#SBATCH --mem=64GB                      # 申请的内存
#SBATCH --partition=standard            # 分区名称（根据你的系统配置选择）

# 加载 MATLAB 模块 (如果需要)
module load matlab

# 执行 MATLAB 脚本
matlab -nodisplay -r "run('BEN_calculate.m'); exit;"
