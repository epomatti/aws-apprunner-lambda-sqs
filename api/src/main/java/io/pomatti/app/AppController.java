package io.pomatti.app;

import software.amazon.awssdk.regions.Region;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import software.amazon.awssdk.services.sqs.SqsClient;

@RestController
public class AppController {

	Logger logger = LoggerFactory.getLogger(AppController.class);

	@GetMapping("/")
	public String ok() {
		return "OK";
	}

	@PostMapping("/api/enqueue")
	public ResponseEntity<?> enqueue(@RequestBody com.fasterxml.jackson.databind.JsonNode payload) {
		SqsClient sqsClient = SqsClient.builder()
				.region(Region.US_EAST_2)
				.build();
		SQSUtils.sendMessage(sqsClient, "litware-payments", "Hello, World!");
		logger.info("Message sent!");
		return ResponseEntity.ok().build();
	}

	@PostMapping("/api/process")
	public ResponseEntity<?> process(@RequestBody ProcessRequest request) {
		logger.info(String.format("Received HTTP status: %s", request.getHttpResponseStatus()));
		return ResponseEntity.status(request.getHttpResponseStatus()).build();
	}

	@GetMapping("/api/secret")
	public ResponseEntity<?> getSecret() {
		String secret = SecretsManagerUtils.getSecret();
		return ResponseEntity.ok(secret);
	}

}
