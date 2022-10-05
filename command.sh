curl --location --request PUT 'http://elastic:khhng6GXunlcHV06bwRg@172.16.6.227:9200/bds_2020_all_cdc?include_type_name=true' \
--header 'Content-Type: application/json' \
--data-raw '{
  "settings": {
    "index": {
      "max_result_window": "500000",
      "number_of_shards": "4",
      "number_of_replicas": "2"
    }
  },
  "mappings": {
    "product_publish": {
      "properties": {
        "TextSearch": {
          "term_vector": "yes",
          "type": "text"
        },
        "Description": {
          "term_vector": "yes",
          "type": "text"
        },
        "Title": {
          "term_vector": "yes",
          "type": "text"
        },
        "CityCode": {
          "type": "text",
          "fielddata": true
        }
      }
    }
  }
} '

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "ohan-c1msql-agro.bds.lc-connector",
    "config": {
        "connector.class" : "io.debezium.connector.sqlserver.SqlServerConnector",
        "tasks.max" : "1",
        "database.server.name" : "server1",
        "database.hostname" : "ohan-c1msql-agrw.bds.lc",
        "database.port" : "1433",
        "database.user" : "foreveralone18",
        "database.password" : "matkhaulacaigi@#$%",
        "database.dbname" : "DVS3_3_20170717",
        "table.include.list": "dbo.ProductPublish,dbo.ProductImages,dbo.ProductImage360s,dbo.ProductMatterPorts,dbo.ProductContacts,dbo.ProductMatterPorts,dbo.ProductOthers,dbo.ProductTags,dbo.AgentProfiles",
        "database.history.kafka.bootstrap.servers" : "kafka:9092",
        "database.history.kafka.topic": "ohan-c1msql-agro.bds.lc.inventory"
    }
 }'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "product_publish",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://172.16.6.227:9200",
        "connection.username": "elastic",
        "connection.password": "khhng6GXunlcHV06bwRg",
        "tasks.max": "1",
        "topics": "server1.dbo.ProductPublish",
        "type.name": "listing",
        "key.ignore": "false",
        "flush.synchronously": "true",
        "behavior.on.null.values": "DELETE",
        "write.method": "UPSERT",
        "transforms": "RenameIndex,SetDocumentId,SetValue,TitleEmptyToNull,DescriptionEmptyToNull,ProductAliasEmptyToNull",
        "transforms.RenameIndex.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameIndex.regex": ".*",
        "transforms.RenameIndex.replacement": "bds_2020_all_cdc",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"ProductId",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after",
        "transforms.TitleEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.TitleEmptyToNull.field": "Title",
        "transforms.TitleEmptyToNull.ignore.null": true,
        "transforms.TitleEmptyToNull.condition": "== :string",
        "transforms.TitleEmptyToNull.else-field-value": "Title",
        "transforms.DescriptionEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.DescriptionEmptyToNull.field": "Description",
        "transforms.DescriptionEmptyToNull.ignore.null": true,
        "transforms.DescriptionEmptyToNull.condition": "== :string",
        "transforms.DescriptionEmptyToNull.else-field-value": "Description",
        "transforms.ProductAliasEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.ProductAliasEmptyToNull.field": "ProductAlias",
        "transforms.ProductAliasEmptyToNull.ignore.null": true,
        "transforms.ProductAliasEmptyToNull.condition": "== :string",
        "transforms.ProductAliasEmptyToNull.else-field-value": "ProductAlias"
    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "product_contacts",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://172.16.6.227:9200",
        "connection.username": "elastic",
        "connection.password": "khhng6GXunlcHV06bwRg",
        "tasks.max": "1",
        "topics": "server1.dbo.ProductContacts",
        "name": "product_contacts",
        "type.name": "listing",
        "key.ignore": "false",
        "flush.synchronously": "true",
        "behavior.on.null.values": "IGNORE",
        "write.method": "UPSERT",
        "transforms": "RenameIndex,SetDocumentId,SetValue,RenameField,ContactNameEmptyToNull,ContactAddressEmptyToNull,PhoneEmptyToNull,ContactMobileToNull,EmailToNull,YahooToNull,SkypeEmptyToNull",
        "transforms.RenameIndex.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameIndex.regex": ".*",
        "transforms.RenameIndex.replacement": "bds_2020_all_cdc",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"ProductId",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after",
        "transforms.RenameField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.RenameField.renames": "Name:ContactName,Mobile:ContactMobile,Address:ContactAddress",
        "transforms.ContactNameEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.ContactNameEmptyToNull.field": "ContactName",
        "transforms.ContactNameEmptyToNull.ignore.null": true,
        "transforms.ContactNameEmptyToNull.condition": "== :string",
        "transforms.ContactNameEmptyToNull.else-field-value": "ContactName",
        "transforms.ContactAddressEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.ContactAddressEmptyToNull.field": "ContactAddress",
        "transforms.ContactAddressEmptyToNull.ignore.null": true,
        "transforms.ContactAddressEmptyToNull.condition": "== :string",
        "transforms.ContactAddressEmptyToNull.else-field-value": "ContactAddress",
        "transforms.PhoneEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.PhoneEmptyToNull.field": "Phone",
        "transforms.PhoneEmptyToNull.ignore.null": true,
        "transforms.PhoneEmptyToNull.condition": "== :string",
        "transforms.PhoneEmptyToNull.else-field-value": "Phone",
        "transforms.ContactMobileToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.ContactMobileToNull.field": "ContactMobile",
        "transforms.ContactMobileToNull.ignore.null": true,
        "transforms.ContactMobileToNull.condition": "== :string",
        "transforms.ContactMobileToNull.else-field-value": "ContactMobile",
        "transforms.EmailToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.EmailToNull.field": "Email",
        "transforms.EmailToNull.ignore.null": true,
        "transforms.EmailToNull.condition": "== :string",
        "transforms.EmailToNull.else-field-value": "Email",
        "transforms.YahooToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.YahooToNull.field": "Yahoo",
        "transforms.YahooToNull.ignore.null": true,
        "transforms.YahooToNull.condition": "== :string",
        "transforms.YahooToNull.else-field-value": "Yahoo",
        "transforms.SkypeEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.SkypeEmptyToNull.field": "Skype",
        "transforms.SkypeEmptyToNull.ignore.null": true,
        "transforms.SkypeEmptyToNull.condition": "== :string",
        "transforms.SkypeEmptyToNull.else-field-value": "Skype"

    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "product_tags",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://172.16.6.227:9200",
        "connection.username": "elastic",
        "connection.password": "khhng6GXunlcHV06bwRg",
        "tasks.max": "1",
        "topics": "server1.dbo.ProductTags",
        "name": "product_tags",
        "type.name": "listing",
        "key.ignore": "false",
        "flush.synchronously": "true",
        "write.method": "UPSERT",
        "behavior.on.null.values": "IGNORE",
        "transforms": "RenameIndex,SetValue,ValueToKey,SetDocumentId,ReplaceField,TagsEmptyToNull,KeywordsEmptyToNull,TagsAliasEmptyToNull",
        "transforms.RenameIndex.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameIndex.regex": ".*",
        "transforms.RenameIndex.replacement": "bds_2020_all_cdc",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after",
        "transforms.ValueToKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
        "transforms.ValueToKey.fields": "ProductId",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"ProductId",
        "transforms.ReplaceField.type": "org.apache.kafka.connect.transforms.ReplaceField$Value",
        "transforms.ReplaceField.blacklist": "Id",
        "transforms.TagsEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.TagsEmptyToNull.field": "Tags",
        "transforms.TagsEmptyToNull.ignore.null": true,
        "transforms.TagsEmptyToNull.condition": "== :string",
        "transforms.TagsEmptyToNull.else-field-value": "Tags",
        "transforms.KeywordsEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.KeywordsEmptyToNull.field": "Keywords",
        "transforms.KeywordsEmptyToNull.ignore.null": true,
        "transforms.KeywordsEmptyToNull.condition": "== :string",
        "transforms.KeywordsEmptyToNull.else-field-value": "Keywords",
        "transforms.TagsAliasEmptyToNull.type": "com.kinhnv.app.kafka.connect.transforms.IfHandlerField$Value",
        "transforms.TagsAliasEmptyToNull.field": "TagsAlias",
        "transforms.TagsAliasEmptyToNull.ignore.null": true,
        "transforms.TagsAliasEmptyToNull.condition": "== :string",
        "transforms.TagsAliasEmptyToNull.else-field-value": "TagsAlias"

    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "product_matter_ports",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://172.16.6.227:9200",
        "connection.username": "elastic",
        "connection.password": "khhng6GXunlcHV06bwRg",
        "tasks.max": "1",
        "topics": "server1.dbo.ProductMatterPorts",
        "name": "product_matter_ports",
        "key.ignore": "false",
        "flush.synchronously": "true",
        "write.method": "UPSERT",
        "behavior.on.null.values": "IGNORE",
        "transforms": "RenameIndex,SetDocumentId,SetValue",
        "transforms.RenameIndex.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameIndex.regex": ".*",
        "transforms.RenameIndex.replacement": "bds_2020_all_cdc",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"ProductId",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after"

    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "product_others",
    "config": {
        "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
        "connection.url": "http://172.16.6.227:9200",
        "connection.username": "elastic",
        "connection.password": "khhng6GXunlcHV06bwRg",
        "tasks.max": "1",
        "topics": "server1.dbo.ProductOthers",
        "name": "product_others",
        "key.ignore": "false",
        "flush.synchronously": "true",
        "write.method": "UPSERT",
        "behavior.on.null.values": "IGNORE",
        "transforms": "RenameIndex,SetDocumentId,SetValue",
        "transforms.RenameIndex.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.RenameIndex.regex": ".*",
        "transforms.RenameIndex.replacement": "bds_2020_all_cdc",
        "transforms.SetDocumentId.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
        "transforms.SetDocumentId.field":"ProductId",
        "transforms.SetValue.type":"org.apache.kafka.connect.transforms.ExtractField$Value",
        "transforms.SetValue.field": "after"

    }
}'

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "product_images",
  "config": {
    "connector.class": "io.confluent.connect.http.HttpSinkConnector",
    "topics": "server1.dbo.ProductImages",
    "tasks.max": "10",
    "http.api.url": "http://elastic:khhng6GXunlcHV06bwRg@172.16.6.227:9200/bds_2020_all_cdc/_update/${key}",
    "request.method": "POST",
    "request.body.format": "json",
    "batch.max.size": 1,
    "batch.json.as.array": false,
    "headers": "Content-Type:application/json",
    "confluent.topic.bootstrap.servers": "kafka:9092",
    "confluent.topic.replication.factor": "1",
    "reporter.bootstrap.servers": "kafka:9092",
    "reporter.result.topic.name": "product_images.success-responses",
    "reporter.result.topic.replication.factor": "1",
    "reporter.error.topic.name":"product_images.error-responses",
    "reporter.error.topic.replication.factor":"1",

    "transforms": "Flatten,CreateCustomerId,SetCustomerId,FixNullField,ValueToKey,ExtractField,CreateParams,CreateSource,CreateScript,CreateScriptedUpsert,CreateUpsertTimestamp,CreateUpsert",

    "transforms.Flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
    "transforms.Flatten.delimiter": ".",

    "transforms.CreateCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.DublicateField$Value",
    "transforms.CreateCustomerId.fields": "ProductId:after.ProductId",

    "transforms.SetCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.SetCustomerId.field": "ProductId",
    "transforms.SetCustomerId.field-value": "before.ProductId",

    "transforms.FixNullField.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.FixNullField.static-value": "1:int32",
    "transforms.FixNullField.field": "ProductId",

    "transforms.ValueToKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
    "transforms.ValueToKey.fields": "ProductId",

    "transforms.ExtractField.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.ExtractField.field":"ProductId",

    "transforms.CreateParams.type": "org.apache.kafka.connect.transforms.HoistField$Value",
    "transforms.CreateParams.field": "params",

    "transforms.CreateSource.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.CreateSource.static.field": "source",
    "transforms.CreateSource.static.value": "if (ctx.op == '\''create'\'') { if (params['\''after.FileId'\''] != null) { ctx._source.FileIdImg = [params['\''after.FileId'\'']]; ctx._source.OrderImg = [params['\''after.Order'\'']]; } } else { if (params['\''before.FileId'\''] != null) { if (ctx._source.FileIdImg != null) { if (ctx._source.FileIdImg.contains(params['\''before.FileId'\''])) { ctx._source.OrderImg.remove(ctx._source.FileIdImg.indexOf(params['\''before.FileId'\''])); ctx._source.FileIdImg.remove(ctx._source.FileIdImg.indexOf(params['\''before.FileId'\''])); } } } if (params['\''after.FileId'\''] != null) { if (ctx._source.FileIdImg != null) { ctx._source.FileIdImg.add(params['\''after.FileId'\'']); ctx._source.OrderImg.add(params['\''after.Order'\'']); } else if (params['\''after.FileId'\''] != null) { ctx._source.FileIdImg = [params['\''after.FileId'\'']]; ctx._source.OrderImg = [params['\''after.Order'\'']]; } } }",

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

curl --location --request POST 'http://connect:8083/connectors/' \
--header 'Content-Type: application/json' \
--data-raw '{
  "name": "product_image_360s",
  "config": {
    "connector.class": "io.confluent.connect.http.HttpSinkConnector",
    "topics": "server1.dbo.ProductImage360s",
    "tasks.max": "1",
    "http.api.url": "http://elastic:khhng6GXunlcHV06bwRg@172.16.6.227:9200/bds_2020_all_cdc/_update/${key}",
    "request.method": "POST",
    "request.body.format": "json",
    "batch.max.size": 1,
    "batch.json.as.array": false,
    "headers": "Content-Type:application/json",
    "confluent.topic.bootstrap.servers": "kafka:9092",
    "confluent.topic.replication.factor": "1",
    "reporter.bootstrap.servers": "kafka:9092",
    "reporter.result.topic.name": "product_images.success-responses",
    "reporter.result.topic.replication.factor": "1",
    "reporter.error.topic.name":"product_images.error-responses",
    "reporter.error.topic.replication.factor":"1",

    "transforms": "Flatten,CreateCustomerId,SetCustomerId,FixNullField,ValueToKey,ExtractField,CreateParams,CreateSource,CreateScript,CreateScriptedUpsert,CreateUpsertTimestamp,CreateUpsert",

    "transforms.Flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
    "transforms.Flatten.delimiter": ".",

    "transforms.CreateCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.DublicateField$Value",
    "transforms.CreateCustomerId.fields": "ProductId:after.ProductId",

    "transforms.SetCustomerId.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.SetCustomerId.field": "ProductId",
    "transforms.SetCustomerId.field-value": "before.ProductId",

    "transforms.FixNullField.type": "com.kinhnv.app.kafka.connect.transforms.FixNullField$Value",
    "transforms.FixNullField.static-value": "1:int32",
    "transforms.FixNullField.field": "ProductId",

    "transforms.ValueToKey.type": "org.apache.kafka.connect.transforms.ValueToKey",
    "transforms.ValueToKey.fields": "ProductId",

    "transforms.ExtractField.type":"org.apache.kafka.connect.transforms.ExtractField$Key",
    "transforms.ExtractField.field":"ProductId",

    "transforms.CreateParams.type": "org.apache.kafka.connect.transforms.HoistField$Value",
    "transforms.CreateParams.field": "params",

    "transforms.CreateSource.type": "org.apache.kafka.connect.transforms.InsertField$Value",
    "transforms.CreateSource.static.field": "source",
    "transforms.CreateSource.static.value": "if (ctx.op == '\''create'\'') { if (params['\''after.FileId'\''] != null) { ctx._source.FileIdImg360 = [params['\''after.FileId'\'']]; ctx._source.Caption = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Caption'\''] == null ? '\'''\'' : params['\''after.Caption'\''])]; ctx._source.Top = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Top'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Top'\'']))]; ctx._source.Right = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Right'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Right'\'']))]; ctx._source.Bottom = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Bottom'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Bottom'\'']))]; ctx._source.Left = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Left'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Left'\'']))]; ctx._source.OrderImg360 = [params['\''after.Order'\'']]; } } else { if (params['\''before.FileId'\''] != null) { if (ctx._source.FileIdImg360 != null) { if (ctx._source.FileIdImg360.contains(params['\''before.FileId'\''])) { ctx._source.Caption.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.Top.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.Right.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.Bottom.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.Left.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.OrderImg360.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); ctx._source.FileIdImg360.remove(ctx._source.FileIdImg360.indexOf(params['\''before.FileId'\''])); } } } if (params['\''after.FileId'\''] != null) { if (ctx._source.FileIdImg360 != null) { ctx._source.FileIdImg360.add(params['\''after.FileId'\'']); ctx._source.Caption.add((params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Caption'\''] == null ? '\'''\'' : params['\''after.Caption'\''])); ctx._source.Top.add((params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Top'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Top'\'']))); ctx._source.Right.add((params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Right'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Right'\'']))); ctx._source.Bottom.add((params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Bottom'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Bottom'\'']))); ctx._source.Left.add((params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Left'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Left'\'']))); ctx._source.OrderImg360.add(params['\''after.Order'\'']); } else if (params['\''after.FileId'\''] != null) { ctx._source.FileIdImg360 = [params['\''after.FileId'\'']]; ctx._source.Caption = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Caption'\''] == null ? '\'''\'' : params['\''after.Caption'\''])]; ctx._source.Top = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Top'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Top'\'']))]; ctx._source.Right = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Right'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Right'\'']))]; ctx._source.Bottom = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Bottom'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Bottom'\'']))]; ctx._source.Left = [(params['\''after.Order'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Order'\''])) + '\''.'\'' + (params['\''after.Left'\''] == null ? '\'''\'' : Integer.toString(params['\''after.Left'\'']))]; ctx._source.OrderImg360 = [params['\''after.Order'\'']]; } } }",

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