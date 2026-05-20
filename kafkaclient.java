import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.clients.producer.RecordMetadata;
import org.apache.kafka.common.serialization.StringSerializer;

import java.util.Properties;
import java.util.concurrent.Future;

public class MosaicKafkaProducer {

    public static void main(String[] args) {
        // 1. Define Topic and Brokers from DEV configs
        String topicName = "MosaicEvents.raw";
        String bootstrapServers = "broker01.dah-kafka-dev.xyz.com:9092,broker02.dah-kafka-dev.xyz.com:9092,broker03.dah-kafka-dev.xyz.com:9092";

        // Fetch secret from environment variable for security
        String clientSecret = System.getenv("OKTA_CLIENT_SECRET");
        if (clientSecret == null || clientSecret.isEmpty()) {
            System.err.println("ERROR: OKTA_CLIENT_SECRET environment variable is not set.");
            System.exit(1);
        }

        // 2. Build the JAAS Config String
        String jaasConfig = String.format(
            "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginModule required " +
            "clientId=\"0oa1t08sgof0r4BuX358\" " +
            "clientSecret=\"%s\" " +
            "oauth.token.endpoint.uri=\"https://myapps.xyz.com/oauth2/default/v1/token\" " +
            "scope=\"11547.DAH(Dev)\";", 
            clientSecret
        );

        // 3. Set Producer Properties
        Properties props = new Properties();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class.getName());

        // Security & Authentication configs
        props.put("security.protocol", "SASL_SSL");
        props.put("sasl.mechanism", "OAUTHBEARER");
        props.put("sasl.jaas.config", jaasConfig);
        props.put("sasl.login.callback.handler.class", "org.apache.kafka.common.security.oauthbearer.OAuthBearerLoginCallbackHandler");
        
        // Ensure the token endpoint URL is also passed via this property if required by the handler
        props.put("sasl.oauthbearer.token.endpoint.url", "https://myapps.xyz.com/oauth2/default/v1/token");

        // 4. Initialize Producer and Send Message
        try (KafkaProducer<String, String> producer = new KafkaProducer<>(props)) {
            
            // Sample JSON payload representing a Mosaic event
            String messageKey = "opp-12345";
            String messageValue = "{\"eventId\": \"evt-998877\", \"eventType\": \"OnboardingInitiated\", \"opportunityId\": \"12345\", \"status\": \"PENDING\"}";

            ProducerRecord<String, String> record = new ProducerRecord<>(topicName, messageKey, messageValue);

            System.out.println("Attempting to send message to topic: " + topicName);
            
            // Send synchronously for the sake of the POC to easily catch exceptions
            Future<RecordMetadata> future = producer.send(record);
            RecordMetadata metadata = future.get();

            System.out.println("Successfully published message!");
            System.out.println("Topic: " + metadata.topic());
            System.out.println("Partition: " + metadata.partition());
            System.out.println("Offset: " + metadata.offset());

        } catch (Exception e) {
            System.err.println("Failed to send message to Kafka:");
            e.printStackTrace();
        }
    }
}