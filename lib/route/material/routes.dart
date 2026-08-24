enum MaterialRoutes {
  home('/home'),
  search('/search'),
  settings('/settings'),
  theme('/theme'),
  player('/player');

  final String path;

  const MaterialRoutes(this.path);

  String get name => toString().split('.').last;
}
