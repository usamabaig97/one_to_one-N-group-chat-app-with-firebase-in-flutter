import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat_screen extends StatefulWidget {
  final String userName;
  final String peerid;
  final String peerAvatar;
  final String type;
  final String groupId;
  const Chat_screen(this.userName, this.peerAvatar, this.peerid,this.type, this.groupId, {Key? key})
      : super(key: key);

  @override
  _Chat_screenState createState() => _Chat_screenState();
}

class _Chat_screenState extends State<Chat_screen> {
  TextEditingController mcontroller = TextEditingController();

  List<QueryDocumentSnapshot> listMessage = new List.from([]);                      //copied line
  int _limit = 20;

  String? id;
  late String peerId;
  String message = '';

  String? type;
  String? groupId;
  String? peerAvatar;



  String? groupChatId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    type = widget.type;
     peerId = widget.peerid;
     groupId = widget.groupId;
     peerAvatar = widget.peerAvatar;

    String uid = FirebaseAuth.instance.currentUser!.uid;
    id = uid;

    if(peerId == ''){
      groupChatId = groupId;
      peerAvatar = '';
    }else {
      if (uid.hashCode <= peerId.hashCode) {
        groupChatId = '$uid-$peerId';
      } else {
        groupChatId = '$peerId-$uid';
      }
    }
    print(groupChatId);
    print(type);
    print(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        title: Text(widget.userName),
        actions: [
          IconButton(
            onPressed: null,
            icon: CircleAvatar(
              backgroundImage: NetworkImage(peerAvatar!),
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildListMessage(),
            Divider(
              height: 10,
              color: Colors.black,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: mcontroller,
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Type message here...',
                        fillColor: Colors.blueGrey[200],
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 0),
                          gapPadding: 10,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                      // onChanged: (value) {
                      //   setState(() {
                      //     message = value;
                      //   });
                      // },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onSendMessage(mcontroller.text);
                    },                                             //send message button
                    icon: Icon(Icons.send),
                    iconSize: 35.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      if (document.get('idFrom') == id) {
        // Right (my message)
        return Row(
          children: <Widget>[
               Container(
                child: Text(
                  document.get('content'),
                  style: TextStyle(color: Colors.blueAccent),
                ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration:
                BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(8.0)),
                margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20.0 : 10.0, right: 10.0),
              ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                    child: Image.network(
                      peerAvatar!,
                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 35,
                          color: Colors.grey,
                        );
                      },
                      width: 35,
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    clipBehavior: Clip.hardEdge,
                  )
                      : Container(width: 35.0),
                  Container(                                                            //i added by myself
                    child: Text(
                      document.get('content'),
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: Colors.greenAccent[400], borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                child: Text(
                  DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(int.parse(document.get('timestamp')))),
                  style: TextStyle(color: Colors.grey, fontSize: 12.0, fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
              )
                  : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }


  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') == id) || index == 0) {
      print(index);
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get('idFrom') != id) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId!.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('messages')
            .doc(groupChatId)
            .collection(groupChatId!)
            .orderBy('timestamp', descending: true)
            .limit(_limit)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage.addAll(snapshot.data!.docs);
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => buildItem(index, snapshot.data?.docs[index]),
              itemCount: snapshot.data?.docs.length,
              reverse: true,
             // controller: listScrollController,
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
            print('else');
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
  void onSendMessage(String content) {
    if (content.trim() != '') {

      mcontroller.clear();

      var documentReference = FirebaseFirestore.instance
          .collection('messages')
          .doc(groupChatId)
          .collection(groupChatId!)
          .doc(DateTime.now().millisecondsSinceEpoch.toString());

      FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': content,
            'type': type,
          },
        );
      });
     // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
    //  Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: Colors.black, textColor: Colors.red);
    }
  }
}
