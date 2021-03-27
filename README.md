# 适用于x86架构群晖的甜糖星愿Docker镜像
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker?ref=badge_shield)


甜糖星愿计划是由甜糖公司结合边缘计算云厂商推出的用户激励计划。用户通过贡献闲置带宽，即可获取星愿积分。星愿可用于折现或兑换商品。

本镜像仅在`群晖DS218+`平台完成测试，理论上可以在其他x86平台以类似操作运行，但本人无法保证效果及成功率。

## 开始使用

### 安装Docker及配置网络

- 在套件中心安装Docker套件
- 进入`控制面板`--`网络`--`网络界面`，选择连接公网的接口，如`局域网1`，点击`管理`--`Open vSwitch设置`，勾选`启用 Open vSwitch`，点击`确定`保存设置
- 通过SSH连接到群晖，执行如下命令，创建一个`macvlan`网络

```bash
docker network create \
    -d macvlan \
    --subnet=192.168.1.0/24 \
    --gateway=192.168.1.1 \
    -o parent=ovs_eth0 \
    macvlan
```

这里`subnet`要改成与你路由器处于同一网段的子网，`gateway`要改成你的路由器的地址，`parent`指定为群晖连接公网所使用的接口名。最后的`macvlan`是网络的名字，可按需修改。

### 准备ARM64(aarch64)模拟环境

下载或克隆本仓库，将[resources/qemu-aarch64-static](resources/qemu-aarch64-static)文件复制到`$PATH`指定的目录，如`/usr/local/bin`并赋予执行权限，然后执行`docker run --rm --privileged multiarch/qemu-user-static:register`。

因为群晖在重启后会丢失上一步的设定，所以需要添加一项开机触发的任务，在每次开机后重新准备模拟环境。

首先将本仓库的`set_qemu_user_static.sh`放到一个合适的位置，比如我放到了`/var/services/homes/boris1993/scripts`。

然后前往`控制面板`--`任务计划`，然后按照如下说明新增一个任务计划：

- 任务名称：可自选
- 用户账号：root
- 事件：开机
- 任务设置--运行命令：
  - 如果不关心日志的话，那么输入`/var/services/homes/boris1993/scripts/set_qemu_user_static.sh`
  - 如果要保存日志的话，那么输入`/var/services/homes/boris1993/scripts/set_qemu_user_static.sh > /var/services/homes/boris1993/scripts/logs/set_qemu_user_static.log`。注意修改重定向符`>`后面的路径到实际你想要保存日志文件的路径。

### 构建镜像并运行

进入该仓库所在目录，修改[docker-docker-compose.yml](docker-docker-compose.yml)。需要修改的内容参考该文件内的注释。

然后执行`sudo docker-compose build`构建镜像。在构建成功完成后，会生成一个名为`tiantang:latest`的镜像。

接下来执行`sudo docker-compose up -d`即可启动该镜像。

在容器启动后，会有一个定时任务在1分钟后自动运行甜糖星愿，此时甜糖星愿可能会在短暂运行一段时间后退出，这是甜糖星愿在自我更新，是正常现象。定时任务会每分钟检查甜糖星愿是否在运行，如果没有在运行的话会自动重启甜糖星愿。

在容器启动两分钟后，会有一个脚本自动检查甜糖星愿监听的端口，并自动配置路由器上的UPnP规则。这个脚本还会在每天0点、8点、16点各运行一次，以防因各种原因丢失UPnP规则而导致的问题。如果不希望通过脚本自动配置UPnP规则，那么可以为容器配置环境变量`SKIP_UPNP_AUTOCONFIG=true`。

此时使用手机上的甜糖客户端即可绑定该设备。

### 手动绑定

如果手机客户端无法自动发现甜糖星愿节点，那么你可以在Docker套件中，进入名为`tiantang`的容器，新建一个终端机，执行`ttnode -p /data`命令。在命令输出中可以看到该节点的`uid`，将其复制到任意二维码生成工具中来生成一个二维码，用手机客户端扫描该二维码即可绑定。

## 监控节点状态

实话说，因为甜糖星愿几乎没有日志，所以很难具体监控节点的运行状态，只能在容器内通过`ps`命令检查进程是否存活。

进程状态监控的脚本会将每一次重启甜糖星愿的行为记录到容器的`/var/log/app.log`文件中。

设置UPnP规则的脚本会将最后一次的操作日志记录到容器的`/var/log/upnp.log`文件中。因为往期日志没有参考意义，也因为输出比较多，为防止日志内容过大，所以决定覆盖之前内容。

## 许可协议

该项目除甜糖星愿可执行文件(`ttnode`)外，依照[MIT协议](LICENSE)开放源代码。


## License
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fboris1993%2Ftiantang-x86-docker?ref=badge_large)