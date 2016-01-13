FROM java:8-jdk

MAINTAINER Lucas Taylor <lucas.taylor@e-hps.com>

ENV TEAMCITY_AGENT_HOME /opt/lib/teamcity-agent

COPY buildAgent.zip /tmp

RUN mkdir -p /opt/lib && \
    mkdir -p /etc/teamcity-agent && \
    unzip /tmp/buildAgent.zip -d $TEAMCITY_AGENT_HOME && \
    chmod +x $TEAMCITY_AGENT_HOME/bin/*.sh && \
    rm -fr $TEAMCITY_AGENT_HOME/conf && \
    ln -s /etc/teamcity-agent $TEAMCITY_AGENT_HOME/conf && \
    rm -fR /tmp/*/

COPY conf/* /etc/teamcity-agent/

VOLUME ["/etc/teamcity-agent"]

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 9090
ENTRYPOINT ["/entrypoint.sh"]



