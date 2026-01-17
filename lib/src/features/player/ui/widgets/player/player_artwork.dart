import 'package:flutter/material.dart';

import '../../../../discover/domain/entity/song_entity.dart';

class PlayerArtwork extends StatelessWidget {
  final SongEntity song;

  const PlayerArtwork({super.key, required this.song});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Stack(
      children: [
        // Album Art
        Positioned.fill(
          child: Image.network(
            'https://images.unsplash.com/photo-1485470733090-0aae1788d5af?q=80&w=2117&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: colorScheme.surfaceContainer,
                child: Icon(Icons.music_note, size: 100, color: colorScheme.onSurfaceVariant),
              );
            },
          ),
        ),

        // Primary Overlay
        Positioned.fill(
          child: Container(decoration: BoxDecoration(color: colorScheme.surfaceContainer.withValues(alpha: 0.01))),
        ),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.15, 0.5, 0.7, 0.85, 1.0],
                colors: [
                  scaffoldBg.withValues(alpha: 0.4),
                  scaffoldBg.withValues(alpha: 0.0),
                  Colors.transparent,
                  scaffoldBg.withValues(alpha: 0.3),
                  scaffoldBg.withValues(alpha: 0.7),
                  scaffoldBg,
                ],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface.withValues(alpha: 0.25),
              foregroundColor: colorScheme.onSurface,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        // Share Button
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          right: 20,
          child: IconButton.filledTonal(
            icon: const Icon(Icons.share),
            style: IconButton.styleFrom(
              backgroundColor: colorScheme.surface.withValues(alpha: 0.25),
              foregroundColor: colorScheme.onSurface,
            ),
            onPressed: () {},
          ),
        ),
        // Song Info
        Positioned(
          bottom: 0,
          left: 20,
          right: 20,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _AutoScrollText(
                      text: song.title,
                      style: theme.textTheme.displayMedium?.copyWith(
                        fontSize: 42,
                        letterSpacing: -1.5,
                        color: colorScheme.onSurface,
                        fontVariations: [
                          const FontVariation('wght', 700),
                          const FontVariation('wdth', 150),
                          const FontVariation('GRAD', 1),
                        ],
                      ),
                    ),
                    Text(
                      song.artist,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AutoScrollText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  const _AutoScrollText({required this.text, this.style});

  @override
  State<_AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<_AutoScrollText> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startScrolling() async {
    while (mounted) {
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent > 0) {
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) break;
        await _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 4),
          curve: Curves.linear,
        );
        if (!mounted) break;
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) break;
        await _scrollController.animateTo(
          0.0,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      } else {
        await Future.delayed(const Duration(seconds: 1));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      child: Text(
        widget.text,
        style: widget.style,
        maxLines: 1,
      ),
    );
  }
}
