docker compose exec -T shard1-1 mongosh --port 27011 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 1
docker compose exec -T shard1-2 mongosh --port 27012 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 1
docker compose exec -T shard1-3 mongosh --port 27013 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 1
docker compose exec -T shard2-1 mongosh --port 27021 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 1
docker compose exec -T shard2-2 mongosh --port 27022 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
sleep 1
docker compose exec -T shard2-3 mongosh --port 27023 --quiet <<EOF
use somedb;
db.helloDoc.countDocuments();
exit();
EOF
cmd /k