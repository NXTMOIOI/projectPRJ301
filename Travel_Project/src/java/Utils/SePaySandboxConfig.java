package Utils;

import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class SePaySandboxConfig {

    private static final String DEFAULT_CHECKOUT_URL = "https://pay-sandbox.sepay.vn/v1/checkout/init";
    private final Properties properties = new Properties();

    public SePaySandboxConfig() {
        try (InputStream inputStream = getClass().getClassLoader().getResourceAsStream("SePaySandbox.properties")) {
            if (inputStream != null) {
                properties.load(inputStream);
            }
        } catch (IOException ex) {
            throw new RuntimeException("Cannot load SePaySandbox.properties", ex);
        }
    }

    public String getMerchantId() {
        return safe(properties.getProperty("merchantId"));
    }

    public String getSecretKey() {
        return safe(properties.getProperty("secretKey"));
    }

    public String getCheckoutUrl() {
        String value = safe(properties.getProperty("checkoutUrl"));
        return value.isEmpty() ? DEFAULT_CHECKOUT_URL : value;
    }

    public String getConfiguredAppBaseUrl() {
        return trimTrailingSlash(safe(properties.getProperty("appBaseUrl")));
    }

    public boolean isConfigured() {
        return !getMerchantId().isEmpty() && !getSecretKey().isEmpty();
    }

    public String resolveAppBaseUrl(HttpServletRequest request) {
        String configured = getConfiguredAppBaseUrl();
        if (!configured.isEmpty()) {
            return configured;
        }

        StringBuilder builder = new StringBuilder();
        builder.append(request.getScheme())
                .append("://")
                .append(request.getServerName());

        int port = request.getServerPort();
        if (!(("http".equalsIgnoreCase(request.getScheme()) && port == 80)
                || ("https".equalsIgnoreCase(request.getScheme()) && port == 443))) {
            builder.append(":").append(port);
        }
        builder.append(request.getContextPath());
        return builder.toString();
    }

    private String safe(String value) {
        return value == null ? "" : value.trim();
    }

    private String trimTrailingSlash(String value) {
        if (value.endsWith("/")) {
            return value.substring(0, value.length() - 1);
        }
        return value;
    }
}
