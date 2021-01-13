FROM --platform=linux/arm64/v8 ubuntu:18.04

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

ADD resources/sources.list /etc/apt/sources.list
ADD resources/qemu-aarch64-static /usr/bin/qemu-aarch64-static

RUN apt update && apt upgrade -y 

RUN apt install -y tzdata cron iproute2 iputils-ping net-tools miniupnpc

ADD resources/ttnode /usr/local/bin
ADD resources/start.sh /usr/local/bin
ADD resources/init.sh /usr/local/bin
ADD resources/liveness-check.sh /usr/local/bin
ADD resources/set-port-forwarding.sh /usr/local/bin
ADD resources/cronjob /etc/cron.d/liveness-check

RUN mkdir /data \
  && touch /var/log/app.log \
  && chmod 755 /usr/local/bin/ttnode \
  && chmod 755 /usr/local/bin/start.sh \
  && chmod 755 /usr/local/bin/init.sh \
  && chmod 755 /usr/local/bin/liveness-check.sh \
  && chmod 755 /etc/cron.d/liveness-check \
  && crontab /etc/cron.d/liveness-check 

CMD start.sh
