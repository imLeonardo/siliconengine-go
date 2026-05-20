#!/bin/bash

# 定义所有目标
all() {
  clean
  lint
}

# 清理目标
clean() {
  echo "Cleaning all build output..."
  rm -rf BASE_DIR
}

# RPC proto设置目标
pb_setup() {
  go get -u google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  go get -u google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
  go mod tidy
}

pb_all() {
  pb_cs_all
  pb_ss_all
}

pb_cs() {
  sh ./script/pb.sh pb "proto/cs/" "src/transfer/proto/"
}

pb_cs_clean() {
  sh ./script/pb.sh clean "src/transfer/proto/cs_*.proto"
}

pb_cs_all() {
  pb_cs_clean
  pb_cs
}

pb_ss() {
  sh ./script/pb.sh pb "proto/ss/" "src/transfer/proto/"
}

pb_ss_clean() {
  sh ./script/pb.sh clean "src/transfer/proto/ss_*.proto"
}

pb_ss_all() {
  pb_ss_clean
  pb_ss
}

# 根据命令行参数执行相应操作
parse_args() {
  if [ -z "$1" ]; then
    all
  elif [ "$1" == "clean" ]; then
    clean
  elif [ "$1" == "lint" ]; then
    lint
  elif [ "$1" == "pb-setup" ]; then
    pb_setup
  elif [ "$1" == "pb" ]; then
    if [ -z "$2" ]; then
      pb_all
    elif [ "$2" == "cs" ]; then
      pb_cs
    elif [ "$2" == "ss" ]; then
      pb_ss
    else
      echo "Unknown command: $2"
    fi
  else
    echo "Unknown command: $1"
  fi
}

# 调用解析参数函数
parse_args "$@"
