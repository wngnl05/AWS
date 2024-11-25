#!/bin/bash

echo "현재 실행 중인 Docker 컨테이너 pid 확인"
CURRENT_PID=$(sudo docker container ls -q)
if [ -z $CURRENT_PID ]
then
  echo "현재 구동중인 Docker 컨테이너가 없으므로 종료하지 않습니다."
else
  echo "sudo docker stop $CURRENT_PID"   # 현재 구동중인 Docker 컨테이너가 있다면 모두 중지
  sudo docker stop $CURRENT_PID
  sleep 5
fi

# <IMAGE_TAG> 는 buildspec.yml에서 자동으로 설정합니다.
ECR_URL="<ECR URL>"
<ECR 인증 명령어>
docker pull $ECR_URL:<IMAGE_TAG>
docker run -d -p 80:8080 $ECR_URL:<IMAGE_TAG>
