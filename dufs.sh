#!/bin/bash

# 定义变量
DUFS_URL="https://github.com/sigoden/dufs/releases/download/v0.43.0/dufs-v0.43.0-x86_64-unknown-linux-musl.tar.gz"
DUFS_ARCHIVE="dufs-v0.43.0-x86_64-unknown-linux-musl.tar.gz"
DUFS_DIR="/dufs"                # 根目录的 dufs 文件夹
DUFS_BINARY="$DUFS_DIR/dufs"    # 二进制文件路径

SERVE_PATH="."                  # 要共享的目录
BIND_ADDRESS="0.0.0.0"          # 绑定的地址
PORT="5000"                     # 监听的端口
AUTH_RULES="us:pw@/:rw" # 认证规则
ALLOW_UPLOAD="true"             # 是否允许上传
ALLOW_DELETE="true"             # 是否允许删除
LOG_FILE="./dufs.log"           # 日志文件路径

# 创建 dufs 文件夹
if [ ! -d "$DUFS_DIR" ]; then
  echo "Creating dufs directory at $DUFS_DIR..."
  mkdir -p "$DUFS_DIR"
fi

# 下载 dufs 二进制文件
echo "Downloading dufs binary..."
curl -L -o "$DUFS_DIR/$DUFS_ARCHIVE" "$DUFS_URL"

# 解压 dufs 二进制文件
echo "Extracting dufs binary..."
tar -xzf "$DUFS_DIR/$DUFS_ARCHIVE" -C "$DUFS_DIR"

# 授权可执行
echo "Granting execute permission for dufs binary..."
chmod +x "$DUFS_BINARY"

# 检查 dufs 是否安装成功
if [ ! -f "$DUFS_BINARY" ]; then
  echo "dufs setup failed. Binary not found."
  exit 1
fi
echo "dufs binary is ready at $DUFS_BINARY."

# 启动 dufs 文件服务器
echo "Starting dufs file server..."
"$DUFS_BINARY" \
  --bind "$BIND_ADDRESS" \
  --port "$PORT" \
  --auth "$AUTH_RULES" \
  $( [[ "$ALLOW_UPLOAD" == "true" ]] && echo "--allow-upload" ) \
  $( [[ "$ALLOW_DELETE" == "true" ]] && echo "--allow-delete" ) \
  --log-file "$LOG_FILE" \
  "$SERVE_PATH"