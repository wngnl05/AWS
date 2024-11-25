# MySQL
데이터베이스 모듈 설치
```
sudo yum install mariadb105 -y
```
데이터베이스 접속
```
mysql -h <RDS 앤드포인트> -u <사용자 이름> -p
```

<br>

# PostgreSQL
데이터베이스 모듈 설치
```
sudo yum install postgresql -y
```
데이터베이스 접속
```
psql -h <RDS 앤드포인트> -u <사용자 이름> -p
```
