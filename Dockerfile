# 构建编译文件
#FROM 10.1.1.132:1180/library/java:8
FROM 192.168.10.30:10001/automatic/golang:1.17
# 拷贝项目文件到镜像中
COPY . /app
# 设置命令工作目录
WORKDIR /app
# 执行命令编译项目文件
RUN go mod tidy && make build

# 构建运行时文件
FROM 192.168.10.30:10001/automatic/alpine:3.13
# 添加作者
LABEL author=weichengjian
# 设置工作目录
WORKDIR /app
# 从上一阶段中拷贝可执行文件
COPY --from=builder /app/bin/app /app/bin/app
# 声明暴露的端口
EXPOSE 9000/tcp
# 调整动态链接地址
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2
# 启动服务
ENTRYPOINT [ "/app/bin/app" ]
