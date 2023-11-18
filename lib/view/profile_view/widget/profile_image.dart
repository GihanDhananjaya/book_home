import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_images.dart';
import '../../../../common/app_button.dart';

class ProfileImage extends StatefulWidget {
  final String? url;
  final String? title;
  final String? subtitle;
  final Function(Uint8List?, String?)? onChanged;

  const ProfileImage({
    Key? key,
    this.title,
    this.onChanged,
    this.url,
    this.subtitle,
  }) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
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
        Stack(
          children: [
            CircleAvatar(
              radius: 71,
              backgroundColor: AppColors.fontColorWhite,
              child: CircleAvatar(
                backgroundColor: AppColors.fontColorWhite,
                radius: 71,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white, // Set the border color to white
                      width: 4.0, // Adjust the border width as needed
                    ),
                  ),
                  child: _image != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.file(
                      _image!,
                      width: 140.w,
                      height: 140.h,
                      fit: BoxFit.cover,
                    ),
                  )
                      : widget.url != null
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      widget.url!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  )
                      : const Icon(Icons.person, size: 50),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 5,
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: AppColors.colorPrimary,
                  ),
                  height: 40.h,
                  width: 40.w,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(''),
                  ),
                ),
                onTap: () {
                  showImagePickerDialog();
                },
              ),
            )
          ],
        ),
        SizedBox(height: 10.h),
        Column(
          children: [
            Text(widget.title!,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                    color: AppColors.fontColorDark)),
            SizedBox(height: 10),
            Text(widget.subtitle!,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                    color: AppColors.fontColorDark)),
          ],
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}
