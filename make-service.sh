#!/bin/bash  
  
# 提示用户输入服务名称和要自启动的文件的绝对路径  
read -p "请输入服务的名称: " SERVICE_NAME  
read -p "请输入要自启动的文件的绝对路径: " EXEC_PATH  
  
# 定义模板文件的路径（这里假设它与脚本在同一目录下）  
TEMPLATE_FILE="template.service"  
  
# 创建一个临时文件来保存修改后的服务单元内容  
TEMP_FILE=$(mktemp)  
  
# 读取模板文件，将ExecStart的值替换为用户输入的值，然后写入临时文件  
cat "$TEMPLATE_FILE" | sed "s|/usr/bin/openttyTHS1.sh|$EXEC_PATH|g" > "$TEMP_FILE"  
  
# 将临时文件的内容写入以用户输入的服务名称命名的服务单元文件  
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"  
sudo cp "$TEMP_FILE" "$SERVICE_FILE"  
  
# 清理临时文件  
rm "$TEMP_FILE"  
  
# 重新加载systemd，以识别新的或更改的服务单元文件  
echo "正在重新加载systemd配置..."  
sudo systemctl daemon-reload  
  
# 可选：启用并启动服务  
echo "服务单元文件已创建，正在尝试启用并启动服务..."  
sudo systemctl enable "${SERVICE_NAME}.service"  
sudo systemctl start "${SERVICE_NAME}.service"  
  
echo "服务'${SERVICE_NAME}.service'已启用并启动。"
