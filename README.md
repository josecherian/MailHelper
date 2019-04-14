# MailHelper
A Power shell module to send mails easily. Currently it is in experimental stage.

 ## Usage ##
 1. Create a config file. Please note that teh Target value is the name of your crfedencial in windows credencial manager.
 ```json
{
    "From": "someone@example.com",
    "To": "someone@eample2.com",
    "Subject": "Here's the Email Subject",
    "SMTPServer": "smtp.example.com",
    "SMTPPort": "587",
    "Target": "email_credencial_name_in_Credencial_Manager"
}
```
 2. Create an environment varible with name 'MAIL_HELPER_CONFIG' and value as the path of above config file.