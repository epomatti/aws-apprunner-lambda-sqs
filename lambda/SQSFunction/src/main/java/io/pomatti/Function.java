package io.pomatti;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.SQSEvent;
import com.amazonaws.services.lambda.runtime.events.SQSEvent.SQSMessage;
import software.amazon.lambda.powertools.parameters.SecretsProvider;
import software.amazon.lambda.powertools.parameters.ParamManager;

public class Function implements RequestHandler<SQSEvent, Void> {

  @Override
  public Void handleRequest(SQSEvent sqsEvent, Context context) {
    var secret = getSecret(context);
    context.getLogger().log(secret);
    for (SQSMessage msg : sqsEvent.getRecords()) {
      processMessage(msg, context);
    }
    context.getLogger().log("done");
    return null;
  }

  private void processMessage(SQSMessage msg, Context context) {
    try {
      context.getLogger().log("Processed message " + msg.getBody());

      // TODO: Do interesting work based on the new message f

    } catch (Exception e) {
      context.getLogger().log("An error occurred");
      throw e;
    }

  }

  protected String getSecret(Context context) {
    SecretsProvider secretsProvider = ParamManager.getSecretsProvider();
    var key = System.getenv("APP_RUNNER_SECRET_MANAGER_PASSWORD");
    context.getLogger().log("Secrets manager key: " + key);
    return secretsProvider.get(key);
  }
}
