package io.pomatti.app;

import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;

public class SQSUtils {

  public static void sendMessage(SqsClient sqsClient, String queueName, String message) {
    String queueUrl = System.getenv("SQS_QUEUE_URL");
    SendMessageRequest sendMsgRequest = SendMessageRequest.builder()
        .queueUrl(queueUrl)
        .messageBody(message)
        .delaySeconds(5)
        .build();
    sqsClient.sendMessage(sendMsgRequest);
  }

}
