aws ec2 create-key-pair --key-name KTWSTP_EC2_key --query 'KeyMaterial' --output text > KTWSTP_EC2_key.pem
chmod 400 KTWSTP_EC2_key.pem
