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

You may specify two environment variables to configure the java initial
heap size and java maximum heap size respectively,

JAVA_XMS - Initial java heap size. (default=1024M)
JAVA_XMX - Maximum java heap size. (default=3584M)

To properly shutdown the connector you should run the stop-connector.sh
script located in the image. You can do this with the following command
on a running connector container:

  `docker exec <CONTAINER_ID> ./stop-connector.sh`

The connector checks out all configured branches into a repository cache
directory in `/opt/repo-connector/cfg/repository-data`. This can be a
large amount of data if you monitor many branches so this is setup as a
volume to prevent it from taking a long time to checkout each branch
again if you make a new container. If you do not explicitly setup a
volume, an anonymous volume will be created for you on the instance.
