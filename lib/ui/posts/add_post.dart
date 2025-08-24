import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {

  final postController=TextEditingController();
  final databaseRef=FirebaseDatabase.instance.ref("Post");
  bool loading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
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
                  await databaseRef.child(id).set({
                    'title':postController.text.toString(),
                    'id':id
                  }).then((val){

                    Utils().toastMessage("Post uploaded!");
                  }).onError((error,stackTrace){
                    Utils().toastMessage(error.toString());
                  });
            }),
          ],
        ),
      ),
    );
  }
}
