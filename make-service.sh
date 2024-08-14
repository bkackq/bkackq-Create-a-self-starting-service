#!/bin/bash  
  
# 检查系统是否使用systemd  
if ! command -v systemctl &> /dev/null  
then  
    echo "错误：系统未使用systemd作为服务管理器！"  
    exit 1  
fi  
  
# 读取用户输入  
read -p "请输入服务名称: " service_name  
read -p "请输入要执行的脚本文件的绝对路径: " exec_path  
  
# 验证输入的exec_path是否是一个存在的文件  
if [ ! -f "$exec_path" ]; then  
    echo "错误：指定的文件不存在！"  
    exit 1  
fi  
  
# systemd service文件模板  
service_template="  
[Unit]  
Description=JetBot start service  
After=multi-user.target  
  
[Service]  
Type=oneshot  
User=root  
ExecStart=$exec_path  
WorkingDirectory=$(dirname $exec_path)  
  
[Install]  
WantedBy=multi-user.target  
"  
  
# systemd service文件存放路径（通常是固定的）  
systemd_service_dir="/etc/systemd/system/"  
  
# 确保systemd service文件存放目录存在  
if [ ! -d "$systemd_service_dir" ]; then  
    echo "错误：systemd的service文件存放目录不存在！"  
    exit 1  
fi  
  
# 写入service文件  
service_file="$systemd_service_dir/${service_name}.service"  
echo "$service_template" > "$service_file"  
  
# 验证service文件是否成功创建  
if [ ! -f "$service_file" ]; then  
    echo "错误：无法创建service文件！"  
    exit 1  
fi  
  
# 重新加载systemd守护进程，使其识别新的或更改的unit文件  
sudo systemctl daemon-reload  
  
# 启用并启动服务  
sudo systemctl enable "$service_file"  
sudo systemctl start "$service_file"  
  
# 检查服务状态  
sudo systemctl status "$service_file"  
  
echo "服务 $service_name 已创建、启用并启动。"
