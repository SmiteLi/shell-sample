#!/usr/bin/env bash

# 检查服务器的 cpu， 内存， 硬盘， 各个服务

echo "开始巡检......"

echo "Cpu 负载情况："
count=1
while [[ $count < 4 ]]; do
  top -b -n 1 | grep Cpu
  let count++
done

echo "内存使用情况："
free -h

echo "硬盘使用情况："
echo "Filesystem              Type      Size  Used Avail Use% Mounted on"
df -hT | grep -v "Filesystem" | sort -nrk 6

echo "监听端口："
netstat -antp

phy_cpu=$(cat /proc/cpuinfo | grep "physical id"|sort | uniq | wc -l)

logic_cpu_num=$(cat /proc/cpuinfo | grep "processor"| wc -l)

cpu_core_num=$(cat /proc/cpuinfo | grep "cores"|uniq|awk -F: '{print $2}')

cpu_freq=$(cat /proc/cpuinfo | grep MHz | uniq | awk -F: '{print $2}')

system_core=$(uname -r)

system_version=$(cat /etc/redhat-release)

system_hostname=$(hostname | awk '{print $1}')

systemc_envirement_variables=$(env | grep PATH)

mem_free=$(grep MemFree /proc/meminfo)

disk_usage=$(df -h)

system_uptime=$(uptime)

system_load=$(cat /proc/loadavg)

system_ip=$(ifconfig | grep "inet"|grep -v "127.0.0.1"|awk -F: '{print $1}'|awk 'NR==1{print}'| awk '{print $2}')                #自己改的

mem_info=$(/usr/sbin/dmidecode | grep -A 16 "Memory Device"|grep -E "Size|Locator"|grep -v Bank)

mem_total=$(grep MemTotal /proc/meminfo)

day01=$(date +%Y)

day02=$(date +%m)

day03=$(date +%d)



path=inspection.txt

echo -e " " > $path

echo -e $day01年$day02月$day03系统巡检报告  >> $path

echo -e 主机名："\t"$system_hostname >> $path

echo -e 服务器IP: "\t"$system_ip >> $path

echo -e 系统内核: "\t"$system_core  >> $path

echo -e 操作系统版本："\t"$system_version >> $path

echo -e 磁盘使用情况： "\t""\t" $disk_usage >> $path

echo -e CPU核数："\t"$cpu_core_num >> $path

echo -e 物理CPU个数："\t"$phy_cpu >> $path

echo -e 逻辑CPU个数："\t"$logic_cpu_num >> $path

echo -e 系统环境变量："\t"$systemc_envirement_variables >> $path

echo -e CPU的主频："\t"$cpu_freq >> $path

echo -e 内存简要信息："\t"$mem_info >> $path

echo -e 内存总大小："\t"$mem_total >> $path

echo -e 内存空间： "\t"$mem_free >> $path

echo -e 时间/系统运行时间/当前登陆用户/系统过去1分钟/5分钟/15分钟内平均负载/"\t"$system_uptime >> $path

echo -e 1分钟/5分钟/15分钟平均负载/在采样时刻，运行任务的数目/系统活跃任务的个数/最大的pid值线程/ "\t"$system_load >> $path
