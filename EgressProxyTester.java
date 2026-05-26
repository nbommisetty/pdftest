import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.PasswordAuthentication;
import java.net.Proxy;
import java.net.URL;

public class EgressProxyTester {

    // ==========================================
    // CONFIGURATION: Update these values
    // ==========================================
    private static final String PROXY_HOST = "your.proxy.com";
    private static final int PROXY_PORT = 8080;
    private static final String PROXY_USER = "yourProxyUser";
    private static final String PROXY_PASS = "yourProxyPassword";
    
    // The endpoint you are trying to reach (e.g., Okta or ClickSwitch)
    private static final String TARGET_URL = "https://your-domain.okta.com"; 
    // ==========================================

    public static void main(String[] args) {
        System.out.println("Starting Egress Proxy Test...");
        System.out.println("Target URL: " + TARGET_URL);
        System.out.println("Proxy: " + PROXY_HOST + ":" + PROXY_PORT);

        // 1. Crucial for Java 8u111+ and Java 11+ HTTPS tunneling with Basic Auth
        System.setProperty("jdk.http.auth.tunneling.disabledSchemes", "");
        System.setProperty("jdk.http.auth.proxying.disabledSchemes", "");

        // 2. Set the global Authenticator for the proxy credentials
        Authenticator.setDefault(new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                if (getRequestorType() == RequestorType.PROXY) {
                    System.out.println("[DEBUG] Providing proxy credentials for: " + getRequestingHost());
                    return new PasswordAuthentication(PROXY_USER, PROXY_PASS.toCharArray());
                }
                return null;
            }
        });

        try {
            // 3. Define the proxy routing
            Proxy proxy = new Proxy(Proxy.Type.HTTP, new InetSocketAddress(PROXY_HOST, PROXY_PORT));
            URL url = new URL(TARGET_URL);

            System.out.println("\nOpening connection...");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection(proxy);
            
            // Set basic timeout properties (10 seconds)
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(10000);

            // 4. Execute the request
            int responseCode = connection.getResponseCode();
            System.out.println("\n--- RESPONSE ---");
            System.out.println("HTTP Status Code: " + responseCode);

            // 5. Read the response (or error) stream
            BufferedReader reader;
            if (responseCode >= 200 && responseCode <= 299) {
                reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            } else {
                reader = new BufferedReader(new InputStreamReader(connection.getErrorStream()));
            }

            String line;
            StringBuilder response = new StringBuilder();
            while ((line = reader.readLine()) != null) {
                response.append(line).append("\n");
            }
            reader.close();

            // Print the first 500 characters of the response to verify it worked
            System.out.println("Response Body (Truncated):\n" + 
                (response.length() > 500 ? response.substring(0, 500) + "..." : response.toString()));

        } catch (Exception e) {
            System.err.println("\n--- CONNECTION FAILED ---");
            e.printStackTrace();
        }
    }
}