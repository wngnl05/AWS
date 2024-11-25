# Docker에서 Golang 실행하기
```
RUN go mod init <파일 이름>.go
RUN go get
RUN go build -o <이미지 이름>
```
<br>

```
# Go 어플리케이션을 빌드하는 데 사용할 베이스 이미지를 선택합니다.
FROM golang:latest
# 컨테이너 내부의 작업 디렉토리를 설정합니다.
WORKDIR /app
# 호스트의 모든 파일을 컨테이너의 /app 디렉토리로 복사합니다.
COPY . .
# curl을 설치합니다.
RUN apt-get update && apt-get install -y curl

# 애플리케이션을 실행합니다.
CMD ["./<이미지 이름>"]
```
