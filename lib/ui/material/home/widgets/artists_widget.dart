import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/strings.g.dart';
import '../state/home_state.dart';
import 'artists/circle_widget.dart';

class ArtistsWidget extends ConsumerWidget {
  const ArtistsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artistsAsync = ref.watch(artistsProvider);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            Strings.home.sections.artists,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: artistsAsync.when(
            data: (artists) {
              if (artists.isEmpty) {
                return Center(child: Text(Strings.home.empty.artists));
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: artists.length,
                itemBuilder: (BuildContext context, int index) {
                  final artist = artists[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: CircleWidget(title: artist.name, imageUrl: artist.imageUrl ?? ''),
                  );
                },
              );
            },
            error: (Object err, StackTrace stack) => Center(child: Text('${Strings.common.error}: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
