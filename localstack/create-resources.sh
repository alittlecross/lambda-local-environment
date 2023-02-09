# variable names

ENDPOINT=http://localhost:4566
REGION=eu-west-2

DEAD_LETTER_QUEUE_NAME=MY-DLQ
QUEUE_NAME=MY-Q
TOPIC_NAME=MY-T

ROLE_NAME=admin-role

BUCKET_NAME=lambda-functions

LAMBDA_NAME=MY-LAMBDA
ZIP_NAME=lambda.zip
HANDLER_NAME=index.handler

echo "〽️ ----- Creating resources -----"

echo "〽️ ----- Creating SQS queue ${DEAD_LETTER_QUEUE_NAME} -----"
aws sqs create-queue \
  --endpoint-url ${ENDPOINT} \
  --queue-name ${DEAD_LETTER_QUEUE_NAME}
echo "💯 ----- Created SQS queue ${DEAD_LETTER_QUEUE_NAME} -----"

echo "〽️ ----- Creating SQS queue ${QUEUE_NAME} -----"
aws sqs create-queue \
  --endpoint-url ${ENDPOINT} \
  --queue-name ${QUEUE_NAME} \
  --attributes '{"RedrivePolicy":"{\"deadLetterTargetArn\":\"'"arn:aws:sqs:${REGION}:000000000000:${DEAD_LETTER_QUEUE_NAME}"'\",\"maxReceiveCount\":\"3\"}"}'
echo "💯 ----- Created SQS queue ${QUEUE_NAME} -----"

echo "〽️ ----- Creating SNS Topic ${TOPIC_NAME} -----"
aws sns create-topic \
  --endpoint-url ${ENDPOINT} \
  --name ${TOPIC_NAME}
echo "💯 ----- Created SNS Topic ${TOPIC_NAME} -----"

echo "〽️ ----- Subscribing ${QUEUE_NAME} to ${TOPIC_NAME} -----"
aws sns subscribe \
  --endpoint-url ${ENDPOINT} \
  --topic-arn arn:aws:sns:${REGION}:000000000000:${TOPIC_NAME} \
  --protocol sqs \
  --notification-endpoint arn:aws:sqs:${REGION}:000000000000:${QUEUE_NAME}
echo "💯 ----- Subscribed ${QUEUE_NAME} to ${TOPIC_NAME} -----"

echo "〽️ ----- Creating role ${ROLE_NAME} -----"
aws iam create-role \
  --endpoint-url ${ENDPOINT} \
  --role-name ${ROLE_NAME} \
  --path / \
  --assume-role-policy-document file:./admin-policy.json
echo "💯 ----- Created role ${ROLE_NAME} -----"

echo "〽️ ----- Making S3 bucket ${BUCKET_NAME} -----"
aws s3 mb s3://${BUCKET_NAME} \
  --endpoint-url ${ENDPOINT}
echo "💯 ----- Made S3 bucket ${BUCKET_NAME} -----"
  
echo "〽️ ----- Copying ${ZIP_NAME} to S3 bucket ${BUCKET_NAME} -----"
aws s3 cp ${ZIP_NAME} s3://${BUCKET_NAME} \
  --endpoint-url ${ENDPOINT}
echo "💯 ----- Copied ${ZIP_NAME} to S3 bucket ${BUCKET_NAME} -----"

echo "〽️ ----- Creating lambda ${LAMBDA_NAME} -----"
aws lambda create-function \
  --endpoint-url ${ENDPOINT} \
  --function-name ${LAMBDA_NAME} \
  --role arn:aws:iam::000000000000:role/${ROLE_NAME} \
  --code S3Bucket=${BUCKET_NAME},S3Key=${ZIP_NAME} \
  --handler ${HANDLER_NAME} \
  --runtime nodejs10.x \
  --description "SQS Lambda handler (${LAMBDA_NAME}) for ${QUEUE_NAME} sqs" \
  --timeout 60 \
  --memory-size 128
echo "💯 ----- Created lambda ${LAMBDA_NAME} -----"

echo "〽️ ----- Mapping ${LAMBDA_NAME} to ${QUEUE_NAME} -----"
aws lambda create-event-source-mapping \
  --endpoint-url ${ENDPOINT} \
  --function-name ${LAMBDA_NAME} \
  --batch-size 10 \
  --event-source-arn "arn:aws:sqs:${REGION}:000000000000:${QUEUE_NAME}"
echo "💯 ----- Mapping ${LAMBDA_NAME} to ${QUEUE_NAME} -----"

echo "💯 ----- Resources created -----"
