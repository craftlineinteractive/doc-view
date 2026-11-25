# Google Play Permission Declarations: Doc View

This document provides complete declaration drafts and video scripts required by Google Play Console for sensitive permissions.

---

## 1. "All Files Access" (`MANAGE_EXTERNAL_STORAGE`) Declaration

### A. Core Purpose & Justification
- **App Category**: Document Management & File Management.
- **Core Functionality**: Doc View is a universal document reader and file manager designed to automatically discover, index, organize, rename, delete, and restore office documents and PDFs saved by any app or downloaded from any source across device storage.
- **Why MediaStore is Insufficient**: MediaStore is restricted to media formats (images, audio, video) and cannot reliably discover or perform transactional operations on documents across external folders like `/sdcard/Documents/`, `/sdcard/Download/`, or custom user directories.
- **Why Storage Access Framework (SAF) is Insufficient**: SAF requires manual, per-folder permission prompts and manual document picking for every file, creating severe user friction that prevents automatic indexing of device documents, cross-directory search, and transactional 30-day Recycle Bin recovery.

### B. Play Console Form Answers
1. **Does your app require All Files Access to perform its core functionality?**
   - **Answer**: Yes.
2. **Select the core use case that best describes your app**:
   - **Answer**: Document management.
3. **Describe how your app uses All Files Access**:
   - **Answer**: Doc View is a comprehensive document manager. It uses All Files Access to index, display, and manage PDF, Word (DOCX), Excel (XLSX), PowerPoint (PPTX), and TXT files across device storage. It enables universal document search, folder browsing (Directories screen), file renaming, permanent deletion, and a 30-day transactional Recycle Bin recovery system.
4. **Is the permission used to access files that other apps created?**
   - **Answer**: Yes. Users download documents from email, messaging apps, and web browsers, and expect Doc View to display and organize all their documents in one unified library.

### C. 60-Second Demo Video Script (Required by Google Play)
- **[0:00 - 0:10] Introduction & Permission Prompt**:
  - Show app launch and the Permissions Screen.
  - Narrator: *"Doc View is an offline document manager. On first launch, the user is prompted to grant All Files Access to index device documents."*
  - Show tap on "Grant Access" → user toggles "Allow access to manage all files" in Android system settings.
- **[0:10 - 0:25] Universal Indexing & Directories**:
  - Return to app: All Files instantly displays PDFs, Word, Excel, and PowerPoint documents downloaded across multiple storage locations.
  - Tap "Directories" tab: show browsing files by physical directory hierarchy.
- **[0:25 - 0:45] File Operations & Recycle Bin**:
  - Long press a document → select "Move to Bin".
  - Navigate to Settings → Recycle Bin: demonstrate the document safely held in the 30-day recovery bin with its expiration countdown.
  - Tap "Restore": demonstrate the document restoring instantly to its original directory.
- **[0:45 - 1:00] Reading & Conversion**:
  - Open a PDF document: demonstrate full-text search, annotation, and offline viewing.
  - Conclude: *"All Files Access is essential for Doc View to discover, organize, and safeguard documents across user storage."*

---

## 2. Camera Permission (`android.permission.CAMERA`) Declaration
- **Where Used**: Scan to PDF tool (`/tools/scan`).
- **Justification**: Allows users to take photos of physical paper documents, receipts, or notes and convert them directly into multi-page PDF files on the device.
- **Hardware Feature**: Declared as non-required (`android:required="false"`) so devices without a physical camera can still install and use the app.

---

## 3. Post Notifications (`android.permission.POST_NOTIFICATIONS`) Declaration
- **Where Used**: Quick Access Notification (`QuickAccessNotificationService`).
- **Justification**: Delivers optional, silent, ongoing shortcuts (Scan, Image to PDF, Search) in the Android notification drawer.
- **User Control**: Default state is OFF. Enabled solely when the user explicitly turns on the toggle in Settings → General.

---

## 4. Advertising ID (`com.google.android.gms.permission.AD_ID`) Declaration
- **Where Used**: Google Mobile Ads SDK (AdMob).
- **Declaration in Play Console**:
  - **Does your app use an advertising ID?**: Yes.
  - **Purposes**: Advertising or marketing, Analytics, Fraud prevention.
  - **Does your app support opting out?**: Yes, through Android OS system settings and in-app UMP GDPR consent form (**Settings → Ad choices**).
