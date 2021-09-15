import 'package:flutter/material.dart';
import 'package:project1/authentication/authservice.dart';
class Modify_screen extends StatefulWidget {
  const Modify_screen({Key? key}) : super(key: key);

  @override
  _Modify_screenState createState() => _Modify_screenState();
}

class _Modify_screenState extends State<Modify_screen> {

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

  TextEditingController modifyName = TextEditingController();
  TextEditingController modifyDob = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
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
                controller: modifyName,
                decoration: InputDecoration(
                  hintText: "Enter new name",
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
              width: MediaQuery.of(context).size.width / 2.8,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.cyan,
              ),
              child: MaterialButton(
                onPressed: () async {
                  // print('tapped');
                  print(modifyName);
                  print(modifyDob);

                  await updateProfile(modifyName.text, date.toString().substring(0, 10));
                },
                child: Text("Update"),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
          ],
        ),
      ),
    );
  }
}
