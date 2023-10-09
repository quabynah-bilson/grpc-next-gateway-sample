FROM envoyproxy/envoy:v1.26-latest
COPY gateway-reverse-proxy.yaml /etc/envoy/envoy.yaml
EXPOSE 8889
ENV ENVOY_UID=0
CMD /usr/local/bin/envoy -c /etc/envoy/envoy.yaml