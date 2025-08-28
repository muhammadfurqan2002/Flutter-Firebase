
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/posts/add_post.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth=FirebaseAuth.instance;
  final ref=FirebaseDatabase.instance.ref("Post");
  final searchController=TextEditingController();
  final editController=TextEditingController();
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
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                border: OutlineInputBorder()
              ),
              onChanged: (String val){
                setState(() {

                });
              },
            ),
          ),
          Expanded(
            // child: FirebaseAnimatedList(
            //   defaultChild: Text("Loading..."),
            //     query:ref, itemBuilder:(context,snapshot,animation,index){
            //   return ListTile(title: Text(snapshot.child("title").value.toString()),);
            // }),
            child: StreamBuilder( builder: (context,AsyncSnapshot<DatabaseEvent> snapshot){

              if(!snapshot.hasData){
                return CircularProgressIndicator();
              }else

              return ListView.builder(
                  itemCount: snapshot.data!.snapshot.children.length,
                  itemBuilder: (context,index){
                    Map<dynamic,dynamic> map=snapshot.data!.snapshot.value as dynamic;
                    List<dynamic> list=[];
                    list.clear();
                    list=map.values.toList();
                    final title=list[index]['title'].toString();
                    final id=list[index]['id'].toString();
                    if (searchController.text.isEmpty ||
                        title.toLowerCase().contains(searchController.text.toLowerCase())) {
                      return ListTile(
                        title: Text(title),
                        subtitle: Text(id),
                        trailing: PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (context)=>[
                              PopupMenuItem(
                                  value:1,
                                  child: ListTile(
                                leading: Icon(Icons.edit),
                                title: Text("Edit"),
                              )),PopupMenuItem(
                                  value:2,
                                  child: ListTile(
                                   onTap:(){
                                     Navigator.pop(context);
                                     ref.child(id).remove();
                                   },
                                leading: Icon(Icons.delete),
                                title: Text("Delete"),
                              )),
                            ]),
                      );
                    } else {
                      return SizedBox.shrink(); // don't render if not matching
                    }
              });
            }, stream: ref.onValue,),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddPost()));
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
            ref.child(id).update({
              "title":editController.text.toString()
            }).then((val)=>{
               Utils().toastMessage("Updated")
            }).onError((error,stackTrace)=>{
              Utils().toastMessage("Error updating")
            });
          }, child: Text("update"))
        ],
      );
    });
  }
}
