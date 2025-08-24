import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/verification_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginWithNumber extends StatefulWidget {
  const LoginWithNumber({super.key});

  @override
  State<LoginWithNumber> createState() => _LoginWithNumberState();
}

class _LoginWithNumberState extends State<LoginWithNumber> {
  final phoneNumberController=TextEditingController();
  late final login=false;
  final _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
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
              hintText: "+1974985795"
              ),
            ),
            SizedBox(height: 50,),
            RoundButton(title: "Login", onTap: (){
              _auth.verifyPhoneNumber(
                phoneNumber: phoneNumberController.text,
                  verificationCompleted: (_){

                  }, 
                  verificationFailed: (e){
                    Utils().toastMessage(e.toString());
                  }, 
                  codeSent: (String verificationId,int?token){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>VerifyUser(verificationId: verificationId)));
                  },
                  codeAutoRetrievalTimeout: (e){

                    Utils().toastMessage(e.toString());
                  });
            })
          ],
        ),
      ),
    );
  }
}
