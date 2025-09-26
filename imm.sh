#!/bin/bash
mkdir -p imm

FILE_NAME="immortalwrt-24.10.2-x86-64-generic-squashfs-combined-efi.img.gz"
OUTPUT_PATH="imm/immortalwrt.img.gz"
DOWNLOAD_URL=https://github.com/killychan/AutoBuildImmortalWrt/releases/download/Autobuild-x86-64/immortalwrt-24.10.2-x86-64-generic-squashfs-combined-efi.img.gz

if [[ -z "$DOWNLOAD_URL" ]]; then
  echo "错误：未找到文件 $FILE_NAME"
  exit 1
fi

echo "下载地址: $DOWNLOAD_URL"
echo "下载文件: $FILE_NAME -> $OUTPUT_PATH"
curl -L -o "$OUTPUT_PATH" "$DOWNLOAD_URL"

if [[ $? -eq 0 ]]; then
  echo "下载immortalwrt-24.10.2成功!"
  file imm/immortalwrt.img.gz
  echo "正在解压为:immortalwrt.img"
  gzip -d imm/immortalwrt.img.gz
  ls -lh imm/
  echo "准备合成 immortalwrt 安装器"
else
  echo "下载失败！"
  exit 1
fi

mkdir -p output
docker run --privileged --rm \
        -v $(pwd)/output:/output \
        -v $(pwd)/supportFiles:/supportFiles:ro \
        -v $(pwd)/imm/immortalwrt.img:/mnt/immortalwrt.img \
        debian:buster \
        /supportFiles/immortalwrt/build.sh
