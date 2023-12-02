import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../../utils/app_colors.dart';
import '../../../common/app_button.dart';

class CoverImage extends StatefulWidget {
  final String? url;
  final Function(File?, String?)? onChanged;

  const CoverImage({
    Key? key,
    this.onChanged,
    this.url,
  }) : super(key: key);

  @override
  _CoverImageState createState() => _CoverImageState();
}

class _CoverImageState extends State<CoverImage> {
  File? _image;
  String? _extension;

  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Profile image', style: TextStyle(fontSize: 22))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Camera', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    getImage(0);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Gallery', style: TextStyle(fontSize: 20)),
                  onTap: () {
                    getImage(1);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10),
                AppButton(
                  buttonText: 'Cancel',
                  onTapButton: () {
                    Navigator.pop(context);
                  },
                  buttonColor: AppColors.colorPrimary,
                  textColor: AppColors.colorFailed,
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImage(int selectionMode) async {
    final pickedFile = await ImagePicker().pickImage(
      source: selectionMode == 0 ? ImageSource.camera : ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _extension = p.extension(pickedFile.path);
        if (widget.onChanged != null) {
          widget.onChanged!(_image, _extension);
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          Container(
            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(10)),
            width: 100,
            height: 60,
            child: Container(
              decoration: BoxDecoration(color: AppColors.textBackgroundColor, borderRadius: BorderRadius.circular(10)),
              width: 100,
              height: 60,
              child: _image != null
                  ? Container(
                width: 90,
                height: 60,
                child: Image.file(
                  _image!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : widget.url != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.url!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.book, size: 10, color: AppColors.fieldBackgroundColor),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 1,
            child: GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), color: AppColors.primaryBackgroundColor),
                height: 20,
                width: 20,
                child: Icon(Icons.add_a_photo, size: 15),
              ),
              onTap: () {
                showImagePickerDialog();
              },
            ),
          )
        ]),
      ],
    );
  }
}
