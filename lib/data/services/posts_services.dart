import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/posts.dart';
class PostsService {
  final _base = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Post>> fetch({required int start, required int limit}) async {
    final uri = Uri.parse('$_base?_start=$start&_limit=$limit');
    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('Failed with status ${res.statusCode}');
    }
    final data = (jsonDecode(res.body) as List).cast<Map<String, dynamic>>();
    return data.map(Post.fromJson).toList();
  }
}
