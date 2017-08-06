#!/bin/bash
mkdir -p /root/.ssh
cp $SSH_ID_RSA /root/.ssh/id_rsa
cp $SSH_ID_RSA_PUB /root/.ssh/id_rsa.pub
redis-server /etc/redis/redis.conf

mongod --fork --dbpath $MONGODB_DATA_DIR --logpath /var/log/mongodb.log
sleep 3
mongo --eval "db = db.getSiblingDB('$FH_LOCAL_DB_NAME');"

export 
for i in $COLLECTIONS; do
    echo  "db.createCollection('${FH_LOCAL_COLLECTION_PREFIX}_$i');"
    mongo --eval "db = db.getSiblingDB('FH_LOCAL'); db.createCollection('${FH_LOCAL_COLLECTION_PREFIX}_$i');"
done
#tail -f /var/log/mongodb.log
#mongo --eval 'db = db.getSiblingDB("FH_LOCAL"); db.createCollection("new_collection");  db.createCollection("fh_NO_APPNAME-DEFINED_claims");'
bash
