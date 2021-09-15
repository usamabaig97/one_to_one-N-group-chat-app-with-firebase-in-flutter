import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project1/authentication/authservice.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  DateTime date = DateTime.now();
  Future<void> selectTimePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(1940),
        lastDate: DateTime(2030));
    if(picked != null && picked != date){
      setState(() {
        date = picked;
        print(date.toString());
      });
    }
  }

  // CollectionReference users = FirebaseFirestore.instance.collection('users'); //users

  TextEditingController name = TextEditingController();
  TextEditingController dob = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.indigo,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: name,
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Username",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: MaterialButton(
                onPressed: () async {
                  print('tapped');
                  selectTimePicker(context);
                },
                child: Text("Select DOB"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,
              ),
              child: MaterialButton(
                onPressed: () async {
                  print('tapped');
                  selectFile();
                },
                child: Text("Select Image"),
              ),
            ),
           // SizedBox(height: MediaQuery.of(context).size.height / 35),
            SizedBox(height: 50.0,),
            Container(
              width: MediaQuery.of(context).size.width / 2.8,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan,
              ),
              child: MaterialButton(
                onPressed: () async {
                  // print('tapped');
                  bool? vari = await uploadFile();
                  bool? shouldNavigate =
                  await updateuser(date.toString().substring(0, 10), name.text, url);
                  if (shouldNavigate! && vari!) {
                    print(name);
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
