import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfService {
  /// Picks a PDF and returns its full text content as a String.
  /// Returns null if user cancels.
  Future<String?> pickAndExtractText() async {
    try {
      // 1. Pick the file
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true, // REQUIRED for Web to get bytes
      );

      if (result == null) return null;

      // 2. Get the bytes (Cross-platform safe)
      // On web, bytes are always available if withData: true.
      // On mobile, we might need to read from path if bytes are null,
      // but file_picker usually handles small files well in memory.
      Uint8List? fileBytes = result.files.first.bytes;

      if (fileBytes == null) {
        // Fallback or error if not loaded.
        // For this implementation we rely on bytes being present.
        throw Exception(
            "Could not read file data. Please try a smaller PDF or check permissions.");
      }

      // 3. Extract Text
      final PdfDocument document = PdfDocument(inputBytes: fileBytes);
      String text = PdfTextExtractor(document).extractText();

      document.dispose();

      if (text.trim().isEmpty) {
        throw Exception("No text found. This might be a scanned image PDF.");
      }

      return text;
    } catch (e) {
      // Re-throw to let UI handle the specific error message
      throw Exception("Error extracting PDF: $e");
    }
  }
}
