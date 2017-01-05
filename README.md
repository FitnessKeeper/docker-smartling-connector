# docker-smartling-connector
A docker image based on openjdk alpine linux that provides the smartling
connector from Smartling:
http://docs.smartling.com/pages/Repository-Connector/Install-and-Setup/

This image is setup with a template configuration file. To use the
image, you must derive a new container from it and modify the template
configuration file to match your repo settings. The template uses
environment variables for credentials which are replaced with the actual
values from the environment at runtime (you can pass these in when
running the container with the -e option to run). You can also embed the
credentials directly in the template if you'd prefer.

Refer to smartling's configuration docs above for details regarding the
configuration file.

To properly shutdown the connector you should run the stop-connector.sh
script located in the image. You can do this with the following command
on a running connector container:

  `docker exec <CONTAINER_ID> ./stop-connector.sh`
