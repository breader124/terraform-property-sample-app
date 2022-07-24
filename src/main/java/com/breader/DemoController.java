package com.breader;

import io.micronaut.context.annotation.Property;
import io.micronaut.http.HttpResponse;
import io.micronaut.http.annotation.Body;
import io.micronaut.http.annotation.Controller;
import io.micronaut.http.annotation.Post;
import jakarta.inject.Inject;
import software.amazon.awssdk.services.sqs.SqsClient;
import software.amazon.awssdk.services.sqs.model.SendMessageRequest;
import software.amazon.awssdk.services.sqs.model.SendMessageResponse;

@Controller
public class DemoController {

    @Inject
    private SqsClient sqsClient;

    @Property(name = "demo.queue.url")
    private String queueUrl;

    @Post("message")
    public HttpResponse<String> sendMessage(@Body String message) {
        SendMessageRequest sendMessageRequest = SendMessageRequest.builder()
            .queueUrl(queueUrl)
            .messageBody(message)
            .build();
        SendMessageResponse sendMessageResponse = sqsClient.sendMessage(sendMessageRequest);

        return HttpResponse.ok(sendMessageResponse.messageId());
    }

}
