# S3에서 이벤트 발생시 람다를 이용해서 CloudFront 무효화 하기
```
import datetime
import boto3

def lambda_handler(event, context):

    aws_region = '<리전 이름>'
    distribution_id = '<CloudFront ID>'
    
    # 무효화할 경로 또는 파일
    paths_to_invalidate = ['/*']  # 무효화 경로
    
    # Boto3 클라이언트 생성
    cf_client = boto3.client('cloudfront', region_name=aws_region)
    korea_time = datetime.datetime.now() + datetime.timedelta(hours=9)
    korea_time_str = korea_time.strftime("%Y-%m-%d %H:%M:%S")
    
    # 원본 무효화 요청 생성
    invalidation_response = cf_client.create_invalidation(
        DistributionId=distribution_id,
        InvalidationBatch={
            'Paths': {
                'Quantity': len(paths_to_invalidate),
                'Items': paths_to_invalidate
            },
            'CallerReference': korea_time_str  # 고유한 무효화 참조값 ( 한국 시간 )
        }
    )
    
    # 무효화 상태 확인
    invalidation_id = invalidation_response['Invalidation']['Id']
    print(f'Invalidation ID: {invalidation_i
```
