import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageUploadWidget extends StatefulWidget {
  final Function(Uint8List) onImageSelected;
  final String? currentImage;

  ImageUploadWidget({required this.onImageSelected, this.currentImage});

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  Uint8List? _imageData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildImagePreview(),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _pickImage(),
          child: Text('Select Image'),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    if (_imageData != null) {
      return Image.memory(
        _imageData!,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    } else if (widget.currentImage != null) {
      return Image.network(
        widget.currentImage!,
        height: 200,
        width: 200,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        height: 200,
        width: 200,
        color: Colors.grey[300],
        child: Icon(
          Icons.image,
          size: 100,
          color: Colors.grey[600],
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    // Implement image picking logic, e.g., using an image picker package.
    // For simplicity, this example uses a dummy image.
    // Replace this part with your actual image picking logic.
    // For example, you can use packages like image_picker.
    // Ensure to call widget.onImageSelected with the selected image data.

    // Example using a dummy image
    List<int> dummyImageData = List.generate(300 * 300 * 4, (index) => index % 256).toList();
    Uint8List uint8ImageData = Uint8List.fromList(dummyImageData);
    widget.onImageSelected(uint8ImageData);
  }
}
