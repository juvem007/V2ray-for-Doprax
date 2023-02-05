FROM nginx:latest
MAINTAINER ifeng <https://t.me/HiaiFeng>
EXPOSE 80
USER root

RUN apt-get update && apt-get install -y supervisor wget unzip

# 用新生成的 UUID 替换 b9cb8b3b-797e-4480-9a51-4ca4f1371c93

ENV UUID b9cb8b3b-797e-4480-9a51-4ca4f1371c93

# VMESS_WSPATH / VLESS_WSPATH 两个常量分别定义了Vmess/VLess的伪装路径，

# 请分别修改内容中的vmess或vless。注意：伪装路径以 / 符号开始,为避免不必要的麻烦，请不要使用特殊符号.

ENV VMESS_WSPATH /vmess

ENV VLESS_WSPATH /vless




COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir /etc/v2ray /usr/local/v2ray
COPY config.json /etc/v2ray/
COPY entrypoint.sh /usr/local/v2ray/

# 感谢 fscarmen 大佬提供 Dockerfile 层优化方案
RUN wget -q -O /tmp/v2ray-linux-64.zip https://github.com/v2fly/v2ray-core/releases/download/v4.45.0/v2ray-linux-64.zip && \
    unzip -d /usr/local/v2ray /tmp/v2ray-linux-64.zip && \
    chmod a+x /usr/local/v2ray/entrypoint.sh

ENTRYPOINT [ "/usr/local/v2ray/entrypoint.sh" ]
CMD ["/usr/bin/supervisord"]
