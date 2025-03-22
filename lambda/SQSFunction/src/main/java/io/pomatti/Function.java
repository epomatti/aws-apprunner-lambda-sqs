package io.pomatti;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
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

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import software.amazon.lambda.powertools.logging.Logging;

public class Function implements RequestHandler<SQSEvent, Void> {

  Logger log = LogManager.getLogger(Function.class);

  @Logging
  @Override
  public Void handleRequest(SQSEvent sqsEvent, Context context) {
    for (SQSMessage msg : sqsEvent.getRecords()) {
      try {
        processMessage(msg);
      } catch (Exception e) {
        log.error("An error occurred.", e);
      }
    }
    return null;
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

    HttpRequest request = HttpRequest.newBuilder()
        .uri(new URI(url + "/api/process"))
        .version(HttpClient.Version.HTTP_2)
        // .header("key1", "value1")
        // .header("key2", "value2")
        .POST(HttpRequest.BodyPublishers.noBody())
        // .POST(HttpRequest.BodyPublishers.ofString("Sample request body"))
        // .POST(HttpRequest.BodyPublishers
        // .ofInputStream(() -> new ByteArrayInputStream(sampleData)))
        .build();

    HttpResponse<String> response = client.send(request, BodyHandlers.ofString());
    if (response.statusCode() != 200) {
      throw new Exception(response.body());
    }
  }

  protected String getSecret() {
    SecretsProvider secretsProvider = ParamManager.getSecretsProvider();
    var key = System.getenv("APP_RUNNER_SECRET_MANAGER_PASSWORD");
    return secretsProvider.get(key);
  }
}
