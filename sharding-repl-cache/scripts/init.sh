docker compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate(
  {
    _id : "config_server",
       configsvr: true,
    members: [
      { _id : 0, host : "configSrv:27017" }
    ]
  }
);
exit();
EOF
sleep 1;
docker compose exec -T shard1-1 mongosh --port 27011 --quiet <<EOF
rs.initiate(
    {
      _id : "shard1",
      members: [
        { _id : 0, host : "shard1-1:27011" },
        { _id : 1, host : "shard1-2:27012" },
        { _id : 2, host : "shard1-3:27013" }
      ]
    }
);
exit();
EOF
sleep 1;
docker compose exec -T shard2-1 mongosh --port 27021 --quiet <<EOF
rs.initiate(
    {
      _id : "shard2",
      members: [
        { _id : 0, host : "shard2-1:27021" },
        { _id : 1, host : "shard2-2:27022" },
        { _id : 2, host : "shard2-3:27023" }
      ]
    }
);
exit();
EOF
sleep 1;
docker compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF
sh.addShard("shard1/shard1-1:27011");
sh.addShard("shard1/shard1-2:27012");
sh.addShard("shard1/shard1-3:27013");
sh.addShard("shard2/shard2-1:27021");
sh.addShard("shard2/shard2-2:27022");
sh.addShard("shard2/shard2-3:27023");
sh.enableSharding("somedb");
use somedb
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i});
sleep 1;
db.helloDoc.countDocuments();
exit();
EOF
cmd /k