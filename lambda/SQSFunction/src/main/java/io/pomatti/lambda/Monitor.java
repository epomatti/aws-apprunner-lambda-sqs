package io.pomatti.lambda;

import java.time.Instant;
import java.util.HashMap;

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

  public void putItem(String sqsMessageId, String status) {
    String dateString = Instant.now().toString();

    HashMap<String, AttributeValue> itemValues = new HashMap<>();
    itemValues.put("sqsMessageId", AttributeValue.builder().s(sqsMessageId).build());
    itemValues.put("status", AttributeValue.builder().s(status).build());

    // https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBMapper.DataTypes.html
    itemValues.put("createdAt", AttributeValue.builder().s(dateString).build());

    PutItemRequest request = PutItemRequest.builder()
        .tableName(MONITOR_TABLE_NAME)
        .item(itemValues)
        .build();

    ddb.putItem(request);
  }

}
