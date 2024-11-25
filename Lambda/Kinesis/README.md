# KinesisFirehose & Lambda를 이용한 레코드 변환
```
import base64
import json
from datetime import datetime, timedelta



def lambda_handler(event, context):
    # 현재 날짜&시간
    now = datetime.today()
    now = now + timedelta(hours=9)
    year = now.year
    month = now.month
    day = now.day
    hour = now.hour
    minute = now.minute
    date = f"{year} {month}/{day} {hour}:{minute}"
    # 현재 날짜&시간
    
    output = []
    for record in event['records']:
        message = json.loads(base64.b64decode(record['data']))
        # 반환할 데이터
        return_data = {
                'date': date,
                'my_name': message['name'],
                'my_age': message['age']
            }
        # JSON 데이터를 bytes로 변환하여 Base64 인코딩
        return_data = base64.b64encode(json.dumps(return_data).encode('utf-8')).decode('utf-8')
        output_record = {
                'recordId': record['recordId'],
                'result': 'Ok',
                'data': return_data
        }
        output.append(output_record)

    return {'records': output}
```
