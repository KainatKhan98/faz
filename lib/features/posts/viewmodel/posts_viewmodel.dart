import 'package:flutter/material.dart';

import '../../../data/model/posts.dart';
import '../../../data/services/posts_services.dart';


class PostsViewModel extends ChangeNotifier {
  final _service = PostsService();

  final List<Post> _posts = [];
  List<Post> get posts => List.unmodifiable(_posts);

  bool _loading = false;
  String? _error;
  bool _endReached = false;
  int _start = 0;
  final int _limit = 10;

  bool get isLoading => _loading;
  String? get error => _error;
  bool get endReached => _endReached;

  Future<void> refresh() async {
    _posts.clear();
    _start = 0;
    _endReached = false;
    _error = null;
    notifyListeners();
    await fetchMore();
  }

  Future<void> fetchMore() async {
    if (_loading || _endReached) return;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final page = await _service.fetch(start: _start, limit: _limit);
      if (page.isEmpty) {
        _endReached = true;
      } else {
        _posts.addAll(page);
        _start += _limit;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
