//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project1/authentication/authentication.dart';
import 'package:project1/authentication/authservice.dart';
import 'package:project1/chat_screen.dart';
import 'package:project1/slide_animation.dart';
import 'animation.dart';
import 'modify_screen.dart';

class Home_screen extends StatefulWidget {
  const Home_screen({Key? key}) : super(key: key);
  static String id = 'home';
  @override
  _Home_screenState createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

 // late User _user;

  bool isLoading = false;

  String? a;

  Icon customIcon = Icon(Icons.search_sharp);
  // Widget customSearchBar = Text('Search an User');

  TextEditingController controller = TextEditingController();

  List userProfileList = [];
  List _foundUser = [];
  List gusers = [];
  List pusersNgusers = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _foundUser = userProfileList;
    fetchdatabaseList();
    if (_foundUser == null) {
      setState(() {
        isLoading = true;
      });
    }
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

  }



  fetchdatabaseList() async {
    dynamic gresultant = await getGroupsList();
    if(gresultant == null){
      print('unable to get group data');
    } else{
      setState(() {
        gusers = gresultant;
       // print(gusers);
      });
    }
    dynamic resultant = await getUserList();
    if (resultant == null) {
      print('Unable to get data bb');
    } else {
      setState(() {
        userProfileList = resultant;
        _foundUser = userProfileList;
        //  print(userProfileList);
        // print(resultant);
      //  print(_foundUser);
      });
    }
    pusersNgusers = gusers + _foundUser;
    print(pusersNgusers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => _runFilter(value),
                      style: TextStyle(color: Colors.white),
                      //controller: controller,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        prefixIcon: Icon(Icons.search_sharp),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                title: Text('Sign Out'),
                                content: Text('Do you want logout?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      var snackBar = SnackBar(
                                          content: Text('User Signed Out'));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Authentication()));
                                    },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ));
                    },
                    icon: Icon(Icons.logout),
                    iconSize: 25.0,
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: pusersNgusers.length,
                      itemBuilder: (context, index) {
                        return _listIteme(index);
                      }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, BouncyPageRoute(widget: Modify_screen()));
        },
        child: Icon(Icons.edit),
        tooltip: 'Edit profile',
      ),
    );
  }

  String pid ='emmpty peer id';
  String userName = 'name not available';
  String peerAvatar = 'peer avatar not available';
  String groupId = 'gid not available';
  String type = '';



  _listIteme(index) {
    return SlideAnimation(
      itemCount: pusersNgusers.length,
      position: index,
      slideDirection: SlidDirection.fromBottom,
      animationController: _animationController,
      child: Card(
        color: Colors.white,
        child: ListTile(
          onTap: () {

              peerAvatar = pusersNgusers[index]['url'];
              userName = pusersNgusers[index]['name'];

             if(pusersNgusers[index]['type'] == '1'){
               setState(() {
                 pid = '';
                 type = '1';
                 groupId =  pusersNgusers[index]['gid'];
               });

               Navigator.push(context, BouncyPageRoute(widget: Chat_screen(userName, peerAvatar, pid, type, groupId)));
             }
             else {
               setState(() {
                 groupId = '';
                 type = '0';
                 pid = pusersNgusers[index]['uid'];
               });

               Navigator.push(context, BouncyPageRoute(widget: Chat_screen(userName, peerAvatar, pid, type, groupId)));
             }

            print(pid);
            print(userName);
            print(groupId);
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage('${pusersNgusers[index]['url']}'),
          ),
          title: Text('${pusersNgusers[index]['name']}'),
          subtitle: Text('${pusersNgusers[index]['age']}'),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List resultce = [];
    if (enteredKeyword.isEmpty) {
      resultce = userProfileList;
    } else {
      resultce = userProfileList
          .where((user) => user['name']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundUser = resultce;
    });
  }

}
