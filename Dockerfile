FROM alpine as BUILD

ARG GRAFANA_VERSION=5.2.4-1554283191

COPY ./grafana-$GRAFANA_VERSION.linux-amd64.tar.gz /tmp/grafana.tar.gz

RUN tar -zxvf /tmp/grafana.tar.gz -C /tmp && mv /tmp/grafana-$GRAFANA_VERSION /tmp/grafana && \
    rm -rf /tmp/grafana.tar.gz

FROM debian:9.3-slim

ARG GRAFANA_VERSION

RUN apt-get update && apt-get install -qq -y wget tar sqlite libfontconfig curl ca-certificates
    #wget -O /tmp/grafana.tar.gz https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-$GRAFANA_VERSION.linux-amd64.tar.gz && \
    
COPY --from=BUILD /tmp/grafana/ /grafana/
ADD config.ini /grafana/conf/config.ini

ADD camptocamp-grafana-prometheus-alertmanager-datasource-fb4c900 /grafana/plugins/camptocamp-grafana-prometheus-alertmanager-datasource-fb4c900
ADD grafana-piechart-panel-5f249d5 /grafana/plugins/grafana-piechart-panel-5f249d5

USER       nobody
EXPOSE     3000
VOLUME     [ "/data" ]
WORKDIR    /grafana
ENTRYPOINT [ "/grafana/bin/grafana-server" ]
CMD        [ "-config=/grafana/conf/config.ini" ]
