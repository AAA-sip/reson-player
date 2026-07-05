import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'circle_widget.dart';
import '../home_state.dart';

class HomeArtistsSection extends ConsumerWidget {
  const HomeArtistsSection({super.key});

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
            'Artists',
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: artistsAsync.when(
            data: (artists) {
              if (artists.isEmpty) {
                return const Center(child: Text('No artists found.'));
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
            error: (Object err, StackTrace stack) => Center(child: Text('Error: $err')),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
        ),
      ],
    );
  }
}
