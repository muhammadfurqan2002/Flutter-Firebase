import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/round_button.dart';
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker=ImagePicker();

  Future getImageGallery()async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery,imageQuality: 80);
    setState(() {
      if(pickedFile!=null){
        _image=File(pickedFile.path);
      }else{
        print("No image picked up");
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Image"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            InkWell(
              onTap: (){
                  getImageGallery();
              },
              child: Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:Border.all(
                      color: Colors.black
                    )
                  ),
                  child: _image!=null? Image.file(_image!.absolute) : Icon(Icons.image,size: 90,),
                ),
              ),
            ),
          SizedBox(height: 30,),
          Padding(
              padding: EdgeInsets.all(20),
              child: RoundButton(title: "upload", onTap: () {  },))
        ],
      ),
    );
  }
}
