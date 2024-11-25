# Kinesis Stream에 레코드 전송하는 코드
```
json_data='{"name": "kayaya", "age": 17}'
aws kinesis put-record \
  --stream-name <스트림 이름> \
  --data "$(echo -n $json_data | base64)" \
  --partition-key "<내용>"
```
