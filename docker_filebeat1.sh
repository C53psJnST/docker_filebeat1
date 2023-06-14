


mkdir -p /data/elk/filebeat/log
mkdir -p /data/elk/filebeat/config
mkdir -p /var/log/test_dev/hello/log/app


###############################  可以各自连接各自的ES，不需要连接集群
tee /data/elk/filebeat/config/filebeat.yml <<-'EOF'

#filebeat自身日志配置
logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
  
# 日志输入配置（可配置多个）
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /var/log/test_dev/hello/log/app/*.log
  tags: ["gateway"]
  fields:
    server: 192.168.79.43 #自定义字段，用来区分的
  #fields_under_root: true

#日志输出配置
output.elasticsearch:
  #worker: 1
  #bulk_max_size: 1500
  hosts: ["192.168.79.43:9200"]
#  index: "pb-%{[fields.index_name]}-*"
#setup.template.name: "pb"
#setup.template.pattern: "pb-*"
#setup.ilm.enabled: false
  #indices:
  #  - index: "pb-nginx-%{+yyyy.MM.dd}"
  #    when.equals:
  #      fields.index_name: "nginx_log"
  #  - index: "pb-log4j-%{+yyyy.MM.dd}"
  #    when.equals:
  #      fields.index_name: "log4j_log"
  #  - index: "pb-biz-%{+yyyy.MM.dd}"
  #    when.equals:
  #      fields.index_name: "biz_log"

EOF


docker run -d --name FB \
-v /data/elk/test_dev/:/var/log/test_dev \
-v /data/elk/filebeat/log:/var/log/filebeat \
-v /data/elk/filebeat/config/filebeat.yml:/usr/share/filebeat/filebeat.yml \
elastic/filebeat:6.8.6


