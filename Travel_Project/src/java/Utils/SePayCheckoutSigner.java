package Utils;

import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

public class SePayCheckoutSigner {

    public Map<String, String> buildCheckoutFields(String merchantId, String secretKey,
            String orderAmount, String orderDescription, String invoiceNumber,
            String customerId, String successUrl, String errorUrl, String cancelUrl,
            String paymentMethod) {

        LinkedHashMap<String, String> fields = new LinkedHashMap<>();
        fields.put("order_amount", orderAmount);
        fields.put("merchant", merchantId);
        fields.put("currency", "VND");
        fields.put("operation", "PURCHASE");
        fields.put("order_description", orderDescription);
        fields.put("order_invoice_number", invoiceNumber);

        if (customerId != null && !customerId.trim().isEmpty()) {
            fields.put("customer_id", customerId.trim());
        }
        if (paymentMethod != null && !paymentMethod.trim().isEmpty()) {
            fields.put("payment_method", paymentMethod.trim());
        }

        fields.put("success_url", successUrl);
        fields.put("error_url", errorUrl);
        fields.put("cancel_url", cancelUrl);
        fields.put("signature", sign(fields, secretKey));
        return fields;
    }

    public String sign(Map<String, String> fields, String secretKey) {
        String[] allowedOrder = {
            "order_amount", "merchant", "currency", "operation",
            "order_description", "order_invoice_number", "customer_id",
            "payment_method", "success_url", "error_url", "cancel_url"
        };

        StringBuilder signingSource = new StringBuilder();
        for (String field : allowedOrder) {
            String value = fields.get(field);
            if (value == null) {
                continue;
            }
            if (signingSource.length() > 0) {
                signingSource.append(",");
            }
            signingSource.append(field).append("=").append(value);
        }

        try {
            Mac mac = Mac.getInstance("HmacSHA256");
            SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA256");
            mac.init(secretKeySpec);
            byte[] digest = mac.doFinal(signingSource.toString().getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(digest);
        } catch (Exception ex) {
            throw new RuntimeException("Cannot sign SePay checkout fields", ex);
        }
    }
}
