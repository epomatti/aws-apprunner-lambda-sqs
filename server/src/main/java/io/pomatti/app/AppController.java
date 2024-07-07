package io.pomatti.app;

import software.amazon.awssdk.regions.Region;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import software.amazon.awssdk.services.sqs.SqsClient;

@RestController
public class AppController {

	@GetMapping("/")
	public String ok() {
		return "OK";
	}

	@PostMapping("/api/enqueue")
	public ResponseEntity<?> enqueue(@RequestBody com.fasterxml.jackson.databind.JsonNode payload) {
		System.out.println("Building SQS client...");
		SqsClient sqsClient = SqsClient.builder()
				.region(Region.US_EAST_2)
				.build();

		System.out.println("Sending message to SQS...");
		SQSUtils.sendMessage(sqsClient, "easybank-payments", "Hello, World!");
		System.out.println("Message sent!");

		return ResponseEntity.ok().build();
	}

}
