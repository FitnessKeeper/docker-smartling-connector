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

If you plan to use web hooks to get notifications from either github or
smartling (for repo changes or translation changes), you must expose
port 5555 on the container (with -p) and configure the webhooks in the
repo connector configuration. See the smartling configuration docs above
for details regarding configuring webhooks (in the advanced section).

Here is smartling's example configuration file including documentation
for optional settings:
http://docs.smartling.com/public/Example-Files/repo-connector-complete-example.conf#

AUTHOR NOTE: I've found all of smartling's docs to be fairly poor and/or
out of date. For the latest potential settings for the configuration,
look at the application.conf file embedded inside the repo connector jar
(repo-connector-<VERSION>.jar in the container image). That contains
defaults for all of the settings. Note that some of these settings are
defaults for the smartling-config.json file specific to a repository. Of
particular note, there is no documentation for the mergingStrategy
setting in here which defaults to LOCAL meaning in the event of a merge
conflict, the connector will blow away incoming changes (!!!!!). Change
this to "REMOTE" to have it blow away incoming translations instead.
Which will just get re-downloaded later. :-P

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

Useful URLs for the connector:
HOST - Configured host for callbacks (http section in config)
CALLBACK_PORT - Configured port for callbacks (http section in config)
http vs. https - Based on configuration in http section as well.
---
http(s)://<HOST>:<CALLBACK_PORT>/health - Shows connector health info.
http(s)://<HOST>:<CALLBACK_PORT>/health/db - Shows status of watched
files in all branches that we are monitoring.
