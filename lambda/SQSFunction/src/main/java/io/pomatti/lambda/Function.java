package io.pomatti.lambda;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSBatchResponse;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;
import software.amazon.lambda.powertools.parameters.SecretsProvider;
import software.amazon.lambda.powertools.parameters.ParamManager;

import java.net.Authenticator;
import java.net.PasswordAuthentication;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpResponse.BodyHandlers;
import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import software.amazon.lambda.powertools.logging.Logging;

public class Function implements RequestHandler<SQSEvent, SQSBatchResponse> {

  Logger log = LogManager.getLogger(Function.class);

  @Logging
  @Override
  public SQSBatchResponse handleRequest(SQSEvent sqsEvent, Context context) {
    Monitor monitor = new Monitor();
    monitor.buildClient();

    List<SQSBatchResponse.BatchItemFailure> batchItemFailures = new ArrayList<SQSBatchResponse.BatchItemFailure>();
    for (SQSMessage msg : sqsEvent.getRecords()) {
      try {
        processMessage(msg);
        monitor.putItemOk(msg);
      } catch (Exception e) {
        log.error(String.format("An error occurred while processing message [%s]. Adding the message for reprocessing.",
            msg.getMessageId()), e);
        monitor.putItemError(msg);
        batchItemFailures.add(new SQSBatchResponse.BatchItemFailure(msg.getMessageId()));
      }
    }
    return new SQSBatchResponse(batchItemFailures);
  }

  private void processMessage(SQSMessage msg) throws Exception {

    var url = System.getenv("APP_RUNNER_URL");
    var username = System.getenv("APP_RUNNER_USERNAME");
    var password = getSecret();

    HttpClient client = HttpClient.newBuilder()
        .authenticator(new Authenticator() {
          @Override
          protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(
                username,
                password.toCharArray());
          }
        }).build();

    // App Runner doesn't support HTTP 2
    var version = HttpClient.Version.HTTP_1_1;

    var uriString = String.format("%s/api/process", url);

    HttpRequest request = HttpRequest.newBuilder()
        .uri(new URI(uriString))
        .version(version)
        .header("Content-type", "application/json")
        .POST(HttpRequest.BodyPublishers.ofString(msg.getBody()))
        .build();

    HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
    if (response.statusCode() != 200) {
      throw new Exception(String.format("Received error status %s from the API", response.statusCode()));
    }
  }

  protected String getSecret() {
    SecretsProvider secretsProvider = ParamManager.getSecretsProvider();
    var key = System.getenv("APP_RUNNER_SECRET_MANAGER_PASSWORD");
    return secretsProvider.get(key);
  }

  protected void addMonitoring() {

  }

}
