import json
import boto3
import os
from datetime import datetime

def handler(event, context):
    """
    Simple Lambda function that interacts with S3 and logs to CloudWatch
    """
    s3_client = boto3.client('s3')
    bucket_name = os.environ['BUCKET_NAME']
    
    try:
        # List objects in the bucket
        response = s3_client.list_objects_v2(Bucket=bucket_name)
        object_count = response.get('KeyCount', 0)
        
        # Create a test file in S3
        test_key = f"test-files/lambda-test-{datetime.now().strftime('%Y%m%d-%H%M%S')}.txt"
        test_content = f"Hello from Lambda! Timestamp: {datetime.now().isoformat()}"
        
        s3_client.put_object(
            Bucket=bucket_name,
            Key=test_key,
            Body=test_content,
            ContentType='text/plain'
        )
        
        print(f"Successfully created file: {test_key}")
        print(f"Bucket {bucket_name} now has {object_count + 1} objects")
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': f'Successfully connected to S3 bucket: {bucket_name}',
                'object_count': object_count + 1,
                'created_file': test_key,
                'environment': os.environ.get('ENVIRONMENT', 'unknown'),
                'timestamp': datetime.now().isoformat()
            })
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.now().isoformat()
            })
        }