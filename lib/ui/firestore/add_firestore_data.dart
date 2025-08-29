import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/round_button.dart';

class AddFirestoreData extends StatefulWidget {
  const AddFirestoreData({super.key});

  @override
  State<AddFirestoreData> createState() => _AddFirestoreDataState();
}

class _AddFirestoreDataState extends State<AddFirestoreData> {
  final postController=TextEditingController();
  bool loading=false;
  final fireStore=FirebaseFirestore.instance.collection("users");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Firestore Data"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 30),
        child: Column(
          children: [
            TextFormField(
              maxLines: 5,
              controller: postController,
              decoration: InputDecoration(
                hintText: "what's going in your mind",
                border: OutlineInputBorder(),


              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: "Add", onTap: ()async{
              final String id=DateTime.now().microsecondsSinceEpoch.toString();

              fireStore.doc(id).set({
                "title":postController.text.toString(),
                "id":id
              }).then((val)=>{
                Utils().toastMessage("Post created")
              }).onError((error,stackTrace)=>{
              Utils().toastMessage(error.toString())
              });
            }),
          ],
        ),
      ),
    );
  }
}
