# variable names

ENDPOINT=http://localhost:4566
REGION=eu-west-2

DEAD_LETTER_QUEUE_NAME=MY-DLQ
QUEUE_NAME=MY-Q
TOPIC_NAME=MY-T

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

echo "〽️ ----- Publishing message to ${TOPIC_NAME} -----"
aws sns publish \
  --endpoint-url ${ENDPOINT} \
  --topic-arn arn:aws:sns:${REGION}:000000000000:${TOPIC_NAME} \
  --region ${REGION} \
  --message '{"firstname":"Rick","lastname":"Sanchez"}'
echo "💯 ----- Published message to ${TOPIC_NAME} -----"

echo "〽️ ----- Publishing message to ${TOPIC_NAME} -----"
aws sns publish \
  --endpoint-url ${ENDPOINT} \
  --topic-arn arn:aws:sns:${REGION}:000000000000:${TOPIC_NAME} \
  --region ${REGION} \
  --message '{"firstname":"Morty","lastname":"Smith"}'
echo "💯 ----- Published message to ${TOPIC_NAME} -----"

echo "💯 ----- Resources created -----"
