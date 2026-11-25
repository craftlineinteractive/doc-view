// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Doc View';

  @override
  String get navHome => 'Semua file';

  @override
  String get navTools => 'Alat';

  @override
  String get navSettings => 'Pengaturan';

  @override
  String get noDocumentSelected => 'Tidak ada dokumen yang dipilih';

  @override
  String get tooltipCloseAd => 'Tutup iklan';

  @override
  String get tooltipClose => 'Tutup';

  @override
  String get tooltipRescan => 'Pindai ulang dokumen';

  @override
  String get tooltipSearch => 'Cari dokumen';

  @override
  String get tooltipSelectFiles => 'Pilih file';

  @override
  String get tooltipBack => 'Kembali';

  @override
  String get tooltipCancelSelection => 'Batalkan pilihan';

  @override
  String selectionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dipilih',
      one: '1 dipilih',
    );
    return '$_temp0';
  }

  @override
  String get actionSelectAll => 'Pilih semua';

  @override
  String get actionDeselectAll => 'Batal pilih semua';

  @override
  String get tooltipDeleteSelected => 'Hapus yang dipilih';

  @override
  String get tooltipClearSearch => 'Hapus pencarian';

  @override
  String get searchHint => 'Cari dokumen, folder...';

  @override
  String pageIndicatorSemantics(int page, int total) {
    return 'Halaman $page dari $total';
  }

  @override
  String get errorGenericTitle => 'Terjadi kesalahan';

  @override
  String get actionRetry => 'Coba lagi';

  @override
  String get permissionAllFilesTitle => 'Akses Semua File Diperlukan';

  @override
  String get permissionAllFilesExplanation =>
      'Doc View memerlukan akses Semua file untuk menelusuri folder dan mengatur dokumen Anda sepenuhnya secara offline.';

  @override
  String get actionGrantAccess => 'Berikan Akses';

  @override
  String get actionImportFilesInstead => 'Impor File Saja';

  @override
  String get tooltipRemoveBookmark => 'Hapus markah';

  @override
  String get tooltipAddBookmark => 'Tambahkan markah';

  @override
  String tooltipFileOptions(String title) {
    return 'Opsi file untuk $title';
  }

  @override
  String folderSemantics(String name, String subtitle) {
    return 'Folder, $name$subtitle';
  }

  @override
  String get adAdvertisementBadge => 'IKLAN';

  @override
  String get actionConfirm => 'Konfirmasi';

  @override
  String get actionCancel => 'Batal';

  @override
  String get tabRecent => 'Terbaru';

  @override
  String get tabBookmarks => 'Markah';

  @override
  String get filterCategoryAll => 'Semua';

  @override
  String get actionBrowse => 'Telusuri';

  @override
  String get actionCancelOperation => 'Batalkan Operasi';

  @override
  String get operationComplete => 'Operasi Selesai';

  @override
  String get actionOpenDocument => 'Buka dokumen';

  @override
  String get actionShareDocument => 'Bagikan Dokumen';

  @override
  String get splashTagline => 'Semua dokumen Anda, di satu tempat.';

  @override
  String appVersion(String version) {
    return 'Versi $version';
  }

  @override
  String onboardingStep(int current, int total) {
    return 'Langkah $current dari $total';
  }

  @override
  String get actionSkip => 'Lewati';

  @override
  String get actionBack => 'Kembali';

  @override
  String get actionNext => 'Berikutnya';

  @override
  String get actionGetStarted => 'Mulai';

  @override
  String get onboardingPage1Title => 'Semua dokumen Anda,\ndi satu tempat';

  @override
  String get onboardingPage1Desc =>
      'Doc View otomatis menemukan PDF, Word, Excel, PowerPoint, file teks, dan gambar di ponsel Anda serta merapikannya untuk Anda.';

  @override
  String get onboardingPage2Title => 'Baca apa saja,\ndengan nyaman';

  @override
  String get onboardingPage2Desc =>
      'Buka file PDF, Word, Excel, dan PowerPoint dengan pembaca yang cepat dan bersih. Cari, tandai dengan markah, dan lanjutkan dari halaman terakhir.';

  @override
  String get onboardingPage3Title => 'Alat PDF lengkap, offline';

  @override
  String get onboardingPage3Desc =>
      'Ubah foto menjadi PDF, pindai dokumen, gabungkan, dan pisahkan file. Semuanya tetap di perangkat Anda.';

  @override
  String get onboardingOfflineGuarantee =>
      'File Anda tetap berada di perangkat Anda';

  @override
  String get toolImageToPdf => 'Gambar ke PDF';

  @override
  String get toolImageToPdfSub => 'Konversi JPG & PNG';

  @override
  String get toolScanToPdf => 'Pindai ke PDF';

  @override
  String get toolScanToPdfSub => 'Deteksi tepi kamera';

  @override
  String get toolMergePdf => 'Gabung PDF';

  @override
  String get toolMergePdfSub => 'Satukan menjadi satu';

  @override
  String get toolSplitPdf => 'Pisah PDF';

  @override
  String get toolSplitPdfSub => 'Ekstrak rentang halaman';

  @override
  String get permissionTagStorage => 'Akses Penyimpanan Perangkat';

  @override
  String get permissionStorageHeadline =>
      'Izinkan Doc View menemukan dokumen Anda';

  @override
  String get permissionStorageBody =>
      'Untuk menampilkan file PDF, Word, Excel, dan lainnya yang disimpan oleh aplikasi apa pun, Android memerlukan izin akses ke semua file. File Anda tidak pernah meninggalkan ponsel Anda.';

  @override
  String get permissionReassuranceOfflineTitle => 'File tidak pernah diunggah';

  @override
  String get permissionReassuranceOfflineDesc =>
      'Dokumen Anda diproses secara lokal di perangkat Anda.';

  @override
  String get permissionReassuranceNoUploadsTitle => 'Tanpa unggahan';

  @override
  String get permissionReassuranceNoUploadsDesc =>
      'Tanpa server cloud. File Anda tetap tersimpan hanya di memori ponsel.';

  @override
  String get permissionReassuranceChangeTitle =>
      'Anda dapat mengubahnya kapan saja';

  @override
  String get permissionReassuranceChangeDesc =>
      'Ubah dengan mudah melalui Pengaturan Aplikasi Sistem Android.';

  @override
  String get permissionTagIOS => 'Panduan Penyimpanan iOS';

  @override
  String get permissionIOSHeadline => 'Bawa dokumen Anda ke Doc View';

  @override
  String get permissionIOSBody =>
      'Karena arsitektur privasi Apple, iOS tidak mengizinkan aplikasi mana pun memindai seluruh ponsel secara otomatis. Pilih cara membaca file Anda:';

  @override
  String get permissionIOSOptionImportTitle => 'Impor file';

  @override
  String get permissionIOSBadgeFastest => 'TERCEPAT';

  @override
  String get permissionIOSOptionImportDesc =>
      'Pilih dokumen langsung dari iCloud Drive, Unduhan, atau folder mana pun dalam hitungan detik.';

  @override
  String get permissionIOSOptionFolderTitle =>
      'Buka folder Doc View di aplikasi File';

  @override
  String get permissionIOSOptionFolderDesc =>
      'Simpan atau kirim melalui AirDrop langsung ke folder \"Doc View\" di aplikasi File iOS untuk sinkronisasi instan.';

  @override
  String get actionImportFiles => 'Impor file';

  @override
  String get actionContinueToApp => 'Lanjutkan ke aplikasi';

  @override
  String get permissionTagConsent => 'Transparansi & Persetujuan';

  @override
  String get permissionBadgeFree => 'Aplikasi 100% Gratis';

  @override
  String get permissionBadgeMinimalAds => 'Iklan Minimal';

  @override
  String get permissionConsentHeadline => 'Gratis dengan iklan';

  @override
  String get permissionConsentBody =>
      'Doc View gratis berkat adanya iklan. Berikutnya kami akan meminta pilihan Anda terkait iklan yang dipersonalisasi.';

  @override
  String get permissionConsentAdsTitle => 'Iklan yang mungkin Anda lihat';

  @override
  String get permissionConsentAdsDesc =>
      'Iklan spanduk kecil dan kartu sponsor yang tidak mengganggu. Tidak ada popup atau gangguan video saat membaca.';

  @override
  String get permissionConsentPrivateTitle =>
      'Dokumen tetap sepenuhnya pribadi';

  @override
  String get permissionConsentPrivateDesc =>
      'Mitra iklan tidak pernah memiliki akses ke nama dokumen, isi teks, atau lokasi file Anda.';

  @override
  String get permissionConsentSettingsTitle =>
      'Anda dapat mengubah pilihan di Pengaturan';

  @override
  String get permissionConsentSettingsDesc =>
      'Perbarui persetujuan iklan yang dipersonalisasi atau preferensi privasi kapan saja di Pengaturan Doc View.';

  @override
  String get actionContinue => 'Lanjutkan';

  @override
  String get actionPrivacyPolicy => 'Kebijakan privasi';

  @override
  String filesImportedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file diimpor',
      one: '1 file diimpor',
    );
    return '$_temp0';
  }

  @override
  String get importFailedError => 'Gagal mengimpor file';

  @override
  String get tooltipImportDocuments => 'Impor dokumen';

  @override
  String homeScanProgressCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file ditemukan',
      one: '1 file ditemukan',
    );
    return '$_temp0';
  }

  @override
  String get scanningStatus => 'Memindai...';

  @override
  String fileCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file',
      one: '1 file',
    );
    return '$_temp0';
  }

  @override
  String get categoryFolders => 'Folder';

  @override
  String get errorLoadingRecent => 'Gagal memuat file terbaru';

  @override
  String get emptyStateTitle => 'Kosong';

  @override
  String get emptyRecentDescription =>
      'File yang baru dibuka akan muncul di sini';

  @override
  String get errorLoadingBookmarks => 'Gagal memuat file yang dimarkahi';

  @override
  String get emptyBookmarksDescription =>
      'Dokumen yang dimarkahi akan muncul di sini';

  @override
  String get dialogDeleteTitle => 'Hapus file yang dipilih?';

  @override
  String dialogDeleteBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Hapus $count file? Tindakan ini tidak dapat dibatalkan.',
      one: 'Hapus 1 file? Tindakan ini tidak dapat dibatalkan.',
    );
    return '$_temp0';
  }

  @override
  String filesDeletedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file dihapus',
      one: '1 file dihapus',
    );
    return '$_temp0';
  }

  @override
  String get filesDeleteFailed => 'Gagal menghapus file';

  @override
  String get actionDelete => 'Hapus';

  @override
  String get searchRecentSearchesHeader => 'PENCARIAN TERBARU';

  @override
  String get actionClear => 'Bersihkan';

  @override
  String get searchPromptTitle => 'Ketik untuk mencari dokumen';

  @override
  String get searchPromptMessage =>
      'Cari di seluruh folder lokal berdasarkan nama atau ekstensi file';

  @override
  String get searchError => 'Gagal mencari dokumen';

  @override
  String get searchNoResultsTitle => 'Tidak ada dokumen yang cocok';

  @override
  String get searchNoResultsMessage =>
      'Coba cari dengan kata kunci nama file atau filter format lain';

  @override
  String get tooltipSortOptions => 'Opsi pengurutan';

  @override
  String get sortSheetTitle => 'Urutkan berdasarkan';

  @override
  String get sortOptionDate => 'Tanggal diubah';

  @override
  String get sortOptionName => 'Nama dokumen';

  @override
  String get sortOptionSize => 'Ukuran file';

  @override
  String get sortAscendingOrder => 'Urutan menaik';

  @override
  String get sortAscendingSubtitle => 'Terlama dulu / A ke Z / Terkecil dulu';

  @override
  String get sortDescendingSubtitle => 'Terbaru dulu / Z ke A / Terbesar dulu';

  @override
  String get categoryAllFiles => 'Semua file';

  @override
  String get loadingStatus => 'Memuat...';

  @override
  String get emptyCategoryImagesTitle => 'Tidak ada gambar ditemukan';

  @override
  String get emptyCategoryImagesMessage =>
      'Gambar yang ditemukan di perangkat ini akan muncul di sini';

  @override
  String get emptyCategoryDocsTitle => 'Tidak ada dokumen ditemukan';

  @override
  String get emptyCategoryDocsMessage =>
      'Dokumen dengan format ini akan muncul di sini setelah pemindaian';

  @override
  String get actionOpen => 'Buka';

  @override
  String get actionShare => 'Bagikan';

  @override
  String get actionRename => 'Ubah nama';

  @override
  String get actionBookmark => 'Markahi';

  @override
  String get actionRemoveBookmark => 'Hapus markah';

  @override
  String get actionOpenInAnotherApp => 'Buka di aplikasi lain';

  @override
  String get actionDetails => 'Detail';

  @override
  String get actionOpenFile => 'Buka file';

  @override
  String get actionShareAll => 'Bagikan Semua';

  @override
  String get actionDone => 'Selesai';

  @override
  String get actionSeeAll => 'Lihat Semua';

  @override
  String get actionAllow => 'Izinkan';

  @override
  String get actionNotNow => 'Nanti saja';

  @override
  String get tooltipMoreActions => 'Tindakan lainnya';

  @override
  String get tooltipCopyPath => 'Salin jalur';

  @override
  String get tooltipRotatePage => 'Putar halaman';

  @override
  String get tooltipRemovePage => 'Hapus halaman';

  @override
  String get renameFileTitle => 'Ubah nama file';

  @override
  String get renameFileNameLabel => 'Nama file';

  @override
  String renamedSuccess(String fileName) {
    return 'Nama diubah menjadi $fileName';
  }

  @override
  String get deleteFileTitle => 'Hapus file?';

  @override
  String deleteFileConfirmation(String fileName) {
    return 'Hapus \"$fileName\"? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String deletedFileSuccess(String fileName) {
    return '\"$fileName\" dihapus';
  }

  @override
  String get fileDetailsTitle => 'Detail Dokumen';

  @override
  String get fileDetailsLabelName => 'Nama';

  @override
  String get fileDetailsLabelType => 'Jenis';

  @override
  String get fileDetailsLabelSize => 'Ukuran';

  @override
  String get fileDetailsLabelModified => 'Diubah';

  @override
  String get fileDetailsLabelBookmarked => 'Dimarkahi';

  @override
  String get fileDetailsValueYes => 'Ya';

  @override
  String get fileDetailsValueNo => 'Tidak';

  @override
  String get fileDetailsLabelLocation => 'Lokasi';

  @override
  String get fileDetailsPathCopied => 'Jalur disalin ke papan klip';

  @override
  String get directoriesTitle => 'Direktori';

  @override
  String get directoriesGoBack => 'Kembali';

  @override
  String get directoriesGoToRoot => 'Ke Root';

  @override
  String get directoriesRetry => 'Coba lagi';

  @override
  String get directoriesFileNoLongerExists => 'File sudah tidak ada';

  @override
  String get directoriesFolderNoLongerExists => 'Folder ini sudah tidak ada.';

  @override
  String get directoriesNoDocsInFolder => 'Tidak ada dokumen di folder ini';

  @override
  String get directoriesFilesAppearHere =>
      'File akan muncul di sini setelah ditambahkan';

  @override
  String directoriesFolderSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get directoriesFolderSubtitleDefault => 'Folder';

  @override
  String get directoriesPermissionPromptTitle =>
      'Akses diperlukan untuk melihat direktori';

  @override
  String get directoriesPermissionPromptBody =>
      'Doc View memerlukan akses Semua file untuk menelusuri folder Anda.';

  @override
  String get directoriesGrantAccess => 'Berikan akses';

  @override
  String get directoriesImportInstead => 'Impor file saja';

  @override
  String directoriesImportedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file diimpor',
      one: '1 file diimpor',
    );
    return '$_temp0';
  }

  @override
  String get directoriesTooltipUp => 'Naik satu tingkat';

  @override
  String get storageAccessRequiredTitle => 'Akses Penyimpanan Diperlukan';

  @override
  String get storageAccessRequiredBody =>
      'Doc View memerlukan akses penyimpanan untuk memindai dan menampilkan dokumen (PDF, Word, Excel, PPT, TXT, Gambar) yang tersimpan di perangkat Anda.\n\nFile Anda tetap sepenuhnya pribadi dan offline di perangkat Anda.';

  @override
  String errorCouldNotOpenDocument(String error) {
    return 'Tidak dapat membuka dokumen: $error';
  }

  @override
  String scanCompleteWithCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pemindaian selesai: $count file',
      one: 'Pemindaian selesai: 1 file',
    );
    return '$_temp0';
  }

  @override
  String get dialogClearSearchTitle => 'Hapus riwayat pencarian?';

  @override
  String get dialogClearSearchMessage =>
      'Semua pencarian terbaru akan dihapus secara permanen.';

  @override
  String imageListEditorMaxLimit(int max) {
    return 'Batas maksimum $max gambar telah tercapai.';
  }

  @override
  String imageListEditorScanFailed(String error) {
    return 'Pemindaian gagal: $error';
  }

  @override
  String get imageListEditorPageSize => 'Ukuran Halaman:';

  @override
  String get imageListEditorA4Mode => 'A4';

  @override
  String get imageListEditorFitMode => 'Sesuaikan gambar';

  @override
  String get imageListEditorRemoveImageTooltip => 'Hapus gambar';

  @override
  String get mergeScreenTitle => 'Atur & gabungkan';

  @override
  String get mergeScreenDefaultMergedName => 'Dokumen_Gabungan';

  @override
  String get mergePickerSearchHint => 'Cari PDF...';

  @override
  String get mergePickerNext => 'Berikutnya';

  @override
  String mergePickerErrorLoading(String error) {
    return 'Gagal memuat PDF: $error';
  }

  @override
  String get splitScreenTitle => 'Pisah PDF';

  @override
  String get splitScreenRangeHint => 'mis. 1-3, 5, 8-10';

  @override
  String get splitScreenClearRange => 'Hapus rentang';

  @override
  String get splitPickerSearchHint => 'Cari PDF...';

  @override
  String splitPickerErrorLoading(String error) {
    return 'Gagal memuat file: $error';
  }

  @override
  String get createdSectionTitle => 'Dibuat oleh Anda';

  @override
  String get createdSectionEmptyTitle =>
      'PDF yang Anda buat akan muncul di sini';

  @override
  String get createdSectionEmptySubtitle =>
      'Dokumen hasil konversi, pindaian, atau gabungan akan disimpan secara lokal.';

  @override
  String get emptyCreatedDocsTitle => 'Belum ada dokumen yang dibuat';

  @override
  String get emptyCreatedDocsMessage =>
      'Dokumen hasil konversi, pindaian, atau gabungan akan muncul di sini.';

  @override
  String errorLoadingCreatedFiles(String error) {
    return 'Gagal memuat file yang dibuat: $error';
  }

  @override
  String toolResultPdfCreated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count PDF Dibuat',
      one: 'PDF Dibuat',
    );
    return '$_temp0';
  }

  @override
  String get toolResultSavedSubtitle => 'Disimpan ke folder Dibuat oleh Anda';

  @override
  String get toolErrorDefaultTitle => 'Tidak dapat membuat PDF';

  @override
  String get toolErrorSubtitle =>
      'Terjadi kesalahan tak terduga saat memproses';

  @override
  String get themeSheetTitle => 'Tema aplikasi';

  @override
  String get themeSheetSubtitle => 'Pilih tampilan visual untuk Doc View';

  @override
  String get themeModeSystem => 'Sistem';

  @override
  String get themeModeSystemSubtitle => 'default';

  @override
  String get themeModeLight => 'Terang';

  @override
  String get themeModeLightSubtitle => 'Putih bersih';

  @override
  String get themeModeDark => 'Gelap';

  @override
  String get themeModeDarkSubtitle => 'Biru dongker pekat';

  @override
  String get themeActionApply => 'Terapkan tema';

  @override
  String get scanSettingsTitle => 'Pengaturan pemindaian';

  @override
  String get scanSettingsFrequencyHeader => 'Frekuensi pemindaian';

  @override
  String get scanSettingsOnOpenTitle => 'Pindai saat aplikasi dibuka';

  @override
  String get scanSettingsOnOpenSubtitle =>
      'Temukan file baru secara otomatis saat Anda membuka Doc View.';

  @override
  String get scanSettingsManualTitle => 'Manual saja';

  @override
  String get scanSettingsManualSubtitle =>
      'Hanya pindai saat Anda menarik untuk menyegarkan atau mengetuk Pindai ulang.';

  @override
  String get scanSettingsMediaFiltersHeader => 'Filter media';

  @override
  String get scanSettingsIncludeImagesTitle =>
      'Sertakan gambar dalam pemindaian';

  @override
  String get scanSettingsIncludeImagesSubtitle =>
      'Indeks file gambar PNG, JPG, dan WEBP di penyimpanan.';

  @override
  String get scanSettingsDiagnosticsHeader => 'Penyimpanan & diagnostik';

  @override
  String get scanSettingsPermissionStatus => 'Akses semua file';

  @override
  String get scanSettingsPermissionGranted => 'Diizinkan';

  @override
  String get scanSettingsPermissionNotGranted => 'Belum diizinkan';

  @override
  String get scanSettingsTotalIndexed => 'File terindeks';

  @override
  String get scanSettingsLastScan => 'Terakhir dipindai';

  @override
  String get scanSettingsUpdatedSnackbar => 'Pengaturan pemindaian diperbarui';

  @override
  String get faqScreenTitle => 'Pertanyaan yang Sering Diajukan';

  @override
  String faqHeaderTopics(int count) {
    return '$count Topik';
  }

  @override
  String get faqHeaderSubtitle =>
      'Punya pertanyaan? Temukan jawaban jelasnya di sini.';

  @override
  String get faqSendFeedback => 'Kirim masukan';

  @override
  String get faqQuestion1 => 'Mengapa Doc View memerlukan akses Semua file?';

  @override
  String get faqAnswer1 =>
      'Doc View memerlukan akses Semua file (MANAGE_EXTERNAL_STORAGE) di Android 11+ untuk menemukan dan mengindeks dokumen yang didukung (PDF, Word, Excel, PowerPoint, Teks, dan Gambar) yang tersimpan di folder bersama seperti Unduhan dan Dokumen.\n\nTanpa izin ini, Android membatasi akses file hanya ke folder internal pribadi aplikasi, sehingga Doc View tidak dapat menelusuri atau membuka file di seluruh perangkat Anda.';

  @override
  String get faqQuestion2 =>
      'Mengapa aplikasi tidak memindai seluruh iPhone saya?';

  @override
  String get faqAnswer2 =>
      'iOS menggunakan pembatasan aplikasi (sandboxing) yang ketat untuk melindungi privasi perangkat. Aplikasi hanya dapat mengakses dokumen yang disimpan secara eksplisit di dalam aplikasi File atau dibagikan melalui menu Bagikan sistem.\n\nUntuk melihat file di iOS, impor file ke folder Doc View di aplikasi File bawaan atau gunakan opsi Impor file di Pengaturan.';

  @override
  String get faqQuestion3 => 'Di mana PDF yang saya buat disimpan?';

  @override
  String get faqAnswer3 =>
      'File yang Anda impor atau buat (seperti PDF hasil konversi, dokumen gabungan, atau halaman yang dipisahkan) disimpan dengan aman di penyimpanan perangkat Anda pada folder DocView/Created atau penyimpanan pribadi aplikasi. Anda dapat melihatnya kapan saja di bagian Dibuat oleh Anda pada tab Alat.';

  @override
  String get faqQuestion4 => 'Mengapa tampilan file Word saya berbeda?';

  @override
  String get faqAnswer4 =>
      'Doc View merender file langsung di perangkat Anda menggunakan parser offline lokal tanpa mengirim data pribadi ke konverter cloud. Pemformatan kompleks atau bentuk khusus dirender dengan penyesuaian offline bawaan.';

  @override
  String get faqQuestion5 =>
      'Bisakah saya membuka file yang dilindungi kata sandi?';

  @override
  String get faqAnswer5 =>
      'Ya, Doc View mendukung pembukaan dokumen PDF yang dilindungi kata sandi. Saat membuka PDF terenkripsi, masukkan kata sandi pada dialog untuk mendekripsi dan melihat dokumen di perangkat Anda.';

  @override
  String get faqQuestion6 => 'Apakah data saya diunggah ke mana pun?';

  @override
  String get faqAnswer6 =>
      'Dokumen Anda tidak pernah meninggalkan perangkat Anda. Doc View membuka, mengonversi, dan menyimpan file secara lokal. Aplikasi menampilkan iklan yang disajikan oleh Google AdMob, yang dapat menggunakan data perangkat terbatas sebagaimana dijelaskan dalam Kebijakan Privasi kami.';

  @override
  String get faqQuestion7 =>
      'Mengapa konversi PDF ke Word mengubah tata letak saya?';

  @override
  String get faqAnswer7 =>
      'Doc View hanya mengonversi teks secara langsung di perangkat Anda. Tabel, gambar, warna, dan tata letak tidak dipertahankan. PDF hasil pindaian tidak dapat dikonversi karena tidak ada teks yang dapat dibaca.';

  @override
  String get toolPdfToWord => 'PDF ke Word';

  @override
  String get toolPdfToWordSub =>
      'Konversi PDF menjadi dokumen Word yang dapat diedit';

  @override
  String get pdfToWordScreenTitle => 'PDF ke Word';

  @override
  String get pdfToWordBannerText =>
      'Hanya teks yang dikonversi. Tabel, gambar, warna, dan tata letak tidak dipertahankan.';

  @override
  String get pdfToWordPageBreaks =>
      'Sisipkan pemisah halaman di antara halaman PDF';

  @override
  String get pdfToWordPageBreaksSubtitle =>
      'Menjaga struktur dokumen antarhalaman';

  @override
  String get pdfToWordSelectPdf => 'Pilih PDF';

  @override
  String get pdfToWordChangeFile => 'Ganti file';

  @override
  String get pdfToWordConvertAction => 'Konversi ke Word';

  @override
  String get pdfToWordConverting => 'Mengonversi ke Word...';

  @override
  String pdfToWordConvertingProgress(int current, int total) {
    return 'Mengonversi halaman $current dari $total...';
  }

  @override
  String get pdfToWordSuccess => 'Berhasil dikonversi ke Word';

  @override
  String get pdfToWordOpenInViewer => 'Buka di Doc View';

  @override
  String get pdfToWordOpenWith => 'Buka dengan...';

  @override
  String get pdfToWordShare => 'Bagikan';

  @override
  String get pdfToWordNoTextTitle => 'Teks tidak ditemukan';

  @override
  String get pdfToWordNoTextMessage =>
      'Tidak ditemukan teks dalam PDF ini. Dokumen hasil pindaian tidak dapat dikonversi.';

  @override
  String get pdfToWordLargeFileWarning =>
      'Dokumen besar: konversi mungkin memerlukan waktu beberapa menit.';

  @override
  String get pdfToWordInvalidFileName => 'Nama file tidak valid';

  @override
  String get pdfToWordActionCancel => 'Batal';

  @override
  String get pdfToWordEncryptedError =>
      'PDF yang dipilih dilindungi kata sandi. Harap buka kuncinya untuk mengonversi.';

  @override
  String get pdfToWordPageLimitError => 'Dokumen melebihi batas 1.000 halaman.';

  @override
  String get pdfToWordTextLimitError => 'Dokumen melebihi batas teks 20 MB.';

  @override
  String get pdfToWordGeneralError =>
      'Gagal mengonversi PDF ke Word. Silakan coba file lain.';

  @override
  String get pdfGotoPageTitle => 'Buka halaman';

  @override
  String pdfGotoPageHint(int pageCount) {
    return 'Masukkan halaman antara 1 dan $pageCount';
  }

  @override
  String get pdfGotoPageAction => 'Buka';

  @override
  String get pdfGotoPageErrorEmpty => 'Masukkan nomor halaman';

  @override
  String pdfGotoPageErrorOutOfRange(int pageCount) {
    return 'Masukkan halaman antara 1 dan $pageCount';
  }

  @override
  String get pdfPasswordTitle => 'PDF ini dilindungi kata sandi';

  @override
  String get pdfPasswordSubtitle =>
      'Masukkan kata sandi untuk melihat dan mendekripsi isinya.';

  @override
  String get pdfPasswordHint => 'Masukkan kata sandi';

  @override
  String get pdfPasswordErrorIncorrect => 'Kata sandi salah. Coba lagi.';

  @override
  String get pdfPasswordActionUnlock => 'Buka kunci';

  @override
  String get errorFileNameEmpty => 'Nama file tidak boleh kosong';

  @override
  String get errorFileNameTooLong =>
      'Nama file tidak boleh lebih dari 120 karakter';

  @override
  String get errorFileNameReserved => 'Nama file tidak boleh \'.\' atau \'..\'';

  @override
  String get errorFileNameStartsWithDot =>
      'Nama file tidak boleh diawali titik';

  @override
  String get errorFileNameInvalidChars =>
      'Nama file mengandung karakter tidak valid';

  @override
  String get errorRenameAlreadyExists =>
      'File dengan nama ini sudah ada di folder ini';

  @override
  String get errorRenameSourceNotFound =>
      'File sumber sudah tidak ada di penyimpanan';

  @override
  String errorRenameFailed(String details) {
    return 'Gagal mengubah nama file: $details';
  }

  @override
  String get errorDeleteDatabaseFailed =>
      'File telah dihapus dari penyimpanan, tetapi pembaruan basis data gagal';

  @override
  String errorDeleteFailed(String details) {
    return 'Gagal menghapus file: $details';
  }

  @override
  String get errorPageRangeDocNoPages => 'Dokumen tidak memiliki halaman';

  @override
  String get errorPageRangeEmpty => 'Rentang halaman tidak boleh kosong';

  @override
  String get errorPageRangeEmptySegment =>
      'Ditemukan bagian rentang yang kosong. Hapus koma berlebih.';

  @override
  String errorPageRangeInvalidFormat(String token) {
    return 'Format rentang tidak valid: \'$token\'';
  }

  @override
  String errorPageRangeIncomplete(String token) {
    return 'Rentang tidak lengkap: \'$token\'';
  }

  @override
  String errorPageRangeNonNumeric(String token) {
    return 'Nilai non-numerik dalam rentang: \'$token\'';
  }

  @override
  String get errorPageRangeBelowMinimum => 'Nomor halaman harus 1 atau lebih';

  @override
  String errorPageRangeReversed(int start, int end) {
    return 'Rentang terbalik \'$start-$end\': awal lebih besar daripada akhir';
  }

  @override
  String errorPageRangeExceeds(String token, int totalPages) {
    return 'Rentang \'$token\' melebihi jumlah halaman ($totalPages)';
  }

  @override
  String errorPageRangeInvalidNumber(String token) {
    return 'Nomor halaman tidak valid: \'$token\'';
  }

  @override
  String get errorImageToPdfNoImages => 'Pilih setidaknya satu gambar';

  @override
  String errorImageToPdfMaxExceeded(int max) {
    return 'Maksimal $max gambar diperbolehkan sekaligus';
  }

  @override
  String errorImageToPdfProcessingFailed(String path) {
    return 'Gagal memproses gambar: $path';
  }

  @override
  String errorImageToPdfGenerationFailed(String details) {
    return 'Gagal membuat PDF dari gambar: $details';
  }

  @override
  String get errorPdfMergeInsufficient =>
      'Pilih setidaknya 2 file PDF untuk digabungkan';

  @override
  String errorPdfMergeDamagedOrEncrypted(String fileName) {
    return '$fileName dilindungi kata sandi atau rusak';
  }

  @override
  String get errorPdfMergeNoPages =>
      'Dokumen yang dipilih tidak memiliki halaman';

  @override
  String errorPdfMergeFailed(String details) {
    return 'Penggabungan PDF gagal: $details';
  }

  @override
  String get errorPdfSplitNoRanges =>
      'Tentukan setidaknya satu rentang halaman';

  @override
  String errorPdfSplitDamagedOrEncrypted(String fileName) {
    return '$fileName dilindungi kata sandi atau rusak';
  }

  @override
  String errorPdfSplitRangeOutOfBounds(int start, int end, String fileName) {
    return 'Rentang $start-$end berada di luar batas untuk $fileName';
  }

  @override
  String errorPdfSplitFailed(String details) {
    return 'Gagal memisahkan PDF: $details';
  }

  @override
  String fileDetailsPageChip(int current, int total) {
    return 'HAL $current/$total';
  }

  @override
  String fileDetailsBytes(String bytes) {
    return '($bytes byte)';
  }

  @override
  String get directoriesProtectedTitle => 'Folder ini dilindungi oleh Android.';

  @override
  String get directoriesProtectedDesc =>
      'Android membatasi akses ke folder sistem dan folder pribadi aplikasi.';

  @override
  String get directoriesNotFoundTitle => 'Folder ini sudah tidak ada.';

  @override
  String get directoriesEmpty =>
      'Tidak ada file atau folder yang didukung di sini.';

  @override
  String get directoriesErrorOpening => 'Gagal membuka folder';

  @override
  String get directoriesRoot => 'Root';

  @override
  String get scanSettingsSectionFrequency => 'Frekuensi pemindaian';

  @override
  String get scanSettingsSectionFilters => 'Filter dokumen';

  @override
  String get scanSettingsIncludeImages => 'Sertakan gambar';

  @override
  String get scanSettingsIncludeImagesDesc =>
      'Nonaktifkan untuk menyembunyikan ribuan foto dari daftar dokumen Anda';

  @override
  String get scanSettingsImageListUpdated => 'Daftar gambar diperbarui';

  @override
  String get scanSettingsActionRescanNow => 'Pindai ulang sekarang';

  @override
  String get scanSettingsSectionDiagnostics => 'Diagnostik penyimpanan';

  @override
  String get scanSettingsAllFilesAccessGranted => 'Akses semua file diizinkan';

  @override
  String get scanSettingsAllFilesAccessNeeded => 'Akses semua file diperlukan';

  @override
  String get scanSettingsAllFilesAccessGrantedDesc =>
      'Doc View memiliki izin untuk menemukan file di Unduhan dan kartu SD.';

  @override
  String get scanSettingsAllFilesAccessNeededDesc =>
      'Izin diperlukan untuk memindai folder unduhan dan penyimpanan eksternal.';

  @override
  String get scanSettingsActionOpenSettings => 'Buka pengaturan';

  @override
  String scanSettingsScanningFiles(int count) {
    return 'Memindai... $count file ditemukan';
  }

  @override
  String get faqStillNeedHelp => 'Masih butuh bantuan? Kirim masukan';

  @override
  String get toolsLabelFileName => 'Nama File';

  @override
  String get toolsAddImagesToStart => 'Tambahkan gambar untuk memulai';

  @override
  String get toolsAddImagesDesc =>
      'Pilih foto atau pindai dokumen kertas untuk membuat PDF.';

  @override
  String get toolsChoosePhotos => 'Pilih foto';

  @override
  String get toolsScanPaper => 'Pindai kertas';

  @override
  String toolsPageNumber(int page) {
    return 'Halaman $page';
  }

  @override
  String get toolsTooltipRotatePage => 'Putar halaman';

  @override
  String get toolsTooltipRemovePage => 'Hapus halaman';

  @override
  String get toolsAddMoreScans => 'Tambah hasil pindai lagi';

  @override
  String get toolsAddMoreImages => 'Tambah gambar lagi';

  @override
  String toolsImageSummary(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gambar · est. ~ $size',
      one: '1 gambar · est. ~ $size',
    );
    return '$_temp0';
  }

  @override
  String toolsSelectedCount(int count) {
    return '$count dipilih';
  }

  @override
  String toolsSelectAtLeast(int min) {
    return 'Pilih setidaknya $min file';
  }

  @override
  String toolsPagesTotal(int count) {
    return 'Total $count halaman';
  }

  @override
  String get toolsPagesTotalLabel => 'total halaman';

  @override
  String get toolsNoPdfsFound => 'Tidak ada dokumen PDF ditemukan';

  @override
  String get semanticBookmarked => 'dimarkahi';

  @override
  String get semanticSelected => 'dipilih';

  @override
  String get semanticNotSelected => 'tidak dipilih';

  @override
  String get actionDeselectFile => 'Batal pilih file';

  @override
  String get actionSelectFile => 'Pilih file';

  @override
  String get actionCreatePdf => 'Buat PDF';

  @override
  String get hintSelectOrViewActions => 'Pilih atau lihat tindakan';

  @override
  String get actionClose => 'Tutup';

  @override
  String get actionReset => 'Atur ulang';

  @override
  String get labelPleaseWait => 'Harap tunggu...';

  @override
  String get tooltipCloseSearch => 'Tutup pencarian';

  @override
  String get semanticAdvertisement => 'Iklan';

  @override
  String get themePreviewLight => 'Terang';

  @override
  String get themePreviewNavy => 'Navy';

  @override
  String createdByYouItemSemantic(String name, String size, String date) {
    return '$name, $size, dibuat $date';
  }

  @override
  String get toolsCreatingPdfFromScans => 'Membuat PDF dari Pindaian';

  @override
  String get toolsCreatingPdf => 'Membuat PDF';

  @override
  String toolsProcessingImageProgress(int done, int total) {
    return 'Memproses gambar $done dari $total...';
  }

  @override
  String get toolsErrorCreatePdfTitle => 'Tidak dapat membuat PDF';

  @override
  String get toolsBadgeProtectedOrDamaged => 'Dilindungi atau rusak';

  @override
  String toolsPageCountPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count halaman',
      one: '1 halaman',
    );
    return '$_temp0';
  }

  @override
  String get toolsPagesAbbrev => 'hal.';

  @override
  String get mergeAddMoreTitle => 'Tambah PDF Lainnya';

  @override
  String get mergeProgressTitle => 'Menggabungkan PDF';

  @override
  String mergeProgressMessage(int done, int total) {
    return 'Menggabungkan dokumen $done dari $total...';
  }

  @override
  String get mergeErrorTitle => 'Tidak dapat menggabungkan PDF';

  @override
  String get mergeDragInstruction => 'Seret pegangan untuk mengubah urutan';

  @override
  String get mergeAddPdf => 'Tambah PDF';

  @override
  String get mergeOutputFileNameLabel => 'NAMA FILE OUTPUT';

  @override
  String mergeItemPageCountAndSize(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count halaman · $size',
      one: '1 halaman · $size',
    );
    return '$_temp0';
  }

  @override
  String mergeItemLoadingPagesAndSize(String size) {
    return 'Memuat halaman... · $size';
  }

  @override
  String mergeInvalidFilesDetected(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file tidak valid terdeteksi',
      one: '1 file tidak valid terdeteksi',
    );
    return '$_temp0';
  }

  @override
  String get mergeReadyTitle => 'Siap digabungkan';

  @override
  String get mergeRemoveProtectedHint =>
      'Harap hapus dokumen yang dilindungi kata sandi';

  @override
  String mergeSummary(int files, int pages, String size) {
    return '$files file · $pages halaman · ~ $size';
  }

  @override
  String get mergeReadyBadge => 'Siap';

  @override
  String get mergeBlockedCta => 'Penggabungan Terblokir (Atasi Kesalahan)';

  @override
  String mergeActionCta(int files, int pages) {
    return 'Gabungkan $files PDF ($pages Halaman)';
  }

  @override
  String get mergePickerDefaultTitle => 'Pilih PDF';

  @override
  String mergePickerTabAllPdfs(int count) {
    return 'Semua PDF ($count)';
  }

  @override
  String get mergePickerTabRecent => 'Terbaru';

  @override
  String get mergePickerTabDownloads => 'Unduhan';

  @override
  String get mergePickerTabICloud => 'iCloud Drive';

  @override
  String get splitProgressTitle => 'Memisahkan PDF';

  @override
  String splitProgressMessage(int done, int total) {
    return 'Membuat file $done dari $total...';
  }

  @override
  String get splitErrorTitle => 'Tidak dapat memisahkan PDF';

  @override
  String get splitPageRangesLabel => 'RENTANG HALAMAN';

  @override
  String get splitPageRangesSyntax => 'Sintaks: 1-3, 5, 8-10';

  @override
  String get splitRangeHelpText =>
      'Setiap rentang akan menjadi file PDF terpisah.';

  @override
  String splitGeneratedFilesHeader(int count) {
    return 'FILE YANG DIHASILKAN ($count)';
  }

  @override
  String get splitChipsSuspendedTitle => 'Chip Langsung Ditangguhkan';

  @override
  String get splitChipsSuspendedDesc =>
      'Perbaiki kesalahan sintaks di atas untuk menyusun ulang alur ekstraksi.';

  @override
  String get splitEmptyRangesHint =>
      'Masukkan rentang halaman di atas untuk membuat pecahan PDF';

  @override
  String splitChipSinglePage(int page) {
    return 'Halaman $page';
  }

  @override
  String splitChipPageRange(int start, int end) {
    return 'Halaman $start–$end';
  }

  @override
  String splitChipPageCountShort(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hal.',
      one: '1 hal.',
    );
    return '$_temp0';
  }

  @override
  String get splitQuickSelectLabel => 'PILIH CEPAT';

  @override
  String get splitMacroAllPages => 'Semua halaman';

  @override
  String get splitMacroEvery5Pages => 'Setiap 5 halaman';

  @override
  String get splitMacroLimitHint =>
      'Makro yang menghasilkan > 100 file dinonaktifkan untuk melindungi memori perangkat';

  @override
  String splitOutputSummary(int files, int pages) {
    return 'Output: $files file · $pages halaman diekstrak';
  }

  @override
  String splitEstSize(String size) {
    return 'EST ~ $size';
  }

  @override
  String splitActionCtaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pisahkan menjadi $count PDF',
      one: 'Pisahkan menjadi 1 PDF',
    );
    return '$_temp0';
  }

  @override
  String get splitActionCtaEmpty => 'Pisahkan menjadi PDF';

  @override
  String splitPickerAllLocalDocs(int count) {
    return 'SEMUA DOKUMEN LOKAL ($count)';
  }

  @override
  String get splitPickerSortByDate => 'URUTKAN BERDASARKAN TANGGAL';

  @override
  String splitPickerLoadingPagesAndSize(String size) {
    return 'hal. · $size';
  }

  @override
  String get splitPickerTitle => 'Pilih PDF untuk dipisahkan';

  @override
  String get faqShortTitle => 'FAQ';

  @override
  String splitPickerSelectedCount(int count) {
    return '$count PDF dipilih';
  }

  @override
  String get splitPickerSelectDocumentHint => 'Pilih dokumen untuk melanjutkan';

  @override
  String splitPickerPagesActive(int count) {
    return '$count halaman aktif';
  }

  @override
  String get splitPickerPagesActiveLabel => 'halaman aktif';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsSectionGeneral => 'Umum';

  @override
  String get settingsSectionOthers => 'Lainnya';

  @override
  String get settingsFileManagerTitle => 'Pengelola file';

  @override
  String get settingsFileManagerSubtitle =>
      'Telusuri direktori dan folder penyimpanan';

  @override
  String get settingsFaqTitle => 'FAQ';

  @override
  String get settingsFaqSubtitle => 'Pertanyaan yang sering diajukan';

  @override
  String get settingsShareTitle => 'Bagikan';

  @override
  String get settingsShareSubtitle => 'Rekomendasikan Doc View kepada teman';

  @override
  String settingsShareMessage(String url) {
    return 'Coba Doc View - Pembaca dokumen cepat, pribadi, dan offline: $url';
  }

  @override
  String get settingsScanSettingsTitle => 'Pengaturan pemindaian';

  @override
  String get settingsScanModeOnOpen => 'Pindai saat dibuka';

  @override
  String get settingsScanModeManual => 'Manual saja';

  @override
  String get settingsAppThemeTitle => 'Tema aplikasi';

  @override
  String get settingsThemeSystem => 'Default sistem';

  @override
  String get settingsThemeLight => 'Terang';

  @override
  String get settingsThemeDark => 'Gelap';

  @override
  String get settingsLanguageTitle => 'Bahasa';

  @override
  String get settingsRateUsTitle => 'Beri nilai';

  @override
  String get settingsRateUsSubtitle => 'Bagikan masukan Anda kepada kami';

  @override
  String get settingsAddWidgetTitle => 'Tambahkan Widget';

  @override
  String get settingsAddWidgetSubtitle => 'Akses cepat dari layar utama Anda';

  @override
  String get settingsTermsTitle => 'Ketentuan penggunaan';

  @override
  String get settingsTermsSubtitle => 'Baca ketentuan layanan kami';

  @override
  String get settingsPrivacyTitle => 'Kebijakan privasi';

  @override
  String get settingsPrivacySubtitle => 'Baca kebijakan privasi kami';

  @override
  String get settingsManageSubscriptionsTitle => 'Kelola langganan';

  @override
  String get settingsManageSubscriptionsSubtitle =>
      'Kelola langganan toko Anda';

  @override
  String settingsVersionDisplay(String version, String build) {
    return 'Versi $version ($build)';
  }

  @override
  String settingsVersionSemantics(String version, String build) {
    return 'Versi $version build $build';
  }

  @override
  String get settingsOpenSourceLicenses => 'Lisensi sumber terbuka';

  @override
  String get rateSheetTitle => 'Beri nilai Doc View';

  @override
  String get rateSheetSubtitle => 'Masukan Anda membantu kami berkembang';

  @override
  String rateStarSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bintang',
      one: '1 bintang',
    );
    return '$_temp0';
  }

  @override
  String get rateResponseHigh => 'Senang Anda menyukainya!';

  @override
  String get rateResponseMedium =>
      'Terima kasih! Beri tahu kami cara meningkatkannya.';

  @override
  String get rateResponseLow =>
      'Maaf jika belum memuaskan. Beri tahu kami apa yang perlu diperbaiki.';

  @override
  String get rateActionStore => 'Beri nilai di Google Play';

  @override
  String get rateActionHelpFeedback => 'Bantuan & masukan';

  @override
  String get faqFromRatingBanner =>
      'Maaf mendengarnya. Baca jawaban di bawah atau hubungi kami; kami membaca setiap pesan.';

  @override
  String get faqActionContactUs => 'Hubungi kami';

  @override
  String faqFeedbackEmailSubject(String version, String build) {
    return 'Masukan Doc View ($version+$build)';
  }

  @override
  String faqFeedbackEmailBody(String version, String build) {
    return '\n\n---\nAplikasi: Doc View $version (Build $build)\n';
  }

  @override
  String get faqEmailClientUnavailable => 'Tidak dapat membuka aplikasi email';

  @override
  String get languageScreenTitle => 'Bahasa';

  @override
  String get languageSearchHint => 'Cari bahasa...';

  @override
  String get languageSystemDefault => 'Default sistem';

  @override
  String get languageSystemDefaultSubtitle => 'Ikuti bahasa perangkat';

  @override
  String get languageNotTranslatedBadge => '(belum diterjemahkan)';

  @override
  String get languageNotTranslatedSnack => 'Bahasa ini belum diterjemahkan';

  @override
  String get languageNoResults => 'Tidak ada bahasa yang cocok';

  @override
  String get languagePseudoLocaleName => 'Pseudo-locale (en_XA)';

  @override
  String get languagePseudoLocaleSubtitle => 'Pengujian ekspansi debug';

  @override
  String get scanSettingsSectionHistory => 'Riwayat';

  @override
  String get scanSettingsClearHistoryTitle => 'Hapus riwayat terbaru';

  @override
  String get scanSettingsClearHistorySubtitle =>
      'Hapus riwayat dokumen yang dibuka';

  @override
  String get scanSettingsClearHistoryDialogTitle => 'Hapus riwayat terbaru?';

  @override
  String get scanSettingsClearHistoryDialogBody =>
      'File akan dihapus dari Terbaru. File dan markah Anda tidak terpengaruh.';

  @override
  String get scanSettingsRecentHistoryCleared => 'Riwayat terbaru dihapus';

  @override
  String get scanSettingsLastScanToday => 'hari ini';

  @override
  String get scanSettingsLastScanYesterday => 'kemarin';

  @override
  String get scanSettingsNeverScanned => 'Belum pernah dipindai';

  @override
  String get scanSettingsLastScanPrefix => 'Pemindaian terakhir:';

  @override
  String get readerActionVertical => 'Vertikal';

  @override
  String get readerActionHorizontal => 'Horizontal';

  @override
  String get readerActionRotate => 'Putar';

  @override
  String get readerActionSearch => 'Cari';

  @override
  String get readerActionInvert => 'Balikkan warna';

  @override
  String get readerActionShare => 'Bagikan';

  @override
  String get readerActionPages => 'Halaman';

  @override
  String get readerSearchHint => 'Cari dalam dokumen...';

  @override
  String readerSearchMatchCounter(int current, int total) {
    return '$current dari $total';
  }

  @override
  String get readerSearchMatchCap => '500+';

  @override
  String get readerSearchNoMatches => '0 dari 0';

  @override
  String get readerSearchNoTextLayer =>
      'PDF ini tidak memiliki teks yang dapat dicari';

  @override
  String get readerSearchPrevMatch => 'Hasil sebelumnya';

  @override
  String get readerSearchNextMatch => 'Hasil berikutnya';

  @override
  String readerTopPagesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Halaman • $size',
      one: '1 Halaman • $size',
    );
    return '$_temp0';
  }

  @override
  String get readerMenuGoToPage => 'Buka halaman';

  @override
  String get readerMenuAddBookmark => 'Tambahkan markah';

  @override
  String get readerMenuRemoveBookmark => 'Hapus markah';

  @override
  String get readerMenuDetails => 'Detail';

  @override
  String get readerMenuOpenInAnotherApp => 'Buka di aplikasi lain';

  @override
  String get readerTooltipConvertToWord => 'Konversi ke Word';

  @override
  String get pagesScreenTitle => 'Halaman';

  @override
  String pagesScreenPageCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Halaman',
      one: '1 Halaman',
    );
    return '$_temp0';
  }

  @override
  String get pagesActionSelectAll => 'Pilih semua';

  @override
  String get pagesActionClearSelection => 'Bersihkan';

  @override
  String get pagesActionSave => 'Simpan';

  @override
  String get pagesActionInsert => 'Sisipkan';

  @override
  String get pagesActionRotate => 'Putar';

  @override
  String get pagesActionExtract => 'Ekstrak';

  @override
  String get pagesActionDelete => 'Hapus';

  @override
  String get pagesActionUndo => 'Urungkan';

  @override
  String get pagesInsertSheetTitle => 'Sisipkan halaman';

  @override
  String get pagesInsertPagesFromPdf => 'Halaman dari PDF lain';

  @override
  String get pagesDeleteAllBlocked =>
      'Tidak dapat menghapus semua halaman. Dokumen harus memiliki minimal satu halaman.';

  @override
  String get pagesSaveDialogTitle => 'Simpan perubahan';

  @override
  String get pagesSaveAsNew => 'Simpan sebagai file baru';

  @override
  String get pagesSaveReplace => 'Ganti file asli';

  @override
  String get pagesSaveReplaceWarning => 'Tindakan ini akan menimpa file asli.';

  @override
  String get pagesSaveFileNameLabel => 'Nama file';

  @override
  String get pagesDiscardDialogTitle => 'Buang perubahan?';

  @override
  String get pagesDiscardDialogBody =>
      'Anda memiliki perubahan yang belum disimpan. Yakin ingin membuangnya?';

  @override
  String get pagesDiscardButton => 'Buang';

  @override
  String pagesExtractSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count halaman diekstrak',
      one: '1 halaman diekstrak',
    );
    return '$_temp0';
  }

  @override
  String get pagesErrorUnreadable =>
      'PDF ini tidak dapat diedit karena terenkripsi atau tidak dapat dibaca.';

  @override
  String get viewerErrorCorruptTitle => 'Tidak dapat membuka dokumen ini';

  @override
  String get viewerErrorCorruptMessage =>
      'File ini tampaknya rusak atau bukan dokumen yang valid.';

  @override
  String get viewerErrorMissingTitle => 'File ini sudah tidak ada';

  @override
  String get viewerErrorMissingMessage =>
      'File telah dihapus atau dipindahkan dari penyimpanan perangkat.';

  @override
  String get viewerErrorBackToFiles => 'Kembali ke daftar file';

  @override
  String get viewerErrorNoAppFound =>
      'Tidak ditemukan aplikasi untuk membuka file ini';

  @override
  String readerSearchTotalMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hasil cocok',
      one: '1 hasil cocok',
    );
    return '$_temp0';
  }

  @override
  String viewerOfficeUnitsSubtitle(int count, String ext) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count unit • $ext',
      one: '1 unit • $ext',
    );
    return '$_temp0';
  }

  @override
  String get viewerLegacyFormatBanner => 'Format lama: hanya teks';

  @override
  String get viewerSpreadsheetTruncatedBanner =>
      'Buku kerja besar: menampilkan 20.000 baris dan 100 kolom pertama';

  @override
  String viewerSectionTitle(int number) {
    return 'Bagian $number';
  }

  @override
  String get viewerMenuOutline => 'Kerangka';

  @override
  String get viewerOutlineTitle => 'Kerangka dokumen';

  @override
  String get viewerCloseOutline => 'Tutup kerangka';

  @override
  String get viewerNoSections => 'Tidak ada bagian ditemukan dalam dokumen ini';

  @override
  String get viewerOutlineTooltip => 'Daftar isi';

  @override
  String get viewerActionOpenExternal => 'Buka di aplikasi lain';

  @override
  String get viewerErrorCantOpenTitle => 'Tidak dapat membuka dokumen ini';

  @override
  String get viewerErrorCantOpenMessage =>
      'Dokumen tidak dapat dirender secara offline.';

  @override
  String get viewerOpeningDocument => 'Membuka dokumen...';

  @override
  String get viewerErrorEncryptedTitle => 'Dokumen ini terenkripsi';

  @override
  String get viewerErrorEncryptedMessage =>
      'File yang dilindungi kata sandi tidak dapat dilihat di pembaca offline.';

  @override
  String get viewerErrorTooLargeTitle => 'File ini melebihi batas tampilan';

  @override
  String get viewerErrorTooLargeMessage =>
      'Dokumen besar sebaiknya dibuka menggunakan penampil Office eksternal.';

  @override
  String get viewerErrorUnsupportedFormatTitle => 'Format ini tidak didukung';

  @override
  String get viewerErrorUnsupportedFormatMessage =>
      'Doc View tidak dapat memproses format file ini secara langsung.';

  @override
  String viewerOutlineItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTypographyTitle => 'Tipografi';

  @override
  String txtViewerFontSizeLabel(int size) {
    return '$size pt';
  }

  @override
  String get txtViewerMonospaceLabel => 'Font monospace';

  @override
  String get txtViewerTruncationBanner =>
      'File lebih besar dari 1 MB: menampilkan 1 MB pertama';

  @override
  String txtViewerLinesSubtitle(int count, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count baris • $size',
      one: '1 baris • $size',
    );
    return '$_temp0';
  }

  @override
  String get txtViewerTooltipTypography => 'Pengaturan tipografi';

  @override
  String get txtViewerTooltipDecreaseFont => 'Perkecil ukuran font';

  @override
  String get txtViewerTooltipIncreaseFont => 'Perbesar ukuran font';

  @override
  String get txtViewerTooltipToggleMonospace =>
      'Aktifkan/nonaktifkan font monospace';

  @override
  String get txtViewerMonospaceSubtitle =>
      'Karakter lebar tetap untuk kode dan log';

  @override
  String get txtViewerPreviewLabel => 'Pratinjau';

  @override
  String get txtViewerPreviewText =>
      'Rubah cokelat lincah melompati anjing yang malas.';

  @override
  String get txtViewerErrorTitle => 'Tidak dapat membaca file teks ini';

  @override
  String get txtViewerErrorMessage =>
      'Format atau pengkodean file tidak dapat diproses.';

  @override
  String get txtViewerActionRetry => 'Coba lagi';

  @override
  String imageViewerDimensionsSubtitle(int width, int height, String size) {
    return '$width × $height • $size';
  }

  @override
  String imageViewerZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get imageViewerTooltipFitToScreen => 'Sesuaikan ke layar';

  @override
  String get imageViewerErrorCorrupt => 'Tidak dapat memuat gambar';

  @override
  String get imageViewerLoading => 'Memuat gambar…';

  @override
  String get viewerDispatcherFileMissing => 'File sudah tidak ada';

  @override
  String get viewerSpreadsheetFormulaBarEmpty => '-';

  @override
  String get viewerSpreadsheetAllCells => 'Semua';

  @override
  String viewerSpreadsheetColumnLabel(String col) {
    return 'Kolom $col';
  }

  @override
  String viewerSpreadsheetRowLabel(int row) {
    return 'Baris $row';
  }

  @override
  String viewerSpreadsheetCellSemantics(String col, int row, String value) {
    return 'Kolom $col, baris $row, $value';
  }

  @override
  String get viewerSpreadsheetEmptyCell => 'kosong';

  @override
  String get viewerSpreadsheetEmptySheet => 'Lembar ini kosong';

  @override
  String get viewerSpreadsheetCopiedSingle => 'Sel disalin';

  @override
  String viewerSpreadsheetCopiedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sel disalin',
      one: '1 sel disalin',
    );
    return '$_temp0';
  }

  @override
  String get viewerSpreadsheetCopyLimitReached =>
      'Pilihan dipotong menjadi 5.000 sel';

  @override
  String get viewerSpreadsheetCellContentTitle => 'Isi Sel';

  @override
  String get viewerSpreadsheetCopyAction => 'Salin';

  @override
  String get viewerSpreadsheetCloseAction => 'Tutup';

  @override
  String viewerSpreadsheetZoomPill(int percent) {
    return '$percent%';
  }

  @override
  String get viewerSpreadsheetResetZoomTooltip => 'Atur ulang zoom ke 100%';

  @override
  String get viewerSpreadsheetNoMatches =>
      'Tidak ada hasil cocok di lembar ini';

  @override
  String get viewerSpreadsheetSearchPlaceholder => 'Cari di lembar…';

  @override
  String get viewerSpreadsheetPasswordTitle => 'File dilindungi kata sandi';

  @override
  String get viewerSpreadsheetPasswordMessage =>
      'File yang dilindungi kata sandi tidak dapat dibuka di sini.';

  @override
  String get viewerSpreadsheetErrorTitle =>
      'Tidak dapat membaca spreadsheet ini';

  @override
  String get viewerSpreadsheetCorruptMessage =>
      'File spreadsheet rusak atau tidak dapat didekode.';

  @override
  String get viewerSpreadsheetTimeoutMessage =>
      'Waktu pembukaan spreadsheet habis setelah 20 detik.';

  @override
  String get viewerSpreadsheetTooLargeMessage =>
      'File ini melebihi batas tampilan 25 MB.';

  @override
  String get viewerSpreadsheetOpenBasicViewer => 'Buka di penampil dasar';

  @override
  String get viewerSpreadsheetOpenAnotherApp => 'Buka di aplikasi lain';

  @override
  String get toolsWorkspaceOverline => 'RUANG KERJA';

  @override
  String get toolsTitle => 'Alat';

  @override
  String get toolsSectionConvertCreate => 'KONVERSI & BUAT';

  @override
  String get toolsSectionEditManage => 'EDIT & KELOLA';

  @override
  String get toolsSectionOthers => 'LAINNYA';

  @override
  String get toolsCreatedByYou => 'Dibuat oleh Anda';

  @override
  String get toolsCreatedByYouEmpty => 'PDF yang Anda buat akan muncul di sini';

  @override
  String get toolsCreatedByYouSeeAll => 'Lihat semua';

  @override
  String get toolManagePages => 'Kelola Halaman';

  @override
  String get toolManagePagesSub => 'Susun ulang, putar & hapus';

  @override
  String get toolImportFiles => 'Impor file';

  @override
  String get toolImportFilesSub => 'Tambahkan dari aplikasi lain';

  @override
  String get toolPrintPdf => 'Cetak PDF';

  @override
  String get toolPrintPdfSub => 'Kirim ke printer mana saja';

  @override
  String get toolCreatePdf => 'Buat PDF';

  @override
  String get toolCreatePdfSub => 'Dokumen kosong atau templat';

  @override
  String get toolRecycleBin => 'Tempat sampah';

  @override
  String get toolRecycleBinSub => 'Pulihkan file yang dihapus';

  @override
  String get toolAnnotate => 'Anotasi';

  @override
  String get toolAnnotateSub => 'Sorot, gambar & tandai';

  @override
  String get toolAddText => 'Tambah Teks';

  @override
  String get toolAddTextSub => 'Sisipkan teks & tanggal';

  @override
  String get toolSign => 'Tanda tangani';

  @override
  String get toolSignSub => 'Isi & tanda tangani formulir';

  @override
  String get toolWordToPdf => 'Word ke PDF';

  @override
  String get toolWordToPdfSub => 'Konversi DOCX ke PDF';

  @override
  String get toolPptToPdf => 'PPT ke PDF';

  @override
  String get toolPptToPdfSub => 'Konversi PPTX ke PDF';

  @override
  String get printPdfErrorTooLarge => 'File PDF melebihi batas cetak 50 MB.';

  @override
  String get printPdfErrorUnreadable =>
      'Tidak dapat membaca PDF untuk dicetak.';

  @override
  String get printPdfErrorPassword =>
      'Tidak dapat mencetak PDF yang dilindungi kata sandi secara langsung.';

  @override
  String get printPdfErrorFailed => 'Pencetakan gagal.';

  @override
  String get printPdfSuccess => 'Dokumen dikirim ke printer.';

  @override
  String get toolPickerTitleSelectPdf => 'Pilih PDF';

  @override
  String get toolPickerTitleSelectPdfs => 'Pilih PDF';

  @override
  String get toolPickerBrowseFiles => 'Telusuri file';

  @override
  String get toolPickerTabAll => 'Semua PDF';

  @override
  String get toolPickerTabRecent => 'Terbaru';

  @override
  String get toolPickerTabDownloads => 'Unduhan';

  @override
  String get toolPickerTabICloud => 'iCloud Drive';

  @override
  String get toolPickerActionPrint => 'Cetak';

  @override
  String get toolPickerActionManage => 'Kelola';

  @override
  String get toolPickerActionSelect => 'Pilih';

  @override
  String get toolsImportActionView => 'Lihat';

  @override
  String get createPdfTemplateBlank => 'Kosong';

  @override
  String get createPdfTemplateLine1 => 'Garis 1';

  @override
  String get createPdfTemplateLine2 => 'Garis 2';

  @override
  String get createPdfTemplateNotebook => 'Buku Catatan';

  @override
  String get createPdfTemplateCornell => 'Cornell';

  @override
  String get createPdfTemplateGrid => 'Kisi';

  @override
  String get createPdfTemplateGraph => 'Grafik';

  @override
  String get createPdfSwatchWhite => 'Putih';

  @override
  String get createPdfSwatchCream => 'Krem';

  @override
  String get createPdfSwatchLightYellow => 'Kuning Muda';

  @override
  String get createPdfSwatchLightPeach => 'Persik Muda';

  @override
  String get createPdfSwatchLightPink => 'Merah Muda Terang';

  @override
  String get createPdfSwatchLightLavender => 'Lavender Muda';

  @override
  String get createPdfSwatchLightBlue => 'Biru Muda';

  @override
  String get createPdfSwatchLightMint => 'Mint Muda';

  @override
  String get createPdfSwatchLightGreen => 'Hijau Muda';

  @override
  String get createPdfSwatchLightGray => 'Abu-abu Muda';

  @override
  String get createPdfOrientationPortrait => 'Potret';

  @override
  String get createPdfOrientationLandscape => 'Lanskap';

  @override
  String get createPdfSectionTemplate => 'TEMPLAT';

  @override
  String get createPdfSectionPageSize => 'UKURAN HALAMAN';

  @override
  String get createPdfSectionOrientation => 'ORIENTASI';

  @override
  String get createPdfSectionPageColor => 'WARNA HALAMAN';

  @override
  String get createPdfSectionPageCount => 'JUMLAH HALAMAN';

  @override
  String createPdfPagesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count halaman',
      one: '1 halaman',
    );
    return '$_temp0';
  }

  @override
  String createPdfSummary(String pages, String size, String orientation) {
    return '$pages • $size • $orientation';
  }

  @override
  String get createPdfCreating => 'Membuat PDF...';

  @override
  String createPdfProgress(int done, int total) {
    return 'Menyusun halaman $done dari $total...';
  }

  @override
  String get createPdfErrorTitle => 'Tidak Dapat Membuat PDF';

  @override
  String get createPdfErrorPageCount =>
      'Jumlah halaman harus antara 1 dan 100.';

  @override
  String get createPdfErrorInvalidName => 'Masukkan nama file yang valid.';

  @override
  String get createPdfErrorGeneration =>
      'Gagal membuat dokumen PDF. Silakan coba lagi.';

  @override
  String get trashErrorTooLarge =>
      'File terlalu besar untuk Tempat sampah (batas 200 MB)';

  @override
  String get trashErrorNotEnoughSpace =>
      'Ruang penyimpanan di Tempat sampah tidak mencukupi';

  @override
  String trashErrorGeneric(String details) {
    return 'Operasi Tempat sampah gagal: $details';
  }

  @override
  String get trashDialogMoveTitle => 'Pindahkan ke Tempat sampah?';

  @override
  String trashDialogMoveBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Pindahkan $count file ke Tempat sampah? Anda dapat memulihkannya dari Alat > Tempat sampah selama 30 hari.',
      one:
          'Pindahkan 1 file ke Tempat sampah? Anda dapat memulihkannya dari Alat > Tempat sampah selama 30 hari.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionMove => 'Pindahkan ke Tempat sampah';

  @override
  String trashMovedSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file dipindahkan ke Tempat sampah',
      one: '1 file dipindahkan ke Tempat sampah',
    );
    return '$_temp0';
  }

  @override
  String get trashActionUndo => 'Urungkan';

  @override
  String trashRestoredSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file dipulihkan',
      one: '1 file dipulihkan',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogDeleteForeverTitle => 'Hapus selamanya?';

  @override
  String trashDialogDeleteForeverBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Hapus $count file selamanya? Tindakan ini tidak dapat dibatalkan.',
      one: 'Hapus 1 file selamanya? Tindakan ini tidak dapat dibatalkan.',
    );
    return '$_temp0';
  }

  @override
  String get trashActionDeleteForever => 'Hapus selamanya';

  @override
  String trashDeletedForeverSuccess(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file dihapus selamanya',
      one: '1 file dihapus selamanya',
    );
    return '$_temp0';
  }

  @override
  String get trashDialogEmptyTitle => 'Kosongkan Tempat sampah?';

  @override
  String trashDialogEmptyBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count file',
      one: '1 file',
    );
    return 'Hapus semua $_temp0 selamanya? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get trashActionEmptyBin => 'Kosongkan sampah';

  @override
  String get trashEmptyTitle => 'Tempat sampah kosong';

  @override
  String get trashEmptySubtitle =>
      'File yang dipindahkan ke Tempat sampah akan disimpan di sini selama 30 hari sebelum dihapus secara permanen.';

  @override
  String trashDaysLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hari tersisa',
      one: '1 hari tersisa',
    );
    return '$_temp0';
  }

  @override
  String trashSubtitle(String date, String size) {
    return 'Dihapus $date · $size';
  }

  @override
  String get trashDialogTooLargeTitle => 'Terlalu besar untuk Tempat sampah';

  @override
  String trashDialogTooLargeBody(String fileName) {
    return '\"$fileName\" berukuran lebih dari 200 MB dan tidak dapat dipindahkan ke Tempat sampah. Apakah Anda ingin menghapusnya secara permanen?';
  }

  @override
  String get trashActionDeletePermanently => 'Hapus permanen';

  @override
  String get trashInfoBanner =>
      'Item di Tempat sampah akan dihapus secara permanen setelah 30 hari.';

  @override
  String get trashSheetRestore => 'Pulihkan';

  @override
  String get trashSheetDeleteForever => 'Hapus selamanya';

  @override
  String get trashSheetDetails => 'Detail';

  @override
  String get trashDetailsOriginalLocation => 'Lokasi asal';

  @override
  String get trashDetailsDateDeleted => 'Tanggal dihapus';

  @override
  String get trashDetailsExpiresIn => 'Kedaluwarsa dalam';

  @override
  String trashRestoredToFallbackSuccess(String location) {
    return 'Dipulihkan ke $location (folder asal tidak ditemukan)';
  }

  @override
  String get trashDialogCopyFailedTitle =>
      'Tidak dapat memindahkan ke Tempat sampah';

  @override
  String trashDialogCopyFailedBody(String fileName) {
    return 'Tidak dapat memindahkan \"$fileName\" ke Tempat sampah. Apakah Anda ingin menghapusnya secara permanen? Tindakan ini tidak dapat dibatalkan.';
  }

  @override
  String get trashDialogEmptyProgress => 'Mengosongkan Tempat sampah...';

  @override
  String get trashDialogMoveProgress => 'Memindahkan file ke Tempat sampah...';

  @override
  String get trashDialogNotEnoughSpaceTitle => 'Ruang penyimpanan tidak cukup';

  @override
  String get trashDialogNotEnoughSpaceBody =>
      'Ruang penyimpanan tidak mencukupi untuk memindahkan ke Tempat sampah. Kosongkan tempat sampah untuk membebaskan ruang.';

  @override
  String get trashActionFreeUpSpace => 'Bebaskan ruang';

  @override
  String get trashDialogDeleteForeverProgress => 'Menghapus file selamanya...';

  @override
  String get galleryDebugAgeTrash => 'Tuakan semua item sampah sebesar 29 hari';

  @override
  String get galleryDebugSlowCopy => 'Salin sampah lambat (pengujian)';

  @override
  String get galleryDebugSlowCopySubtitle =>
      'Membatasi loop penyalinan ke ~20 MB/dtk untuk uji penghentian paksa';

  @override
  String get galleryDebugSlowSave => 'Simpan editor lambat (pengujian)';

  @override
  String get galleryDebugSlowSaveSubtitle =>
      'Membatasi loop penyimpanan ke ~8 dtk untuk uji penghentian paksa';

  @override
  String get galleryDebugSaveAnnotate => 'Simpan sampel 100 hal. (uji Anotasi)';

  @override
  String get galleryDebugSaveSign =>
      'Simpan sampel 100 hal. (uji Tanda tangan)';

  @override
  String get galleryDebugSaveText => 'Simpan sampel 100 hal. (uji Tambah teks)';

  @override
  String get galleryDebugMove190Mb => 'Pindahkan file uji 190MB ke sampah';

  @override
  String get galleryDebugRestoreLastTrash => 'Pulihkan item sampah terakhir';

  @override
  String get galleryDebugEmptyTrash => 'Kosongkan Tempat sampah';

  @override
  String galleryDebugAgeTrashSuccess(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count item',
      one: '1 item',
    );
    return '$_temp0 dituakan 29 hari';
  }

  @override
  String get annotateErrorPasswordProtected => 'PDF ini dilindungi kata sandi.';

  @override
  String get annotateErrorCorrupt => 'PDF ini rusak atau tidak dapat dibaca.';

  @override
  String get annotateSignedReplaceBlocked =>
      'Menimpa PDF asli yang telah ditandatangani tidak diizinkan. Simpan sebagai file baru.';

  @override
  String annotateErrorSaveFailed(String details) {
    return 'Gagal menyimpan anotasi: $details';
  }

  @override
  String get annotateErrorScannedPdf =>
      'Dokumen ini tampaknya merupakan hasil pindaian atau tidak memiliki teks yang dapat dipilih.';

  @override
  String get annotateSignedBanner =>
      'PDF bertanda tangan digital: Menyimpan akan membuat salinan baru untuk menjaga tanda tangan.';

  @override
  String get annotateActionSaveNew => 'Simpan sebagai file baru';

  @override
  String get annotateActionReplace => 'Ganti file asli';

  @override
  String get annotateDiscardDialogTitle => 'Buang anotasi yang belum disimpan?';

  @override
  String get annotateDiscardDialogBody =>
      'Anda memiliki coretan atau anotasi yang belum disimpan. Jika keluar sekarang, perubahan Anda akan hilang.';

  @override
  String get annotateDiscardDialogActionDiscard => 'Buang';

  @override
  String get annotateDiscardDialogActionKeep => 'Lanjutkan mengedit';

  @override
  String get annotateSaveSuccess => 'Anotasi berhasil disimpan';

  @override
  String get annotateToolbarHighlight => 'Sorot';

  @override
  String get annotateToolbarUnderline => 'Garis bawah';

  @override
  String get annotateToolbarStrikethrough => 'Coret';

  @override
  String get annotateToolbarCopy => 'Salin';

  @override
  String get annotateColorYellow => 'Kuning';

  @override
  String get annotateColorGreen => 'Hijau';

  @override
  String get annotateColorCyan => 'Sian';

  @override
  String get annotateColorPink => 'Merah Muda';

  @override
  String get annotateColorOrange => 'Oranye';

  @override
  String get annotateSaveTitle => 'Simpan anotasi';

  @override
  String get annotateSaveProgress => 'Menyimpan anotasi...';

  @override
  String get annotateNoChanges => 'Tidak ada anotasi untuk disimpan';

  @override
  String get annotateTooltipUndo => 'Urungkan';

  @override
  String get annotateTooltipRedo => 'Ulangi';

  @override
  String get annotateTooltipSave => 'Simpan';

  @override
  String get annotateCopiedToClipboard => 'Disalin ke papan klip';

  @override
  String get annotateToolbarPen => 'Pena';

  @override
  String get annotatePenTipBanner =>
      'Gambar dengan satu jari. Geser dan perbesar dengan dua jari.';

  @override
  String get annotatePenSheetTitle => 'Pengaturan pena';

  @override
  String get annotatePenStrokeWidth => 'Ketebalan garis';

  @override
  String get annotatePenEraserMode => 'Penghapus';

  @override
  String get annotateColorBlack => 'Hitam';

  @override
  String get annotateColorRed => 'Merah';

  @override
  String get annotateColorPurple => 'Ungu';

  @override
  String get annotateColorBlue => 'Biru';

  @override
  String get toolSignPdf => 'Tanda Tangani PDF';

  @override
  String get toolSignPdfSubtitle =>
      'Tambahkan tanda tangan dan tanggal ke dokumen';

  @override
  String get signToolbarSign => 'Tanda tangan';

  @override
  String get signToolbarDate => 'Tanggal';

  @override
  String get signToolbarClearAll => 'Hapus semua';

  @override
  String get signPadTitle => 'Gambar tanda tangan Anda';

  @override
  String get signPadClear => 'Hapus';

  @override
  String get signPadSave => 'Simpan tanda tangan';

  @override
  String get signSheetTitle => 'Tanda tangan tersimpan';

  @override
  String get signSheetCreateNew => 'Buat tanda tangan baru';

  @override
  String get signMaxSignaturesReached =>
      'Batas maksimum 5 tanda tangan tersimpan telah tercapai';

  @override
  String get signMaxPlacedReached =>
      'Batas maksimum 20 tanda tangan per dokumen telah tercapai';

  @override
  String get signDeleteSignatureTitle => 'Hapus tanda tangan?';

  @override
  String get signDeleteSignatureBody =>
      'Tanda tangan ini akan dihapus dari daftar tanda tangan tersimpan Anda.';

  @override
  String get signConfirmClearAllTitle => 'Hapus semua tanda tangan?';

  @override
  String get signConfirmClearAllBody =>
      'Semua tanda tangan dan tanggal yang ditempatkan di dokumen ini akan dihapus.';

  @override
  String get signSaveSuccess => 'Dokumen berhasil ditandatangani';

  @override
  String get signNoSignaturesToSave =>
      'Tidak ada tanda tangan yang ditempatkan di dokumen';

  @override
  String get signPlacedSignatureDelete => 'Hapus';

  @override
  String get signPlacedSignatureApply => 'Terapkan';

  @override
  String get signTooltipUndo => 'Urungkan';

  @override
  String get signTooltipRedo => 'Ulangi';

  @override
  String get signTooltipSave => 'Simpan';

  @override
  String annotatePenStrokeWidthValue(String width) {
    return '$width pt';
  }

  @override
  String get annotateErrorTooManyStrokes =>
      'Dokumen telah mencapai batas maksimum 5.000 goresan atau 300.000 titik.';

  @override
  String annotateChangesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count perubahan',
      one: '1 perubahan',
    );
    return '$_temp0';
  }

  @override
  String get annotatePenNotice =>
      'Goresan pena akan menyatu dengan halaman saat disimpan dan tidak dapat diedit lagi nanti.';

  @override
  String get annotatePenNoticeDismiss => 'Mengerti';

  @override
  String get signPadBaselineHint => 'Tanda tangani di sini';

  @override
  String get signPadUndo => 'Urungkan';

  @override
  String get signPadUseOnce => 'Gunakan sekali';

  @override
  String get signPadSaveAndUse => 'Simpan dan gunakan';

  @override
  String get tool_add_text => 'Tambah Teks';

  @override
  String get tool_add_text_desc =>
      'Sisipkan kotak teks dan catatan pada halaman';

  @override
  String get addTextNoticePermanent =>
      'Teks yang ditambahkan akan menyatu dengan halaman dan tidak dapat diedit setelah disimpan.';

  @override
  String get addTextNoticeRaster =>
      'Teks dalam bahasa ini ditambahkan sebagai gambar dan tidak dapat dipilih.';

  @override
  String get addTextNoticeGotIt => 'Mengerti';

  @override
  String get addTextActionAdd => 'Tambah teks';

  @override
  String get addTextActionStyle => 'Gaya';

  @override
  String get addTextActionDelete => 'Hapus';

  @override
  String get addTextStyleSheetTitle => 'Gaya teks';

  @override
  String get addTextFontSize => 'Ukuran font';

  @override
  String get addTextColor => 'Warna';

  @override
  String get addTextStyle => 'Gaya';

  @override
  String get addTextAlign => 'Perataan';

  @override
  String get addTextBold => 'Tebal';

  @override
  String get addTextItalic => 'Miring';

  @override
  String get addTextAlignStart => 'Awal';

  @override
  String get addTextAlignCenter => 'Tengah';

  @override
  String get addTextAlignEnd => 'Akhir';

  @override
  String get addTextErrorTooManyBoxes =>
      'Batas maksimum 30 kotak teks tercapai';

  @override
  String get addTextErrorBoxTooLong =>
      'Kotak teks tidak boleh melebihi 2.000 karakter';

  @override
  String get addTextPlaceholder => 'Ketik teks di sini';

  @override
  String get addTextSamplePreview => 'Contoh Pratinjau';

  @override
  String addTextFontSizePt(int size) {
    return '$size pt';
  }

  @override
  String get premiumTitle => 'Doc View Premium';

  @override
  String get premiumSubtitle =>
      'Buka alat Anotasi & Tanda Tangan dan nikmati pengalaman bebas iklan sepenuhnya.';

  @override
  String get premiumFeatureAllTools => 'Alat Anotasi & Tanda Tangani PDF';

  @override
  String get premiumFeatureAllToolsSub =>
      'Buat coretan, sorot dokumen, dan tanda tangani PDF dengan mudah';

  @override
  String get premiumFeatureAdFree => 'Pengalaman 100% Bebas Iklan';

  @override
  String get premiumFeatureAdFreeSub =>
      'Tanpa spanduk, interupsi, atau gangguan di mana pun';

  @override
  String get premiumFeatureUnlimitedConversions => 'Konversi lokal tanpa batas';

  @override
  String get premiumFeatureUnlimitedConversionsSub =>
      'Konversi dokumen di perangkat tanpa batas file';

  @override
  String get premiumFeaturePrivacyFirst => '100% Pribadi & Di Perangkat';

  @override
  String get premiumFeaturePrivacyFirstSub =>
      'File diproses secara lokal dan tidak pernah diunggah ke server mana pun';

  @override
  String get premiumPlanYearly => 'Langganan Tahunan';

  @override
  String premiumPlanYearlyTrial(int days, String price) {
    return 'Gratis $days hari, lalu $price/tahun';
  }

  @override
  String get premiumPlanMonthly => 'Langganan Bulanan';

  @override
  String premiumPlanMonthlySub(String price) {
    return '$price/bulan';
  }

  @override
  String premiumPlanYearlySub(String price) {
    return '$price/tahun';
  }

  @override
  String premiumPlanMonthlyTrial(int days, String price) {
    return 'Gratis $days hari, lalu $price/bulan';
  }

  @override
  String premiumSavePercent(int percent) {
    return 'Hemat $percent%';
  }

  @override
  String get premiumSaveUnknown => 'Hemat -%';

  @override
  String premiumActionStartTrial(int days) {
    return 'Mulai Uji Coba Gratis $days Hari';
  }

  @override
  String get premiumSubscriptionsAvailableSoon =>
      'Langganan akan segera tersedia.';

  @override
  String get pagesEditPagesAction => 'Edit halaman';

  @override
  String get premiumCancelAnytime => 'Batalkan kapan saja';

  @override
  String get premiumPendingStatus =>
      'Pembelian Anda sedang diproses oleh Google Play. Hak akses akan aktif setelah dikonfirmasi.';

  @override
  String get premiumRenewalDisclosurePricingUnavailable =>
      'Diperpanjang otomatis. Harga akan dikonfirmasi oleh Google Play saat pembayaran. Batalkan kapan saja di Langganan Google Play.';

  @override
  String get premiumActionSubscribe => 'Berlangganan';

  @override
  String get premiumActionRestore => 'Pulihkan Pembelian';

  @override
  String get premiumBillingDisclaimer =>
      'Diperpanjang otomatis. Batalkan kapan saja di Langganan Google Play.';

  @override
  String get premiumTerms => 'Ketentuan Layanan';

  @override
  String get premiumPrivacy => 'Kebijakan Privasi';

  @override
  String get premiumActiveStatus => 'Anda adalah pelanggan Premium';

  @override
  String get premiumGraceStatus => 'Masa tenggang offline aktif';

  @override
  String get premiumExpiredStatus => 'Langganan berakhir';

  @override
  String get premiumRestoreSuccess => 'Pembelian berhasil dipulihkan.';

  @override
  String get premiumRestoreNone => 'Tidak ditemukan langganan aktif.';

  @override
  String get premiumErrorGeneral =>
      'Tidak dapat menyelesaikan pembelian. Silakan coba lagi.';

  @override
  String get premiumPagesGateTitle => 'Doc View Premium';

  @override
  String get premiumPagesGateBody =>
      'Menyusun ulang, memutar, dan menghapus halaman memerlukan langganan Premium.';

  @override
  String get premiumPagesGateUpgrade => 'Tingkatkan ke Premium';

  @override
  String get premiumTooltip => 'Doc View Premium';

  @override
  String get premiumManageInPlay => 'Kelola';

  @override
  String get faqQuestion8 => 'Apa saja yang termasuk dalam Doc View Premium?';

  @override
  String get faqAnswer8 =>
      'Doc View Premium membuka semua alat pengeditan dokumen lanjutan, termasuk penyusunan ulang, pemutaran, penghapusan halaman PDF, konversi PDF ke Word, anotasi, tanda tangan, dan penyisipan teks kustom, sekaligus menghilangkan semua iklan di seluruh aplikasi. Semua pemrosesan dokumen tetap 100% di perangkat.';

  @override
  String get faqQuestion9 =>
      'Bisakah saya menggunakan Doc View Premium tanpa koneksi internet?';

  @override
  String get faqAnswer9 =>
      'Ya. Setelah diaktifkan, Doc View menyimpan status langganan Anda secara aman di perangkat dengan masa tenggang offline hingga 7 hari berturut-turut. Anda dapat terus menggunakan semua alat pengeditan secara offline selama periode ini.';

  @override
  String get galleryDebugIapSectionTitle => '15. Simulator IAP & Premium (G7)';

  @override
  String get galleryDebugIapStateFree => 'Atur ke Gratis';

  @override
  String get galleryDebugIapStateYearly => 'Atur ke Premium Tahunan';

  @override
  String get galleryDebugIapStateMonthly => 'Atur ke Premium Bulanan';

  @override
  String get galleryDebugIapStateGrace =>
      'Atur ke Masa Tenggang Offline (Aktif)';

  @override
  String get galleryDebugIapStateGraceExpired =>
      'Atur ke Masa Tenggang Offline (Kedaluwarsa)';

  @override
  String get galleryDebugOpenPremium => 'Buka Layar /premium';

  @override
  String get galleryDebugIapProductSeenTrue => 'Atur Produk Terlihat: Benar';

  @override
  String get galleryDebugIapProductSeenFalse => 'Atur Produk Terlihat: Salah';

  @override
  String get addWidgetSheetTitle => 'Tambahkan ke layar utama';

  @override
  String get addWidgetSheetSubtitle =>
      'Pilih widget untuk ditambahkan ke layar utama Anda';

  @override
  String get widgetRecentFilesTitle => 'File terbaru';

  @override
  String get widgetRecentFilesBadge => '4 × 2';

  @override
  String get widgetRecentFilesDesc =>
      'Lihat dan buka file yang baru saja digunakan langsung dari layar utama Anda';

  @override
  String get widgetQuickToolsTitle => 'Alat cepat';

  @override
  String get widgetQuickToolsBadge => '4 × 1';

  @override
  String get widgetQuickToolsDesc =>
      'Langsung buka Pindai, Gambar ke PDF, Cari, atau Impor';

  @override
  String get addWidgetButton => 'Tambahkan widget';

  @override
  String get addWidgetManualTitle => 'Tambahkan widget secara manual';

  @override
  String get addWidgetManualMessage =>
      'Sentuh dan tahan area kosong di layar utama Anda, ketuk Widget, temukan Doc View, lalu seret ke layar Anda.';

  @override
  String get settingsQuickAccessNotificationTitle => 'Notifikasi akses cepat';

  @override
  String get settingsQuickAccessNotificationSubtitle =>
      'Tampilkan alat cepat di bilah notifikasi';

  @override
  String get notificationPermissionDialogTitle => 'Izinkan notifikasi';

  @override
  String get notificationPermissionDialogDesc =>
      'Doc View memerlukan izin notifikasi untuk menampilkan bilah akses cepat di panel notifikasi Anda.';

  @override
  String get notificationTitle => 'Alat Cepat Doc View';

  @override
  String get notificationBody => 'Pindai, konversi, atau cari dokumen';

  @override
  String get notificationActionScan => 'Pindai';

  @override
  String get notificationActionImageToPdf => 'Gambar ke PDF';

  @override
  String get notificationActionSearch => 'Cari';

  @override
  String get settingsAdChoicesTitle => 'Pilihan iklan';

  @override
  String get settingsAdChoicesSubtitle => 'Kelola privasi dan pilihan iklan';

  @override
  String get faqQuestion10 => 'Mengapa Doc View menampilkan iklan?';

  @override
  String get faqAnswer10 =>
      'Iklan membuat Doc View tetap gratis. Premium menghilangkannya. Iklan disajikan oleh Google AdMob dan tidak pernah melihat dokumen Anda.';
}
