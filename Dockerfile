FROM kong
USER root
#
RUN apt-get update

RUN apt-get install -y python3 python3-pip python3-dev musl-dev libffi-dev gcc g++ file make
RUN PYTHONWARNINGS=ignore pip3 install kong-pdk kubernetes
COPY --chown=kong --chmod=555 plugins/actuator-plugin.py /usr/local/kong/python-plugins/actuator-plugin.py
RUN touch /usr/local/kong/python_pluginserver.sock
RUN chmod -R 777 /usr/local/bin
RUN chmod -R 777 /usr/local/kong

#RUN apt-get install -y nodejs npm
#RUN npm i -g kong-pdk
#COPY --chown=kong --chmod=555 plugins/actuator-plugin.js /usr/local/kong/js-plugins/actuator-plugin.js

#RUN chown -R 777  /usr/local/kong
#RUN chown -R 777  /usr/local/bin
#RUN touch /usr/local/kong/js_pluginserver.sock
#RUN chmod -R 777  /usr/local/kong/js_pluginserver.sock
#
RUN ls /usr/local/bin/

# reset back the defaults
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8001 8444 8002
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
