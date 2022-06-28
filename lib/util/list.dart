extension ListUtils on List {
  ///Returns items that are not null, for UI Widgets/PopupMenuItems etc.
  notNulls() {
    return where((e) => e != null).toList();
  }
}