import 'package:flutter/material.dart';
import 'package:psit_lite/services/like_service.dart';

class LikedWidget extends StatefulWidget {
  const LikedWidget({super.key});

  @override
  State<StatefulWidget> createState() => _LikedWidgetState();
}

class _LikedWidgetState extends State<LikedWidget> {
  bool isFetchingStats = true;
  bool isFetchingUserStats = true;
  bool hasLiked = false;
  bool hasVisited = false;
  int likes = 0;
  int visits = 0;
  bool firstVisit = true;

  @override
  void initState() {
    super.initState();
    LikeService.instantiate();
    
    _fetchUserStats();
    _fetchStats();
  }

  Future<void> _fetchUserStats() async {
    final userStats = await LikeService.fetchUserStats();
    hasVisited = userStats['visited'] ?? false;
    hasLiked = userStats['liked'] ?? false;
    setState(() {
      isFetchingUserStats = false;
    });
  }

  Future<void> _fetchStats() async {
    final stats = await LikeService.fetchStats();
    likes = stats['likes'] ?? 0;
    visits = stats['visits'] ?? 0;
    setState(() {
      isFetchingStats = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      alignment: Alignment.centerRight,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              isFetchingStats
                  ? const SizedBox()
                  : Text(
                      '$likes liked out of $visits',
                      style: theme.textTheme.bodyMedium,
                    ),
              TextButton.icon(
                onPressed: isFetchingUserStats
                    ? null
                    : () {
                        if (hasLiked) {
                          setState(() {
                            --likes;
                            hasLiked = false;
                          });
                          LikeService.dislike();
                        } else {
                          setState(() {
                            if (!hasVisited) {
                              hasVisited = true;
                              ++visits;
                              showCenterToast(
                                context,
                                Material(
                                  child: Chip(
                                    label: Text(
                                      'Thanks for liking!',
                                      style: TextStyle(
                                        color: Colors.red.shade800,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    avatar: Icon(
                                      Icons.favorite,
                                      color: Colors.red.shade400,
                                      size: 20,
                                    ),
                                    backgroundColor: Colors.red.shade50,
                                    elevation: 4,
                                    shadowColor: Colors.red.shade100,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(
                                        color: Colors.red.shade100,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            ++likes;
                            hasLiked = true;
                          });
                          LikeService.like();
                        }
                      },
                icon: isFetchingUserStats || !hasLiked
                    ? const Icon(Icons.favorite_border)
                    : const Icon(Icons.favorite, color: Colors.red),
                label: Text(
                  hasLiked ? 'Liked' : 'Like',
                  style: theme.textTheme.labelLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showCenterToast(
  BuildContext context,
  Widget child, {
  Duration duration = const Duration(seconds: 2),
}) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => CenterToastWidget(duration: duration, child: child),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration + const Duration(milliseconds: 500), () {
    overlayEntry.remove();
  });
}

class CenterToastWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const CenterToastWidget({
    super.key,
    required this.child,
    required this.duration,
  });

  @override
  State<CenterToastWidget> createState() => _CenterToastWidgetState();
}

class _CenterToastWidgetState extends State<CenterToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    // Auto fade out after duration
    Future.delayed(widget.duration, () {
      _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: FadeTransition(opacity: _fade, child: widget.child),
        ),
      ),
    );
  }
}
