import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final ImagePicker imagePicker;
  final Function(XFile?) onChanged;
  final String? errorMessage;

  const ImagePickerWidget({
    Key? key,
    required this.imagePicker,
    required this.onChanged,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Pick an image from your device.'),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            final image =
                await imagePicker.pickImage(source: ImageSource.gallery);
            if (image != null) {
              onChanged(image);
            }
          },
          child: const Text('Pick Image'),
        ),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  }
}
