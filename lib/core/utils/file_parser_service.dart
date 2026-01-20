/*
import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_text/pdf_text.dart';

class FileParserService {
  static Future<String?> pickAndParseFile() async {
    try {
      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'txt'],
        withData: true, // Critical for Web
      );

      if (result == null) return null;

      PlatformFile file = result.files.first;

      // 2. Parse based on extension
      // Note: On web, path might be null, so we rely on bytes or extension check
      // extension usually comes without dot
      final extension = file.extension?.toLowerCase();

      if (extension == 'txt') {
        // Decode bytes to string
        if (file.bytes != null) {
         // return String.fromCharCodes(file.bytes!);
         return utf8.decoder.convert(file.bytes);
        }
      } else if (extension == 'pdf') {
        // Use pdf_text to extract
        if (file.bytes != null) {
          PDFDoc doc = await PDFDoc.fromBytes(file.bytes!);
          return await doc.text;
        }
      }
    } catch (e) {
      throw Exception("Failed to parse file: $e");
    }
    return null;
  }
}
*/