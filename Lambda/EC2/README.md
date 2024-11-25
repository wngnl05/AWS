# Lambda Boto3로 EC2 Instance 생성하는 코드

```
import boto3

aws = boto3.Session()
ec2 = aws.resource('ec2', region_name="<>") # 현재 리전 이름


tags = [{'Key':'Name','Value': '<bastion-ec2>'}]

ec2_user_data = '''
#!/bin/bash
'''

instance = ec2.create_instances(
    IamInstanceProfile={'Name': "IAM 역활 이름"}, # IAM 역활 이름
    ImageId='<AMI Image ID>', # AMI Image ID
    InstanceType='t2.micro', # 인스턴스 타입

    UserData = f"{ec2_user_data}", # 사용자 데이터
	TagSpecifications = [{'ResourceType': 'instance', 'Tags': tags}], # 태그
    MinCount=1, # 최소
    MaxCount=1, # 최대
    
    NetworkInterfaces=[{
        'SubnetId': "<>", # 서브넷 ID
        'DeviceIndex': 0,
        'Groups':["<>"] # 보안그룹 ID
    }]
)

print(instance)
```
<br>

# Lambda 특정 태그를 가진 Instance 종료하기

Aws Ec2에서 생성한 Instance에 특정태그를 작성할 수 있습니다.
사용자가 특정태그에 해당하는 인스턴스를 파이썬으로 삭제하는 코드를 짜보겠습니다.

```
import boto3


region = "" # 리전 이름
key = "" # 태그 KEY
value = "" # 태그 VALUE


instances = []
ec2_r = boto3.resource('ec2', region_name=region)
ec2 = boto3.client('ec2', region_name=region)

for instance in ec2_r.instances.all(): # 특정 태그가 있는 인스턴스 id 가져오기
    for tag in instance.tags:
        if tag['Key'] == f'{key}': # Key
            if tag['Value'] == f'{value}': # Value
                instances.append(instance.id)


ec2.terminate_instances(InstanceIds = instances) # 인스턴스 id를 이용하여 인스터스 종료
print('stopped your instances: ' + str(instances))
```
ec2를 중지할려면?
ec2.stop_instances(InstanceIds=instances)

변수들을 상황에 맞게 작성하고 코드를 실행시키면 특정 태그가 있는 인스턴스들은 모두 종료가 됩니다.



