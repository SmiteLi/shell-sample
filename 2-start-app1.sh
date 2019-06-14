#!/usr/bin/env bash

# 同一目录，二进制文件 app1,这个为 start.sh
# ulimit :
# -S 　设定资源的弹性限制
# -H 　设定资源的硬性限制，也就是管理员所设下的限制。
# -n <文件数目> 　指定同一时间最多可开启的文件数。
ulimit -SHn 65536

# 到脚本所在目录
cd `dirname $0`
cd ..
pwd=`pwd`

# pgrep 是linux中常用的通过程序名字来查询进程的命令。
# -o == oldest 当匹配多个进程时，显示进程号最小的那个
#  pgrep -f program_name 列出进程名为 program_name 的ID，f参数可以匹配command中的关键字；
# -n == --newest，最新的进程，即进程号最大的那个

# 关掉 app1 应用
pid=`pgrep -f -o "$pwd/bin/app1"`
if [ "$pid" != "" ]; then
    kill -9 $pid
fi

# net.ipv4.tcp_tw_reuse = 0    表示开启重用。允许将TIME-WAIT sockets重新用于新的TCP连接，默认为0，表示关闭
# net.ipv4.tcp_tw_recycle = 0  表示开启TCP连接中TIME-WAIT sockets的快速回收，默认为0，表示关闭
# net.ipv4.tcp_fin_timeout = 60  表示如果套接字由本端要求关闭，这个参数决定了它保持在FIN-WAIT-2状态的时间
# net.ipv4.tcp_syncookies=1 打开这个syncookies的目的实际上是：“在服务器资源（并非单指端口资源，
# 拒绝服务有很多种资源不足的情况）不足的情况下，尽量不要拒绝TCP的syn（连接）请求，尽量把syn请# 求缓存起来，留着过会儿有能力的时候处理这些TCP的连接请求”。
# net.ipv4.tcp_timestamps : https://blog.csdn.net/pyxllq/article/details/80351827
sysctl net.ipv4.tcp_tw_reuse=1
sysctl net.ipv4.tcp_timestamps=1
sysctl net.ipv4.tcp_syncookies=1

# 启动 app1 应用
nohup "$pwd/bin/app1" > "./log/console_output.log" 2>&1 &
