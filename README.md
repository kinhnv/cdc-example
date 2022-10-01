# cdc-example

## Chạy Demo
docker-compose up
## Phạm vi Demo
Demo sẽ đồng bộ 2 bảng cuscomters và addresses vào index dbserver1.inventory.customers
## Các connect được xử dụng
- Sử dụng Debezium MySQL Source để lấy thay đổi trong mysql: https://docs.confluent.io/kafka-connectors/debezium-mysql-source/current/overview.html#debezium-mysql-source-connector-for-cp
- Sử dụng Elasticsearch Service Sink để đồng bộ thay đổi từ table customers trong mysql => es: https://docs.confluent.io/kafka-connectors/elasticsearch/current/overview.html
- Sử dụng HTTP Sink để đồng bộ thay đổi từ table addresses trong mysql => es: https://docs.confluent.io/kafka-connectors/http/current/overview.html
## Các site hỗ trợ:
- kafka-ui: localhost:8080
- phpmyadmin: localhost:8088
- kibana: localhost:5601
