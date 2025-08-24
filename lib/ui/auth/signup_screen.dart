import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/round_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formField=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  final FirebaseAuth _auth=FirebaseAuth.instance;
  late bool loading=false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Signup"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formField,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "email",
                        helperText: "enter email e.g jon@gmail.com",
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (val){
                        if(val!.isEmpty){
                          return 'Enter Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(

                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "password",
                        helperText: "enter password e.g khjkfh7y",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (val){
                        if(val!.isEmpty){
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ],
                )),

            SizedBox(height: 20,),

            RoundButton(loading: loading,title: "Sign up",onTap: (){
              if(_formField.currentState!.validate()){

                setState(() {
                  loading=true;
                });
                  _auth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((val){

                    setState(() {
                      loading=false;
                    });
                              Utils().toastMessage("Sign up successfully");
                  }).onError((error,stackTrace){

                    setState(() {
                      loading=false;
                    });
                    Utils().toastMessage(error.toString());
                  });

              }
            },),
            Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Text("Already have an account?"),
                TextButton(onPressed: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen()));

                }, child: Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
