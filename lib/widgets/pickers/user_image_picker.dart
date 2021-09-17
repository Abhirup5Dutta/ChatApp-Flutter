import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _pickImage(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openGallery(BuildContext context) async {
    final picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 50,
    );
    this.setState(() {
      _pickedImage = picture;
    });

    widget.imagePickFn(picture);

    Navigator.of(context).pop();
  }

  File _pickedImage;

  void _pickImage(BuildContext context) async {
    final pickedImageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 50,
    );
    setState(() {
      _pickedImage = pickedImageFile;
    });

    widget.imagePickFn(pickedImageFile);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage)
              : NetworkImage(
                  'https://rpgplanner.com/wp-content/uploads/2020/06/no-photo-available.png'),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () {
            _showSelectionDialog(context);
          },
          icon: Icon(Icons.camera_alt),
          label: Text('Add Image'),
        ),
      ],
    );
  }
}
