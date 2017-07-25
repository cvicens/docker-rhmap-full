#!/bin/bash
mkdir -p /root/.ssh
cp $SSH_ID_RSA /root/.ssh/id_rsa
cp $SSH_ID_RSA_PUB /root/.ssh/id_rsa.pub
redis-server /etc/redis/redis.conf
mongod --dbpath $MONGODB_DATA_DIR &
bash
