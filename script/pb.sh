#!/bin/bash

OPTION_SRC_DIR=options

SRC_DIR=$2
PB_FILES="$SRC_DIR/*.proto"
OUT_DIR=$3

BUILD_CS_CMD="protoc --experimental_allow_proto3_optional -I $SRC_DIR \
    --go_out=paths=source_relative:$OUT_DIR \
    --go-grpc_out=paths=source_relative:$OUT_DIR"

# 生成 pb 目标
pb() {
  mkdir -p $SRC_DIR
  mkdir -p $OUT_DIR
  $BUILD_CS_CMD $PB_FILES
}

clean() {
  rm -rf $OUT_DIR/*.pb.go
}

all() {
  pb_clean
  pb
}


# 根据命令行参数执行相应操作
parse_args() {
  if [ -z "$1" ]; then
    all
  elif [ "$1" == "pb" ]; then
    pb
  elif [ "$1" == "clean" ]; then
    clean
  elif [ "$1" == "all" ]; then
    all
  else
    echo "Unknown command: $1"
  fi
}

# 调用解析参数函数
parse_args "$@"
