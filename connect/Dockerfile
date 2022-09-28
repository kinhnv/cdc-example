FROM quay.io/debezium/connect:1.9
WORKDIR /kafka/connect
COPY kinhnv /kafka/connect/kinhnv
RUN curl -o confluentinc-kafka-connect-elasticsearch-14.0.0.zip https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-elasticsearch/versions/14.0.0/confluentinc-kafka-connect-elasticsearch-14.0.0.zip
RUN unzip confluentinc-kafka-connect-elasticsearch-14.0.0.zip
RUN curl -o confluentinc-kafka-connect-http-1.5.5.zip https://d1i4a15mxbxib1.cloudfront.net/api/plugins/confluentinc/kafka-connect-http/versions/1.5.5/confluentinc-kafka-connect-http-1.5.5.zip
RUN unzip confluentinc-kafka-connect-http-1.5.5.zip
WORKDIR /kafka