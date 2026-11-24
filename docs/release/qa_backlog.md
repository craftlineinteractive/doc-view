# Doc View - QA Backlog & Pending Release Scenarios (G4c – G7)

## 1. Overview & Verification Strategy

This document tracks all QA scenarios across phases G4c through G7 that cannot be fully automated via headless unit/widget tests or requires physical device / external production services (Google Play Store). In accordance with the **Standing Device Rule**, emulator `emulator-5554` serves as the primary verification environment, while physical hardware dependencies and live store dependencies are explicitly backlogged below.

---

## 2. Physical Phone Hardware Re-Test List (Required Before Production Release)

The following tests require physical Android hardware and must NOT be marked complete based on emulator runs alone:

| Area | Test Scenario | Hardware Dependency | Rationale & Test Criteria |
|---|---|---|---|
| **G5a: Ink Annotations** | Real finger and stylus latency | Physical touchscreen digitizer | Test high-frequency stylus sampling, palm rejection, and sub-16ms touch-to-glass latency on 120Hz display. |
| **G5b: Signatures** | Signature stroke smoothness | Physical capacitive glass | Verify pressure sensitivity, stroke smoothing algorithm, and tactile feel when signing with fingertip. |
| **G5c/G5d: Add Text** | Soft keyboard interop & ime | Physical keyboard & IME | Test virtual keyboard show/hide transitions, SwiftKey/Gboard auto-correct overlays, and viewport resizing behavior. |
| **G4c: Recycle Bin** | Flash storage write speed & wear | Real UFS/eMMC flash storage | Measure raw IO throughput of 190 MB copy/rename on physical flash storage compared to emulator host SSD. |
| **G4c: File Management** | Android Files app interop | Native OEM file managers | Test file discovery and SAF (Storage Access Framework) pickers across Samsung My Files, Xiaomi File Manager, and Google Files. |
| **G4b: Document Scanner** | Physical camera capture & autofocus | Physical camera sensor & lighting | Verify document edge detection, skew correction, and auto-shutter under variable real-world ambient lighting. |

---

## 3. Google Play Store Live Services (Pending Play Store Production Deployment)

| Area | Scenario | External Dependency | Status | Notes / Plan |
|---|---|---|---|---|
| **G7: Billing** | Real Google Play In-App Billing Purchase | Google Play Console & Merchant Account | `PENDING (Play)` | Requires uploading release bundle to internal testing track, configuring licensed testers, and testing real payment instruments. |
| **G7: Billing** | Subscription Auto-Renewal & Grace Period | Google Play Billing Subscription Engine | `PENDING (Play)` | Test real webhook server notification, account hold, cancellation, and renewal grace periods. |
| **G7: Billing** | Multi-Device Entitlement Sync | Google Play Account Sync | `PENDING (Play)` | Purchase subscription on Device A, verify entitlement is unlocked on Device B after Google account sync. |

---

## 4. Phase G4c: Recycle Bin & Deletion Edge Cases

- [ ] **30-Day Wall-Clock Expiration**: Simulate advancing system clock by 31 days while app is terminated; verify `TrashService` automatically deletes expired bin files on cold start.
- [ ] **External Removable SD Card Ejection**: Initiate move of large file residing on physical microSD card; simulate abrupt physical card ejection during copy. Verify rollback clean.
- [ ] **Zero Free Space Condition**: Test moving 50 MB file when available disk space is < 10 MB. Verify typed `DiskSpaceException` caught and user alerted without file damage.

---

## 5. Phase G5a–G5d: PDF Editing & Annotations Edge Cases

- [ ] **100+ Ink Strokes Stress Test**: Draw over 100 separate freehand strokes on a single page; verify UI maintains 60 fps rendering and save completes without OOM.
- [ ] **Mixed Script Bidirectional Layout**: Add text boxes containing alternating English, Hebrew, and Hindi phrases on the same line; verify correct visual cursor progression.
- [ ] **Non-Standard CropBox Coordinates**: Test annotations on PDFs with negative CropBox origin coordinates (`[-50, -50, 500, 700]`).

---

## 6. Phase G6: PDF to Word Conversion Edge Cases

- [ ] **1,000+ Page Document Stress Test**: Verify typed exception thrown when page count exceeds 1,000 pages (`PdfToWordErrorReason.tooManyPages`).
- [ ] **20 MB Extracted Text Stress Test**: Verify typed exception thrown when extracted plain text size exceeds 20 MB (`PdfToWordErrorReason.textTooLarge`).
- [ ] **Damaged Stream Recovery**: Test conversion on PDFs with missing xref tables or damaged EOF markers; verify graceful error handling.
- [ ] **Low-RAM Android Go Devices**: Run 100-page conversion on a 1 GB / 2 GB RAM Android Go profile to verify background isolate does not trigger OS LMK (Low Memory Killer).
