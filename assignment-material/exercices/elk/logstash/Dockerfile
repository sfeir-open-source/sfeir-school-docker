FROM openjdk:8

WORKDIR /logstash

#ADD https://artifacts.elastic.co/downloads/logstash/logstash-6.4.2.tar.gz .

RUN    wget -q https://artifacts.elastic.co/downloads/logstash/logstash-6.4.2.tar.gz \
    && tar -xzf logstash-6.4.2.tar.gz \
    && rm logstash-6.4.2.tar.gz

#RUN ls -l /logstash && ls /logstash/logstash-6.4.2

WORKDIR /logstash/logstash-6.4.2

COPY logstash.conf config/logstash.conf

CMD bin/logstash -f config/logstash.conf
