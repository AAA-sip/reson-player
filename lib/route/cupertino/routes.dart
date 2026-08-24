enum CupertinoRoutes {
  home('/home'),
  settings('/settings');

  final String path;

  const CupertinoRoutes(this.path);

  String get name => toString().split('.').last;
}
