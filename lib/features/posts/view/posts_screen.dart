import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/posts_viewmodel.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final _controller = ScrollController();

  @override

  void initState() {
    super.initState();

    // Safe: schedule after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<PostsViewModel>();
      vm.refresh();
    });

    _controller.addListener(() {
      final vm = context.read<PostsViewModel>();
      if (_controller.position.pixels >= _controller.position.maxScrollExtent - 200) {
        vm.fetchMore();
      }
    });
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PostsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => vm.refresh(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            if (vm.isLoading && vm.posts.isEmpty)
              const SliverToBoxAdapter(child: _LoadingSkeleton()),
            if (vm.error != null && vm.posts.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _ErrorState(
                  message: vm.error!,
                  onRetry: vm.refresh,
                ),
              ),
            if (!vm.isLoading && vm.error == null && vm.posts.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyState(),
              ),
            SliverList.builder(
              itemCount: vm.posts.length,
              itemBuilder: (context, i) {
                final p = vm.posts[i];
                return Card(
                  child: ListTile(
                    title: Text(p.title),
                    subtitle: Text(
                      p.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    if (vm.isLoading && vm.posts.isNotEmpty) const CircularProgressIndicator(),
                    if (!vm.isLoading && vm.error != null)
                      FilledButton.tonalIcon(
                        onPressed: vm.fetchMore,
                        icon: const Icon(Icons.replay_outlined),
                        label: const Text('Retry'),
                      ),
                    if (!vm.isLoading && vm.error == null && !vm.endReached)
                      FilledButton.icon(
                        onPressed: vm.fetchMore,
                        icon: const Icon(Icons.expand_more),
                        label: const Text('Load more'),
                      ),
                    if (vm.endReached) const Text('No more posts'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 72, color: cs.outline),
            const SizedBox(height: 12),
            Text('No posts found', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text('Pull to refresh or try again later.', style: TextStyle(color: cs.outline)),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 72, color: cs.error),
            const SizedBox(height: 12),
            Text('Something went wrong', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 6),
            Text(message, style: TextStyle(color: cs.outline), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.replay), label: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _LoadingSkeleton extends StatefulWidget {
  const _LoadingSkeleton();

  @override
  State<_LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<_LoadingSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: List.generate(6, (i) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.45, end: 1).animate(_c),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(height: 16, width: 180, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8))),
                  const SizedBox(height: 8),
                  Container(height: 12, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8))),
                  const SizedBox(height: 6),
                  Container(height: 12, width: 220, decoration: BoxDecoration(color: base, borderRadius: BorderRadius.circular(8))),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
