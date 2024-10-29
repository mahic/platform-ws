FROM trinodb/trino:459

WORKDIR /etc/trino

COPY ./certs/platform.local.crt /etc/trino/certs/platform.local.crt
USER root
RUN keytool -importcert -file /etc/trino/certs/platform.local.crt -cacerts -alias "platform.local" -storepass changeit -noprompt

USER trino:trino
CMD ["/usr/lib/trino/bin/run-trino"]
HEALTHCHECK --interval=10s --timeout=5s --start-period=10s \
CMD /usr/lib/trino/bin/health-check