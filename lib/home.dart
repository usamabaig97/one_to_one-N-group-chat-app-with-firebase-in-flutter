import 'package:flutter/material.dart';
import 'package:project1/authentication/authservice.dart';
import 'modify_screen.dart';
class Home_screen extends StatefulWidget {
  const Home_screen({Key? key}) : super(key: key);

  @override
  _Home_screenState createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {

  Icon customIcon = Icon(Icons.search_sharp);
  Widget customSearchBar = Text('Search an User');

  TextEditingController controller = TextEditingController();

  List userProfileList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdatabaseList();
  }

  fetchdatabaseList() async{
    dynamic resultant = await getUserList();
    if(resultant == null){
      print('Unable to get data bb');
    }
    else{
      setState(() {
        userProfileList = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: customSearchBar,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if(customIcon.icon == Icons.search_sharp)
                  {
                    customIcon = Icon(Icons.cancel);
                    customSearchBar = ListTile(
                      tileColor: Colors.deepPurpleAccent,
                      leading: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 28,
                      ),
                      title: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          hintText: 'Search an user...',
                          hintStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                else{
                  customIcon = Icon(Icons.search_sharp);
                  customSearchBar = const Text('Search an User');
                }
              });
            },
            icon: customIcon,
          )
        ],
        centerTitle: true,
      ),
      body: Container(
        color: Colors.indigo,
        child: ListView.builder(
            itemCount: userProfileList.length,
            itemBuilder: (context, index)
            {
          return Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage('${userProfileList[index]['url']}'),
              ),
              title: Text('${userProfileList[index]['name']}'),
              subtitle: Text('${userProfileList[index]['age']}'),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         Navigator.push(context, MaterialPageRoute(builder: (context) => Modify_screen()));
        },
        child: Icon(Icons.update),
        tooltip: 'update profile',
      ),
    );
  }
}
