# Android Keystore Management & Release Signing Guide

## 1. Overview
Doc View requires an upload keystore to sign production Android App Bundles (AAB) submitted to Google Play.
Under **Google Play App Signing**, Google re-signs the APK delivered to end users using Google's secure app signing key; the developer upload key is only used to authenticate developer uploads.

---

## 2. Generating the Upload Keystore

Run the standard Java `keytool` command from a secure shell:

```bash
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload
```

### Parameter Explanations:
- `-keystore upload-keystore.jks`: Filename of the generated keystore file.
- `-keyalg RSA`: Asymmetric RSA key algorithm required by Google Play.
- `-keysize 2048`: 2048-bit key length for strong cryptographic security.
- `-validity 10000`: Valid for ~27 years (ensures keystore does not expire during app lifetime).
- `-alias upload`: The entry alias referenced in `key.properties`.

> [!CAUTION]
> **DO NOT** commit keystore files (`*.jks`, `*.keystore`) or passwords to this repository. The `.gitignore` file explicitly excludes them.

---

## 3. Configuring `android/key.properties`

1. Copy `android/key_properties.example` to `android/key.properties`:
   ```bash
   cp android/key_properties.example android/key.properties
   ```
2. Populate the four required properties:
   ```properties
   storePassword=YOUR_STRONG_STORE_PASSWORD
   keyPassword=YOUR_STRONG_KEY_PASSWORD
   keyAlias=upload
   storeFile=/path/to/upload-keystore.jks
   ```
3. Relative paths in `storeFile` are resolved relative to the `android/app` directory (e.g. `../upload-keystore.jks`).

---

## 4. Keystore Backup & Disaster Recovery Strategy

The upload keystore is the cryptographic identity of your developer uploads.
1. **Primary Secure Storage**: Store the keystore file in an encrypted corporate password vault (e.g. 1Password, Bitwarden, or HashiCorp Vault).
2. **Secondary Offline Backup**: Keep a separate, encrypted offline backup on cold physical media (encrypted USB drive kept in a secure physical safe).
3. **Backup Credentials**: Store the `storePassword` and `keyPassword` separately from the keystore file.

### What Happens if the Upload Key is Lost?
Because Doc View uses **Google Play App Signing**:
- Losing the upload key does **NOT** mean you lose the app or have to change the `applicationId`.
- The account owner can request an **Upload Key Reset** directly through Google Play Console:
  1. Open Google Play Console → Select Doc View.
  2. Navigate to **Release** → **Setup** → **App integrity** → **App Signing** tab.
  3. Click **Request upload key reset**.
  4. Generate a new upload key locally using `keytool` and export the public certificate:
     ```bash
     keytool -export -rfc -keystore new-upload-keystore.jks -alias upload -file upload_certificate.pem
     ```
  5. Upload `upload_certificate.pem` to Google Play Console.
  6. Google will verify the request and register the new upload key within 48 hours.
*(Verify current Play Console steps and policies in Google Play Console).*
