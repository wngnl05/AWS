[**Install Module**](https://docs.aws.amazon.com/ko_kr/codedeploy/latest/userguide/codedeploy-agent-operations-install-linux.html)

```
wget https://aws-codedeploy-ap-northeast-2.s3.ap-northeast-2.amazonaws.com/latest/install
chmod +x ./install
sudo yum install ruby -y
sudo ./install auto
```

**Check**

```
sudo systemctl start codedeploy-agent
systemctl status codedeploy-agent
```

[**블로그**](https://velog.io/@sussa3007/AWS-%EB%B0%B0%ED%8F%AC-%EC%9E%90%EB%8F%99%ED%99%94-%ED%8C%8C%EC%9D%B4%ED%94%84%EB%9D%BC%EC%9D%B8-%EA%B5%AC%EC%B6%95)

Ec2 & CodeDeploy 역활 신뢰 정책

역활을 생성하고 EC2와 CodeDeploy에 연결해주세요.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "codedeploy.ap-northeast-2.amazonaws.com",
                    "ec2.amazonaws.com"
                ]
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
```

[**Down File**](https://github.com/wngnl-dev/AWS/tree/main/CICD/EC2_Deploy)

Dockerfile, appspec.yaml, buildspec.yaml, ec2\_deploy.sh 를 수정해줍니다.

```
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/CICD/EC2_Deploy/Dockerfile
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/CICD/EC2_Deploy/appspec.yml
wget https://raw.githubusercontent.com/wngnl-dev/AWS/main/CICD/EC2_Deploy/buildspec.yml
mkdir script
wget -O script/ec2_deploy.sh https://raw.githubusercontent.com/wngnl-dev/AWS/main/CICD/EC2_Deploy/script/ec2_deploy.sh
```

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-27(1).png">
<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-27(2).png">

\- **CodeDeploy** 모두 **온프레미스 인스턴스**를 선택해줍니다.

<img src="https://github.com/wngnl-dev/AWS/blob/main/Image/2024-07-27(3).png">

\- **CodePipeline** 

이제 파이프라인이 구동되면 CodeBuild에서 Docker Image를 생성하여 Commit ID로 ECR

에 업로드 하고 CodeDeplpoy에서 appspec.yml과 ec2\_deploy.sh를 이용해서 EC2의 도커 이미지를

업로드 해줍니다.
