import 'package:flutter/material.dart';

/// Central icon registry mapping every Material Symbols Outlined / icon name
/// used across the Doc View mockups to Flutter's built-in icon font.
abstract final class AppIcons {
  // --- Navigation & Chrome ---
  static const IconData allFilesActive = Icons.folder;
  static const IconData allFilesInactive = Icons.folder_outlined;
  static const IconData toolsActive = Icons.construction;
  static const IconData toolsInactive = Icons.construction_outlined;
  static const IconData settingsActive = Icons.settings;
  static const IconData settingsInactive = Icons.settings_outlined;

  // --- Actions & Controls ---
  static const IconData search = Icons.search_outlined;
  static const IconData back = Icons.arrow_back;
  static const IconData close = Icons.close;
  static const IconData moreVert = Icons.more_vert;
  static const IconData moreHoriz = Icons.more_horiz;
  static const IconData check = Icons.check;
  static const IconData checkCircle = Icons.check_circle;
  static const IconData checkCircleOutline = Icons.radio_button_unchecked;
  static const IconData radioChecked = Icons.radio_button_checked;
  static const IconData radioUnchecked = Icons.radio_button_unchecked;
  static const IconData selectAll = Icons.select_all;
  static const IconData filter = Icons.tune_outlined;
  static const IconData sort = Icons.sort_outlined;
  static const IconData refresh = Icons.refresh;
  static const IconData share = Icons.share_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData edit = Icons.edit_outlined;
  static const IconData rename = Icons.drive_file_rename_outline;
  static const IconData info = Icons.info_outline;
  static const IconData help = Icons.help_outline;
  static const IconData star = Icons.star;
  static const IconData bookmark = Icons.star;
  static const IconData bookmarkOutline = Icons.star_border;
  static const IconData chevronRight = Icons.chevron_right;
  static const IconData chevronDown = Icons.keyboard_arrow_down;
  static const IconData chevronUp = Icons.keyboard_arrow_up;
  static const IconData add = Icons.add;
  static const IconData dragHandle = Icons.drag_handle;
  static const IconData rotate = Icons.rotate_right;
  static const IconData eye = Icons.visibility_outlined;
  static const IconData eyeOff = Icons.visibility_off_outlined;
  static const IconData lock = Icons.lock_outline;
  static const IconData history = Icons.history;
  static const IconData clock = Icons.schedule;
  static const IconData print = Icons.print_outlined;
  static const IconData copy = Icons.content_copy_outlined;
  static const IconData openWith = Icons.open_in_new_outlined;
  static const IconData zoomIn = Icons.zoom_in;
  static const IconData zoomOut = Icons.zoom_out;

  // --- Folders & Directories ---
  static const IconData folder = Icons.folder_outlined;
  static const IconData folderFilled = Icons.folder;
  static const IconData folderShared = Icons.folder_shared_outlined;
  static const IconData folderOpen = Icons.folder_open_outlined;

  // --- Document Types & Tools ---
  static const IconData pdf = Icons.picture_as_pdf_outlined;
  static const IconData word = Icons.description_outlined;
  static const IconData excel = Icons.table_chart_outlined;
  static const IconData ppt = Icons.slideshow_outlined;
  static const IconData txt = Icons.article_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData scanner = Icons.document_scanner_outlined;
  static const IconData merge = Icons.call_merge_outlined;
  static const IconData split = Icons.call_split_outlined;

  // --- Status & Warnings ---
  static const IconData error = Icons.error_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData success = Icons.check_circle_outline;
  static const IconData shield = Icons.shield_outlined;
  static const IconData security = Icons.verified_user_outlined;
  static const IconData storage = Icons.storage_outlined;
  static const IconData adBadge = Icons.ad_units_outlined;
}
