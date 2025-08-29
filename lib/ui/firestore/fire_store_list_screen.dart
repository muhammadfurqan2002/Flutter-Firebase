import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/firestore/add_firestore_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/utils.dart';
import '../auth/login_screen.dart';

class FireStoreListScreen extends StatefulWidget {
  const FireStoreListScreen({super.key});

  @override
  State<FireStoreListScreen> createState() => _FireStoreListScreenState();
}

class _FireStoreListScreenState extends State<FireStoreListScreen> {
  final auth=FirebaseAuth.instance;
  final editController=TextEditingController();
  final fireStore=FirebaseFirestore.instance.collection("users").snapshots();
  CollectionReference fireStoreCollection=FirebaseFirestore.instance.collection("users");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Post Screen"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((val){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }).onError((error,stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(stream: fireStore,
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
              
              if(snapshot.connectionState== ConnectionState.waiting){
                return CircularProgressIndicator();
              }
              if(snapshot.hasError)return Text("Some Error");
              
              return
                Expanded(
                  child:ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context,index){
                        final doc=snapshot.data!.docs[index];
                    return ListTile(
                      onTap: (){
                        fireStoreCollection.doc(doc["id"].toString()).update({
                          "title":"updated the title of id"
                        }).then((val){

                        }).onError((error,stackTrace){

                        });

                        //   for deleting
                        // fireStoreCollection.doc(doc["id"].toString()).delete();
                      },

                      title: Text(doc['title']),
                    );
                  }),
                );
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddFirestoreData()));
      },child: Icon(Icons.add),),
    );


  }

  Future<void> showMyDialog(String text,String id){
    editController.text=text;
    return showDialog(context: context, builder:(BuildContext context){
      return AlertDialog(
        title: Text("Update"),
        content: Container(
          child: TextField(
            controller: editController,
          ),
        ),
        actions: [
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text("cancel")),
          TextButton(onPressed: (){
            Navigator.pop(context);


           }, child: Text("update"))
        ],
      );
    });
  }
}
