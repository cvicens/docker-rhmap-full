# [START all]
FROM node:6.11

# Import the public key used by the package management system.
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
# This option works even behid a proxy, hkp:// doesn't work usually behind a proxy
RUN wget -O- "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xEA312927" | apt-key add -

# Create a list file for MongoDB.
#RUN echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.4.list
RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# Packages
RUN apt-get update && apt-get install -y \
  libaio1 \
  curl \
  xz-utils \
  unzip \
  mongodb-org \
  redis-server

# Install FHC
RUN npm install -g fh-fhc
RUN npm install -g grunt-cli
RUN npm install -g ionic

# FH mongodb name
ENV FH_LOCAL_DB_NAME FH_LOCAL
ENV FH_LOCAL_COLLECTION_PREFIX fh_NO-APPNAME-DEFINED

# Create app directory
RUN mkdir -p /usr/projects
WORKDIR /usr/projects

# Dir for mongodb data
ENV MONGODB_DATA_DIR /root/data/db/
RUN mkdir -p $MONGODB_DATA_DIR

## Init using entrypoint
RUN mkdir /docker-entrypoint-init.d
ADD init.sh /docker-entrypoint-init.d/
RUN ["chmod", "+x", "/docker-entrypoint-init.d/init.sh"]
ENTRYPOINT /docker-entrypoint-init.d/init.sh
#CMD /docker-entrypoint-init.d/init.sh

# [END all]