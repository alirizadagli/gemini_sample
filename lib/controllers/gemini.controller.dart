import 'dart:developer';

import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class GeminiController {
  late final String _apiKey;
  late final GenerativeModel _model;

  GeminiController() {
    _init();
  }

  void _init() async {
    _apiKey = const String.fromEnvironment("gemini_key");
    if (_apiKey.isEmpty) {
      throw UnimplementedError(
        "Visit here: https://dart.dev/guides/environment-declarations",
      );
    }
    _model = GenerativeModel(model: 'gemini-pro-vision', apiKey: _apiKey);
  }

  Future<XFile?> _getImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      return image;
    } catch (e) {
      log(e.toString(), name: "ERROR: GeminiController >> getImage()");
    }
    return null;
  }

  Future<String?> _callAPI({
    required String mime,
    required Uint8List bytes,
  }) async {
    const prompt =
        'Comment on my style and give me some advice based on this picture:';
    final content = [
      Content.multi(
        [
          TextPart(prompt),
          DataPart(mime, bytes),
        ],
      ),
    ];
    try {
      final response = await _model.generateContent(content);
      return response.text;
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getResponse() async {
    final image = await _getImage();
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    final mime = image.mimeType ?? lookupMimeType("", headerBytes: bytes);
    if (mime == null) throw Exception("mime type couldn't be detected.");
    return _callAPI(
      mime: mime,
      bytes: bytes,
    );
  }
}
