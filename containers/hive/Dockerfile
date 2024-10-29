FROM apache/hive:3.1.3

WORKDIR /opt
COPY configs/hive/entrypoint.sh /entrypoint.sh

USER hive
EXPOSE 9083

ENTRYPOINT ["bash", "/entrypoint.sh"]