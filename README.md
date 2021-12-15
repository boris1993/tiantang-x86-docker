# 适用于x86架构群晖的甜糖星愿Docker镜像

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker?ref=badge_shield)

甜糖星愿计划是由甜糖公司结合边缘计算云厂商推出的用户激励计划。用户通过贡献闲置带宽，即可获取星愿积分。星愿可用于折现或兑换商品。

本镜像仅在`群晖DS218+`平台完成测试，理论上可以在其他x86平台以类似操作运行，但本人无法保证效果及成功率。

## 开始使用

### 安装Docker及配置网络

- 在套件中心安装Docker套件
- 进入`控制面板`--`网络`--`网络界面`，选择连接公网的接口，如`局域网1`，点击`管理`--`Open vSwitch设置`，勾选`启用 Open vSwitch`，点击`确定`保存设置

### 启动容器

进入该仓库所在目录，修改[docker-docker-compose.yml](docker-docker-compose.yml)。需要修改的内容参考该文件内的注释。

接下来执行`sudo docker-compose up -d`即可启动该镜像。

如果你不会使用`docker compose`，那么可以执行如下命令来启动：

```bash
# 请注意修改-v参数，将实际用于存放数据的目录映射到容器中
docker run \
    --restart always \
    --name tiantang \
    --network=host \
    -e "TZ=Asia/Shanghai" \
    -v /volume2/docker-data/tiantang:/data:rw \
    boris1993/tiantang-x86-docker:latest
```

在容器启动后，会有一个定时任务在1分钟后自动运行甜糖星愿，此时甜糖星愿可能会在短暂运行一段时间后退出，这是甜糖星愿在自我更新，是正常现象。定时任务会每分钟检查甜糖星愿是否在运行，如果没有在运行的话会自动重启甜糖星愿。

此时使用手机上的甜糖客户端即可绑定该设备。

### 手动绑定

~~如果手机客户端无法自动发现甜糖星愿节点，那么你可以在Docker套件中，进入名为`tiantang`的容器，新建一个终端机，执行`ttnode -p /data`命令。在命令输出中可以看到该节点的`uid`，将其复制到任意二维码生成工具中来生成一个二维码，用手机客户端扫描该二维码即可绑定。~~

现在你的二维码会在甜糖星愿的容器启动时打印在日志中，如果你没有看到，那么你还可以在服务器上（注意不是在容器里）执行 `docker exec tiantang print-qrcode.sh` 命令，然后你的二维码会显示在你当前的终端里。

## 监控节点状态

通常来说你不需要人工监控节点的状态，`cron`会每分钟检查一次`ttnode`进程是否存活，如进程不存活则会自动尝试启动。

进程状态监控的脚本会将每一次重启甜糖星愿的行为记录到容器的`/var/log/app.log`文件中。

同时`ttnode`记录在`/tmp/.yfnode.log`的日志也将会被打印出来，可以方便监控节点的上传下载状态，以及是否自动更新。

## 许可协议

该项目除甜糖星愿可执行文件(`ttnode`)外，依照[MIT协议](LICENSE)开放源代码。

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker?ref=badge_large)
