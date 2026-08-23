import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:go_router/go_router.dart';

import '../../route/cupertino_router.dart';

class CupertinoHomeScreen extends StatelessWidget {
  const CupertinoHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Reson')),
      child: Center(
        child: CupertinoButton.filled(
          onPressed: () => context.push(CupertinoRoutes.settings.path),
          child: const Text('Settings'),
        ),
      ),
    );
  }
}
