import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/posts/post_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class VerifyUser extends StatefulWidget {
  final String verificationId;
  const VerifyUser({super.key,required this.verificationId});

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final phoneNumberController=TextEditingController();
  late final login=false;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              decoration: InputDecoration(
                  hintText: "6 digits code"
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: "Verify", onTap: ()async{
                    final credentials=PhoneAuthProvider.credential(
                        verificationId: widget.verificationId, smsCode:phoneNumberController.text);
                  try{
                      await _auth.signInWithCredential(credentials);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
                  }catch(e){
                      Utils().toastMessage(e.toString());
                  }
            })
          ],
        ),
      ),
    );
  }
}
