import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:crypto/crypto.dart';
import '../constants/app_constants.dart';

class CloudinaryService {
  Future<String> uploadImage(File file) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    
    // Parameters to be signed (must be sorted alphabetically for signature)
    final params = {
      'folder': AppConstants.cloudinaryFolder,
      'timestamp': timestamp.toString(),
    };

    final signature = _generateSignature(params, AppConstants.cloudinaryApiSecret);

    final url = Uri.parse('https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/auto/upload');
    
    final request = http.MultipartRequest('POST', url)
      ..fields['api_key'] = AppConstants.cloudinaryApiKey
      ..fields['timestamp'] = timestamp.toString()
      ..fields['signature'] = signature
      ..fields['folder'] = AppConstants.cloudinaryFolder
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: p.basename(file.path),
      ));

    print('Uploading to Cloudinary (Signed): ${file.path}...');
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);
        print('Cloudinary Upload Success: ${data['secure_url']}');
        return data['secure_url'];
      } else {
        final errorData = json.decode(responseBody);
        final errorMsg = errorData['error']?['message'] ?? responseBody;
        final error = 'Cloudinary Upload Failed: ${response.statusCode} - $errorMsg';
        print(error);
        throw Exception(error);
      }
    } catch (e) {
      print('Cloudinary Error Detail: $e');
      throw Exception('Cloudinary Error: $e');
    }
  }

  String _generateSignature(Map<String, String> params, String apiSecret) {
    // Sort parameters alphabetically
    final sortedKeys = params.keys.toList()..sort();
    
    // Join as key=value&key2=value2
    final queryString = sortedKeys
        .map((key) => '$key=${params[key]}')
        .join('&');
    
    // Append API Secret and SHA-1 hash
    final toSign = queryString + apiSecret;
    return sha1.convert(utf8.encode(toSign)).toString();
  }

  Future<void> deleteImage(String url) async {
    // Note: Deleting images generally requires a signed request.
    // Since we now have API Key/Secret, we could implement this if needed.
    print('Cloudinary delete requested for: $url (Action skipped for focus on upload)');
  }
}
