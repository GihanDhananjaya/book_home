import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../../utils/app_colors.dart';
import '../utils/app_images.dart';
import 'app_button.dart';


class ProfileImageUi extends StatefulWidget {
  final String? url;
  final String title;
  final Function(Uint8List?, String?)? onChanged;

  const ProfileImageUi({
    Key? key,
    required this.title,
    this.onChanged,
    this.url,
  }) : super(key: key);

  @override
  _ProfileImageUiState createState() => _ProfileImageUiState();
}

class _ProfileImageUiState extends State<ProfileImageUi> {
  File? _image;
  String? _extension;

  void showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Profile image',style: TextStyle(fontSize: 22))),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Camera',style: TextStyle(fontSize: 20)),
                  onTap: () {
                    getImage(0);
                    Navigator.of(context).pop();
                  },
                ),
                const SizedBox(height: 10),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Gallery',style: TextStyle(fontSize: 20)),
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
          source:
          selectionMode == 0 ? ImageSource.camera : ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _extension = p.extension(pickedFile.path);
          if (widget.onChanged != null) {
            final bytes = _image!.readAsBytesSync();
            widget.onChanged!(bytes, _extension);
          }
        } else {
          print('No image selected.');
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(children: [
          CircleAvatar(
            radius: 65,
            backgroundColor: AppColors.fontLabelGray,
            child: CircleAvatar(
              backgroundColor: AppColors.colorDisableWidget,
              radius: 65,
              child: _image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.file(
                  _image!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : widget.url != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.url!,
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
                  : const Icon(Icons.book, size: 50,color: AppColors.fieldBackgroundColor),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 5,
            child: GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: AppColors.fontBackgroundColor),
                  height: 40,
                  width: 40,
                  child: Icon(Icons.add_a_photo)),
              onTap: () {
                showImagePickerDialog();
              },
            ),
          )
        ]),

        Center(
          child: Text(widget.title,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: AppColors.fontColorWhite)),
        ),
      ],
    );
  }
}
