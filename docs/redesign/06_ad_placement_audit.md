# 06. Ad Placement Audit & Compliance Report

This document records the screen-by-screen audit of all advertising surfaces across **Doc View** in accordance with the design system specifications in `doc_view_mockups/README.md` (Section 6) and owner directives.

---

## 1. Compliance Matrix Across All App Surfaces

| Screen / Flow | Docked 60pt Banner | In-Feed Native Rows (Positions) | Interstitial Trigger | Allowed By Design Rules | 16pt Clearance Verified | Release Build Collapses Cleanly |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **01. Splash** (`/splash`) | No | None | None | Yes (Ad-free) | N/A | Yes |
| **02. Onboarding 1** (`/onboarding`) | No | None | None | Yes (Ad-free) | N/A | Yes |
| **03. Onboarding 2** (`/onboarding`) | No | None | None | Yes (Ad-free) | N/A | Yes |
| **04. Onboarding 3** (`/onboarding`) | No | None | None | Yes (Ad-free) | N/A | Yes |
| **05. Permissions & Privacy** (`/permissions`) | No | None | None | Yes (Ad-free) | N/A | Yes |
| **06. Home - All Files** (`/home`) | Yes (docked above nav) | Recent list: after 4th item (index 4) | None | Yes | Yes (FAB $\ge 16\text{pt}$ clearance) | Yes (collapses to 0 height) |
| **07. Home State Variants** (`/home`) | Yes (all states) | None on empty states; 4th in Recent | None | Yes | Yes | Yes |
| **08. Search Screen** (`/search`) | No (strictly no banner) | Typing results: position 6 only (index 5) | None | Yes | Yes (16pt vertical margin) | Yes (suppressed in selection mode) |
| **09. Category File Lists** (`/files`) | Yes (when not in selection) | After 4th item, then every 8th (4, 13, 22...) | None | Yes | Yes | Yes (suppressed in selection mode) |
| **10. Single-File Actions (Sheet/Dialogs)** | No | None (background list has in-feed) | None | Yes (Ad-free modal) | N/A | Yes |
| **11. Multi-Select / Selection Mode** | No (suppressed) | None (all in-feed ads hidden) | None | Yes (Strictly ad-free) | N/A | Yes |
| **12. Directories (Folder Browser)** | Yes (docked) | None | None | Yes | Yes | Yes |
| **13. PDF Reader** (`/viewer?category=pdf`) | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **14. PDF Reader States & Dialogs** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **15. Office Viewer (DOCX, XLSX, PPTX)** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **16. Image & TXT Viewers** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **17. Tools Tab** (`/tools`) | Yes (docked above nav) | None | None | Yes | Yes (16pt above nav) | Yes |
| **18. Created Documents (See All)** | Yes (docked above nav) | None | None | Yes | Yes | Yes |
| **19. Image to PDF Editor** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **20. Merge PDF: Step 1 (Picker)** | No | In-feed native row after 5th item | None | Yes | Yes (16pt margin) | Yes |
| **21. Merge PDF: Step 2 (Arrange)** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **22. Split PDF: Picker & Config** | No | None | None | Yes (Strictly ad-free) | N/A | Yes |
| **23. Operation Results & Sheets** | No | None | After SUCCESSFUL export (Done) | Yes | N/A | Yes |
| **24. Settings Tab** (`/settings`) | Yes (docked above nav) | None | None | Yes | Yes | Yes |
| **25. Scan Settings** (`/settings/scan-settings`)| Yes (docked at bottom) | None | None | Yes | Yes | Yes |
| **26. FAQ Screen** (`/settings/faq`) | Yes (docked at bottom) | None | None | Yes | Yes | Yes |

---

## 2. Clearance & Geometry Rules Audit

1. **Docked 60pt Banner Clearance**:
   - `DocScaffold` positions `AdBannerSlot` directly above `bottomNavigationBar` inside a pinned bottom column.
   - Any floating action button (`DocScaffold.floatingActionButton`) is wrapped with an explicit `16.0pt` bottom padding to guarantee clearance over the ad banner.
2. **Native In-Feed Row Geometry**:
   - `NativeAdRow` conforms to the standard `FileRow` height ($\ge 68\text{pt}$ min-height).
   - Each native row incorporates an explicit `16pt` vertical margin (`margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16)`) and an accessible `'Advertisement'` semantic chip.
3. **Selection Mode Ad Suppression**:
   - In `FilesScreen` and `SearchScreen`, whenever multi-selection mode is active (`selection.isSelectionMode == true`), all docked banners and in-feed native rows are immediately suppressed and excluded from the list count.
4. **Release-Mode Zero-Size Collapse**:
   - All placeholder ad components inspect `AdConfig.showPlaceholders` (`kDebugMode`).
   - In production release builds, `AdBannerSlot`, `NativeAdRow`, `NativeAdCard`, and `InterstitialPlaceholder` immediately collapse to `SizedBox.shrink()` without residual margins, paddings, or layout gaps.
