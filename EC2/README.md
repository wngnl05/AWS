##
```
#!/bin/bash
echo 'Port (포트 번호)' >> /etc/ssh/sshd_config
systemctl restart sshd
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo "<AMI 이름>:<비밀번호>" | chpasswd
systemctl restart sshd
```
<br>

## EC2 서버에서 keypair, password 2가지 보안을 적용할려면?
```
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
echo "<AMI 이름>:<비밀번호>" | chpasswd
systemctl restart sshd

echo "AuthenticationMethods publickey,password" >> /etc/ssh/sshd_config
systemctl restart sshd
```
```
ssh ec2-user@<퍼블릭 ip 주소> -p<포트 번호> -i"<키페어 파일 경로>"
```
