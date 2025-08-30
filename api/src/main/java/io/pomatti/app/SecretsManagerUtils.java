package io.pomatti.app;

import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest;
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse;

public class SecretsManagerUtils {

  public static String getSecret() {
    SecretsManagerClient client = SecretsManagerClient.builder()
        .region(Region.US_EAST_2)
        .build();

    GetSecretValueRequest request = GetSecretValueRequest.builder()
        .secretId("/litware/lambda/payment-api-password")
        .build();

    GetSecretValueResponse response = client.getSecretValue(request);
    return response.secretString();
  }

}
