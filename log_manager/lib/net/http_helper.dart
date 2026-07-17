import 'dart:convert';
import 'dart:io';

class HttpHelper {
  Future<dynamic> sendPost({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    final client = HttpClient();
    try {
      final request = await client.postUrl(Uri.parse(url));
      request.headers.contentType = ContentType.json;
      if (body != null) {
        request.write(jsonEncode(body));
      }
      final response = await request.close();
    } catch (_) {
    } finally {
      client.close();
    }
  }
}
