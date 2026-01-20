## Testing SendGrid API Key


This folder contains a code snippet demonstrating how to test the SendGrid email API using a cURL command to send a test email. The documented result shows that the test failed with a "Maximum credits exceeded" error, indicating the SendGrid account ran out of email sending credits.

```
curl --request POST \
  --url https://api.sendgrid.com/v3/mail/send \
  --header 'Authorization: Bearer YOUR_API_KEY' \
  --header 'Content-Type: application/json' \
  --data '{"personalizations": [
        {"to": [{"email": "recipient@example.com"}]}],
        "from": {"email": "verified_sender@yourdomain.com"},
        "subject": "Test",
        "content": [{"type": "text/plain", "value": "Test content"}
          ]
        }'
```

## Result

```
{
    "errors": [
        {
            "message": "Maximum credits exceeded",
            "field": null,
            "help": null
        }
    ]
}
```

<img width="1649" height="470" alt="image" src="https://github.com/user-attachments/assets/8a2774b6-7342-4061-887e-e06244c02a7d" />
