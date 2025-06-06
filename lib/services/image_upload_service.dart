import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pet_store_mobile_app/config/env_config.dart';

class ImageUploadService {
  static final String _imgbbApiKey = EnvConfig.imgBBApiKey;
  static const String _imgbbUrl = 'https://api.imgbb.com/1/upload';

  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from camera: $e');
      return null;
    }
  }

  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 80,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image from gallery: $e');
      return null;
    }
  }

  Future<String?> uploadReviewImage(File imageFile) async {
    try {
      print('Starting image upload to ImgBB...');

      // Convert image to base64
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Prepare request
      var request = http.MultipartRequest('POST', Uri.parse(_imgbbUrl));
      request.fields['key'] = _imgbbApiKey;
      request.fields['image'] = base64Image;
      request.fields['expiration'] = '0'; // Never expire

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('ImgBB Response Status: ${response.statusCode}');
      print('ImgBB Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          String imageUrl = jsonResponse['data']['url'];
          print('Image uploaded successfully: $imageUrl');
          return imageUrl;
        } else {
          throw Exception(
              'ImgBB API error: ${jsonResponse['error']['message']}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Alternative method using a different free service
  Future<String?> uploadToFreeImageHost(File imageFile) async {
    try {
      print('Uploading to alternative service...');

      var request = http.MultipartRequest(
          'POST', Uri.parse('https://tmpfiles.org/api/v1/upload'));

      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status'] == 'success') {
          return jsonResponse['data']['url'];
        }
      }

      return null;
    } catch (e) {
      print('Error uploading to alternative service: $e');
      return null;
    }
  }
}
