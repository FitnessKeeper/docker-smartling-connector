# docker-smartling-connector
A docker image based on openjdk alpine linux that provides the smartling
connector from Smartling:
http://docs.smartling.com/pages/Repository-Connector/Install-and-Setup/

To use this image, you must create your configuration file in
/opt/repo-connector/repo-connector.conf per smartling's installation
documentation above. In addition, you must also create the configuration
files in the connected repositories per the documentation above. This is
easiest to do by setting this image as your base image and just copying
your configuration file in as a new file in the derived image.
