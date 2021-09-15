import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

Future<bool?> signin(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return false;
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return false;
    }
  }

}
Future<bool?> register(String email, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}
/*Future<bool> updateuser(String id,String age) async {
  try{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var value = int.parse(age);
    DocumentReference documentReference = FirebaseFirestore.instance.collection('users').doc(uid).collection('data').doc(id);
    FirebaseFirestore.instance.runTransaction((transaction) async{
      DocumentSnapshot snapshot = await transaction.get(documentReference);
      if(!snapshot.exists){
        documentReference.set({'age' : age});
        return true;
      }
      transaction.update(documentReference, {'age': age});
      return true;
    });
    return true;
  }
  catch(e) {
    print(e);
    return false;
  }
}*/
Future<bool?> updateuser(String age,String name,String url) async {
  try{
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = FirebaseAuth.instance.currentUser!.uid;
    users.doc(uid).set({
      'name': name,
      'age': age,
      'url': url,
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  return true;
  }
  catch(e){
    print(e);
    return false;
  }
}

var pathOfFile;
var nameOfFile;
var url;

Future<bool?> selectFile() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path);
      String fileName = result.files.first.name;
      nameOfFile = fileName;
      pathOfFile = file;
      print(file.path);
      return true;
    } else {
      // User canceled the picker
    }
    return true;
  }
  catch(e){
    print(e);
    return false;
  }
 // setState(() {});
}
Future<bool?> uploadFile() async {
  try{
      // Upload file
      await FirebaseStorage.instance.ref('uploads/$nameOfFile').putFile(pathOfFile);
      String downloadURL = await firebase_storage.FirebaseStorage.instance
          .ref('uploads/$nameOfFile')
          .getDownloadURL();
      url = downloadURL;
      print(downloadURL);
      print('File uploaded bro');
      return true;
    }
    catch(e){
    print(e);
    return false;
  }
}

Future getUserList() async {

  List itemsList = [];

try{
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.get().then((QuerySnapshot) {
    QuerySnapshot.docs.forEach((element) {
      itemsList.add(element.data());
    });
  });
  return itemsList;
}
catch(e){
  print(e);
}
}



Future updateProfile(String name,String age) async {
  try{
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    String uid = FirebaseAuth.instance.currentUser!.uid;
    users.doc(uid).update({
      'name': name,
      'age': age,
    })
        .then((value) => print("Profile Updated"))
        .catchError((error) => print("Failed to add user: $error"));
  }
  catch(e){
    print(e.toString());
  }
}


/*Future<void> uploadFile(String filePath) async {

  File file = File(filePath);

  try {
    await firebase_storage.FirebaseStorage.instance
        .ref('uploads/file-to-upload.png')
        .putFile(file);
  } on firebase_core.FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
  }
}*/