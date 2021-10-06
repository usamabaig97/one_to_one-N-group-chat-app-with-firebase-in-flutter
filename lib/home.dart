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

  late User _user;

  bool isLoading = false;

  String? a;

  Icon customIcon = Icon(Icons.search_sharp);
  // Widget customSearchBar = Text('Search an User');

  TextEditingController controller = TextEditingController();

  List userProfileList = [];
  List _foundUser = [];

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
    dynamic resultant = await getUserList();
    if (resultant == null) {
      print('Unable to get data bb');
    } else {
      setState(() {
        userProfileList = resultant;
        _foundUser = userProfileList;
        //  print(userProfileList);
        // print(resultant);
        print(_foundUser);
      });
    }
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
                      itemCount: _foundUser.length,
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

  String? peerid;
  String? userName;
  String? peerAvatar;

  _listIteme(index) {
    return SlideAnimation(
      itemCount: _foundUser.length,
      position: index,
      slideDirection: SlidDirection.fromBottom,
      animationController: _animationController,
      child: Card(
        color: Colors.white,
        child: ListTile(
          onTap: () {
            peerAvatar = _foundUser[index]['url'];
            peerid = _foundUser[index]['uid'];
            userName = _foundUser[index]['name'];
            Navigator.push(
                context,
                BouncyPageRoute(
                    widget: Chat_screen(userName!, peerAvatar!, peerid!)));
            print(peerid);
            print(userName);
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage('${_foundUser[index]['url']}'),
          ),
          title: Text('${_foundUser[index]['name']}'),
          subtitle: Text('${_foundUser[index]['age']}'),
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
