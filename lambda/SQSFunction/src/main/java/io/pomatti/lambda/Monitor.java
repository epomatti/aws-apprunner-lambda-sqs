package io.pomatti.lambda;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;

import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.dynamodb.DynamoDbClient;
import software.amazon.awssdk.services.dynamodb.model.AttributeValue;
import software.amazon.awssdk.services.dynamodb.model.PutItemRequest;

public class Monitor {

  private String MONITOR_TABLE_NAME = "lambda-monitor";
  private DynamoDbClient ddb;

  public void buildClient() {
    Region region = Region.of(System.getenv("AWS_REGION"));
    ddb = DynamoDbClient.builder()
        .region(region)
        .build();
  }

  public void putItemOk(SQSMessage message) {
    this.putItem(message, "OK");
  }

  public void putItemError(SQSMessage message) {
    this.putItem(message, "ERROR");
  }

  private void putItem(SQSMessage message, String status) {
    var count = message.getAttributes().get("ApproximateReceiveCount");
    // Already in ISO 8601
    var createdAt = Instant.now().truncatedTo(java.time.temporal.ChronoUnit.SECONDS);
    var expireAt = createdAt.plus(10, ChronoUnit.MINUTES);

    HashMap<String, AttributeValue> itemValues = new HashMap<>();
    itemValues.put("sqsMessageId", AttributeValue.builder().s(message.getMessageId()).build());
    itemValues.put("count", AttributeValue.builder().s(count).build());
    itemValues.put("status", AttributeValue.builder().s(status).build());

    // https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBMapper.DataTypes.html
    itemValues.put("createdAt", AttributeValue.builder().s(createdAt.toString()).build());
    itemValues.put("expireAt", AttributeValue.builder().s(String.valueOf(expireAt.toEpochMilli())).build());

    PutItemRequest request = PutItemRequest.builder()
        .tableName(MONITOR_TABLE_NAME)
        .item(itemValues)
        .build();

    ddb.putItem(request);
  }

}
