import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/login_with_phone_number.dart';
import 'package:firebase_practice/ui/auth/signup_screen.dart';
import 'package:firebase_practice/ui/posts/post_screen.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formField=GlobalKey<FormState>();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  late bool loading=false;

  final _auth=FirebaseAuth.instance;
  void login(){
    setState(() {
      loading=true;
    });
    _auth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passwordController.text.toString()).then((val){
      setState(() {
        loading=false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>PostScreen()));
      Utils().toastMessage("Login successfully");
    }).onError((error,stackTrace){
      setState(() {
        loading=false;
      });
      Utils().toastMessage(error.toString());
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return  true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login"),
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

              RoundButton(loading: loading,title: "login",onTap: (){
                if(_formField.currentState!.validate()){
                  login();
                }
              },),
              Row(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  TextButton(onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>SignupScreen()));
                  }, child: Text("Sign up"))
                ],
              ),
              SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginWithNumber()));
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.black
                    )
                  ),
                  child: Center(
                    child: Text("Login with phone"),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
