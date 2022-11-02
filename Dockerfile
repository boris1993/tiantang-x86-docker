FROM ubuntu:bionic

ENV TZ=Asia/Shanghai
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y \
  && apt install -y tzdata cron iproute2 iputils-ping net-tools qrencode iptables \
  && echo "dash dash/sh boolean false" | debconf-set-selections && dpkg-reconfigure dash \
  && mkdir /data \
  && touch /var/log/app.log 

ADD resources/ttnode /usr/local/bin
ADD resources/yfapp.conf /usr/local/bin
ADD resources/set-variables.sh /usr/local/bin
ADD resources/redirect-yfnode-log.sh /usr/local/bin
ADD resources/start.sh /usr/local/bin
ADD resources/init.sh /usr/local/bin
ADD resources/liveness-check.sh /usr/local/bin
ADD resources/print-qrcode.sh /usr/local/bin
ADD resources/cronjob /etc/cron.d/liveness-check

RUN chmod 755 /usr/local/bin/ttnode \
  && chmod 755 /usr/local/bin/yfapp.conf \
  && chmod 755 /usr/local/bin/redirect-yfnode-log.sh \
  && chmod 755 /usr/local/bin/start.sh \
  && chmod 755 /usr/local/bin/init.sh \
  && chmod 755 /usr/local/bin/liveness-check.sh \
  && chmod 755 /etc/cron.d/liveness-check \
  && crontab /etc/cron.d/liveness-check 

CMD source /usr/local/bin/set-variables.sh && start.sh
