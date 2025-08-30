import 'package:cloudinary_api/uploader/cloudinary_uploader.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../widgets/round_button.dart';
class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? _image;
  final picker=ImagePicker();
  final cloudinary = CloudinaryPublic(
    '',           // 👈 your Cloudinary cloud name
    'flutter',// 👈 the unsigned preset from dashboard
    cache: false,
  );

  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  DatabaseReference dbRef=FirebaseDatabase.instance.ref("Post");
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
              child: RoundButton(title: "upload", onTap: ()async{
                try {
                  CloudinaryResponse response = await cloudinary.uploadFile(
                    CloudinaryFile.fromFile(
                      _image!.path,
                      resourceType: CloudinaryResourceType.Image,
                      folder: "user_uploads"
                    ),
                  );


                  dbRef.child('00971').set({
                    'id':'00971',
                    'title':response.secureUrl.toString()
                  }).then((val)=>{
                    print("upload in firebase")
                  }).onError((error,stackTrace)=>{

                  });


                } on CloudinaryException catch (e) {
                  print("❌ Cloudinary error: ${e.message}");
                } catch (e) {
                  print("❌ Upload error: $e");
                }

                // using firebase storage

              // },)) Padding(
              // padding: EdgeInsets.all(20),
              // child: RoundButton(title: "upload", onTap: ()async{
              //
              //   firebase_storage.Reference ref= firebase_storage.FirebaseStorage.instance.ref('/foldername'+DateTime.now().millisecond.toString());
              //   firebase_storage.UploadTask uploadTask=ref.putFile(_image!.absolute);
              //   Future.value(uploadTask).then((value)async{
              //     var newUrl=await ref.getDownloadURL();
              //
              //     dbRef.child('1').set({
              //       'id':'1',
              //       'title':newUrl.toString()
              //     });
              //   }).onError((error,stackTrace){
              //
              //   });
              //
              //
              //
              },))
        ],
      ),
    );
  }
}
