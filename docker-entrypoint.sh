#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "TeamCity server name not provided."
    echo "Launch with the address of the server: docker run teamcity-agent http://mybuildserver"
    exit 1
fi

TEAMCITY_SERVER=$1

if [ -z "$TEAMCITY_AGENT_NAME" ]; then
    TEAMCITY_AGENT_NAME=
fi

# Update agent configuration
sed \
    -e "s|<teamcity_server>|$TEAMCITY_SERVER|" \
    -e "s|<teamcity_agent_name>|$TEAMCITY_AGENT_NAME|" \
    < /etc/teamcity-agent/buildAgent.dist.properties > /etc/teamcity-agent/buildAgent.properties

# If CMD arg begins with http, assume agent start requested
if [ ${TEAMCITY_SERVER:0:4} = 'http' ]; then
    echo "Using Teamcity Server: $TEAMCITY_SERVER..."
    exec "$TEAMCITY_AGENT_HOME/bin/agent.sh" "run"
fi

# Otherwise, execute the CMD arg in the container
exec "$@"
