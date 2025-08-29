import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/ui/auth/login_screen.dart';
import 'package:firebase_practice/ui/firestore/fire_store_list_screen.dart';
import 'package:firebase_practice/ui/posts/post_screen.dart';
import 'package:firebase_practice/ui/upload_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashServices{

  void isLogin(BuildContext context){
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;
    if(user!=null){
      // Timer(Duration(seconds: 3),()=>    Navigator.push(context,MaterialPageRoute(builder: (context)=>PostScreen())));
      // Timer(Duration(seconds: 3),()=>    Navigator.push(context,MaterialPageRoute(builder: (context)=>FireStoreListScreen())));
      Timer(Duration(seconds: 3),()=>    Navigator.push(context,MaterialPageRoute(builder: (context)=>UploadImageScreen())));
    }else{
      Timer(Duration(seconds: 3),()=>    Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginScreen())));

    }

  }
}