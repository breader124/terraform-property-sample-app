package com.breader;

import io.micronaut.context.annotation.Factory;
import jakarta.inject.Singleton;
import software.amazon.awssdk.auth.credentials.ContainerCredentialsProvider;
import software.amazon.awssdk.services.sqs.SqsClient;

@Factory
public class ApplicationConfig {

    @Singleton
    SqsClient sqsClient() {
        ContainerCredentialsProvider credentialsProvider = ContainerCredentialsProvider.builder().build();
        return SqsClient.builder()
            .credentialsProvider(credentialsProvider)
            .build();
    }

}
