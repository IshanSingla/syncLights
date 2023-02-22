const admin = require("firebase-admin");
// path to service account

admin.initializeApp({
  credential: admin.credential.cert({
    "type": "service_account",
    "project_id": "syn-clights",
    "private_key_id": process.env.private_key_id,
    "private_key": process.env.private_key,
    "client_email": "firebase-adminsdk-1gt7j@syn-clights.iam.gserviceaccount.com",
    "client_id": "108022081752808905845",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-1gt7j%40syn-clights.iam.gserviceaccount.com"
  }
  ),
});

module.exports = {admin};