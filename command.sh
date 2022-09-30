#!/bin/bash
curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "inventory-connector",
    "config": {
        "connector.class": "io.debezium.connector.mysql.MySqlConnector",
        "tasks.max": "1",
        "database.hostname": "mysql",
        "database.port": "3306",
        "database.user": "debezium",
        "database.password": "dbz",
        "database.server.id": "184054",
        "database.server.name": "dbserver1",
        "database.include.list": "inventory",
        "database.history.kafka.bootstrap.servers": "kafka:9092",
        "database.history.kafka.topic": "dbhistory.inventory"
    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "customers",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://elasticsearch:9200",
        "tasks.max": "1",
        "topics": "dbserver1.inventory.customers",
        "name": "customers",
        "type.name": "listing",
        "key.ignore": "false",
        "behavior.on.null.values": "DELETE",
        "transforms": "SetDocumentId,SetValue",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"id",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after",
        "write.method": "UPSERT"
    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "httpsink",
  "config": {
    "connector.class": "io.confluent.connect.http.HttpSinkConnector",
    "topics": "dbserver1.inventory.addresses",
    "tasks.max": "1",
    "http.api.url": "http://elasticsearch:9200/dbserver1.inventory.customers/_update/${key}",
    "request.method": "POST",
    "request.body.format": "json",
    "batch.max.size": 1,
    "batch.json.as.array": false,
    "headers": "Content-Type:application/json",
    "confluent.topic.bootstrap.servers": "kafka:9092",
    "confluent.topic.replication.factor": "1",
    "reporter.bootstrap.servers": "kafka:9092",
    "reporter.result.topic.name": "success-responses",
    "reporter.result.topic.replication.factor": "1",
    "reporter.error.topic.name":"error-responses",
    "reporter.error.topic.replication.factor":"1",

    "transforms": "Flatten,CreateCustomerId,SetCustomerId,FixNullField,ValueToKey,ExtractField,CreateParams,CreateSource,CreateScript,CreateScriptedUpsert,CreateUpsertTimestamp,CreateUpsert",

    "transforms.Flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
    "transforms.Flatten.delimiter": ".",

    "transforms.CreateCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.DublicateField$Value",
    "transforms.CreateCustomerId.fields": "customer_id:after.customer_id",

    "transforms.SetCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.SetCustomerId.field": "customer_id",
    "transforms.SetCustomerId.field-value": "before.customer_id",

    "transforms.Cast.type": "org.apache.kafka.connect.transforms.Cast$Value",
    "transforms.Cast.spec": "customer_id:string",

    "transforms.FixNullField.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.FixNullField.static-value": "1:int32",
    "transforms.FixNullField.field": "customer_id",

    "transforms.ValueToKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
    "transforms.ValueToKey.fields": "customer_id",

    "transforms.ExtractField.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.ExtractField.field":"customer_id",

    "transforms.CreateParams.type": "org.apache.kafka.connect.transforms.HoistField$Value",
    "transforms.CreateParams.field": "params",

    "transforms.CreateSource.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.CreateSource.static.field": "source",
    "transforms.CreateSource.static.value": "if ( ctx.op == '\''create'\'' ) { if (params['\''after.id'\''] != null) { ctx._source.address_ids = [params['\''after.id'\'']]; ctx._source.streets = [params['\''after.street'\'']]; ctx._source.cities = [params['\''after.city'\'']]; ctx._source.states = [params['\''after.state'\'']]; ctx._source.zips = [params['\''after.zip'\'']]; ctx._source.types = [params['\''after.type'\'']]; } } else { if (params['\''before.id'\''] != null) { if (ctx._source.address_ids != null) { if (ctx._source.address_ids.contains(params['\''before.id'\''])) { ctx._source.streets.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); ctx._source.cities.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); ctx._source.states.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); ctx._source.zips.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); ctx._source.types.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); ctx._source.address_ids.remove(ctx._source.address_ids.indexOf(params['\''before.id'\''])); } } } if (params['\''after.id'\''] != null) { if (ctx._source.address_ids != null) { ctx._source.address_ids.add(params['\''after.id'\'']); ctx._source.streets.add(params['\''after.street'\'']); ctx._source.cities.add(params['\''after.city'\'']); ctx._source.states.add(params['\''after.state'\'']); ctx._source.zips.add(params['\''after.zip'\'']); ctx._source.types.add(params['\''after.type'\'']); } else if (params['\''after.id'\''] != null) { ctx._source.address_ids = [params['\''after.id'\'']]; ctx._source.streets = [params['\''after.street'\'']]; ctx._source.cities = [params['\''after.city'\'']]; ctx._source.states = [params['\''after.state'\'']]; ctx._source.zips = [params['\''after.zip'\'']]; ctx._source.types = [params['\''after.type'\'']]; } } }",

    "transforms.CreateScript.type": "com.kinhnv.app.kafka.connect.transforms.WrapField$Value",
    "transforms.CreateScript.wrap-field": "script",
    "transforms.CreateScript.fields": "source,params",

    "transforms.CreateScriptedUpsert.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.CreateScriptedUpsert.static.field": "scripted_upsert",
    "transforms.CreateScriptedUpsert.static.value": true,

    "transforms.CreateUpsertTimestamp.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.CreateUpsertTimestamp.timestamp.field": "timestamp",

    "transforms.CreateUpsert.type": "com.kinhnv.app.kafka.connect.transforms.WrapField$Value",
    "transforms.CreateUpsert.wrap-field": "upsert",
    "transforms.CreateUpsert.fields": "timestamp"
  }
}'