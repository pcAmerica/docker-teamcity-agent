**************
TeamCity Agent
**************

This Docker image is based on the `Docker Java`_ (java:8-jdk) image.

Build
=====

Building the image will send approx 17MB to the docker daemon as it
includes the TeamCity agent zipfile.

.. code-block:: sh

    docker build -t hps/teamcity-agent .

Create a new image based on this one in order to add other dependencies
that your build steps may require.


Run
===

The entrypoint for the image will start the TeamCity agent and configure
it to connect to the specified TeamCity server.

``${TEAMCITY_SERVER}`` must be provided as an `http` or `https` url to
the TeamCity server, e.g. ``http://TEAMCITY-SERVER``

.. code-block:: sh

    docker run -d hps/teamcity-agent ${TEAMCITY_SERVER}


You can optionally pass an env var to specify the agent name:

.. code-block:: sh

    docker run -d hps/teamcity-agent ${TEAMCITY_SERVER} \
        -e TEAMCITY_AGENT_NAME="My Test Agent"


Once running, the container will register itself with server provided
by the ``${TEAMCITY_SERVER}`` variable.

The volume containing the agent configuration is persistent, so the
container can be stopped and started as-needed and will retain its
authorization with the server.


Running Docker in a Build
-------------------------
In order to have the agent run docker containers as part of a build step,
you must bind-mount the docker binary and socket from the host so that
it can run the docker containers as siblings in the build scripts.

.. code-block:: sh

    docker run -v /var/run/docker.sock:/var/run/docker.sock \
           -v $(which docker):/bin/docker \
           -d hps/teamcity-agent \
           ${TEAMCITY_SERVER}


.. warning:: While the agent itself runs without issues, it may require
    additional work to execute the docker binary from within the agent
    container. This method is not guaranteed.


.. _Docker Java: https://hub.docker.com/_/java/
