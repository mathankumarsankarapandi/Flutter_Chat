import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/ChatOthers.dart';
import 'package:chat/Views/LogInView.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class ChatView extends StatefulWidget {
String title;
String photoUrl;
  ChatView(this.title, this.photoUrl);

  @override
  State<StatefulWidget> createState() {
    return ChatViewState();
  }
}

class ChatViewState extends State<ChatView> with WidgetsBindingObserver {
  CommonWidgets commonWidgets = CommonWidgets();
  double fontSize = 15;
  late Widget container;
double textContainerWidth = 0;

  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isObscurePassword = true;
  bool isChatClick = false;
  String roomId = '';
  String chatTitle = '';
  String userId = '';
  String userStatus = '';
  String userName = '';

  String chatRoomId(String currentUser, String receiver) {
    if(currentUser.toLowerCase() == receiver.toLowerCase()){
      return "${currentUser.toLowerCase()}${receiver.toLowerCase()}";
    }
    List<int> currentUserCodeUnits = currentUser.toLowerCase().codeUnits;
    List<int> receiverCodeUnits = receiver.toLowerCase().codeUnits;
    List<int> receiverModifiedList = [];
    List<int> currentUserModifiedList = [];
    String chatRoomId = '';
    int smallList = 0;
    int largeList = 0;
    if(currentUserCodeUnits.length >= receiverCodeUnits.length) {
      smallList = receiverCodeUnits.length;
      largeList = currentUserCodeUnits.length;
    } else {
      smallList = currentUserCodeUnits.length;
      largeList = receiverCodeUnits.length;
    }
    for(int i=0; i<largeList; i++) {
      if(i >= smallList){
        if(smallList == currentUserCodeUnits.length) {
          currentUserModifiedList.add(0);
          receiverModifiedList.add(receiverCodeUnits[i]);
        }
        else {
          receiverModifiedList.add(0);
          currentUserModifiedList.add(currentUserCodeUnits[i]);
        }
      } else {
        receiverModifiedList.add(receiverCodeUnits[i]);
        currentUserModifiedList.add(currentUserCodeUnits[i]);
      }
    }
      for(int i=0; i<largeList; i++){
        if(currentUserModifiedList[i] != receiverModifiedList[i]){
          if(currentUserModifiedList[i] > receiverModifiedList[i]){
            chatRoomId = "$currentUser$receiver";
            break;
          } else {
            chatRoomId = "$receiver$currentUser";
            break;
          }
        }
      }
    return chatRoomId;
  }

  /* String chatRoomId(String user1, String user2) {
    print("codeUnits$user1 ${user1.toLowerCase().codeUnits[0]}");
    print("codeUnits$user2 ${user2.toLowerCase().codeUnits}");
    if(user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }*/
  final Stream<QuerySnapshot> users = FirebaseFirestore.instance.collection("users").where('followStatus',isEqualTo: 'follow').snapshots();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<bool> onWillPop() {
    return showDialog_(context);
  }

  showDialog_(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black26,
          title: commonWidgets.getNormalTextWithBold("Alert", CommonWidgets.appThemeColor, 1, fontSize),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                commonWidgets.getNormalText("Do you want logout the user", CommonWidgets.appThemeColor, 1, fontSize),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(color:  CommonWidgets.appThemeColor, borderRadius: BorderRadius.circular(10)),
                      width: 100,
                      child: TextButton(
                          onPressed: () {
                            final provider = Provider.of<FirebaseAuthServices>(context,listen: false);
                            provider.Logout();
                            commonWidgets.storeBooleanInSharedPreferences('isRememberLogin', false);
                            commonWidgets.launchPage(context, NewLoginView());
                          }, child: commonWidgets.getNormalTextWithBold("OK",Colors.white , 1, fontSize)),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(color:  CommonWidgets.appThemeColor, borderRadius: BorderRadius.circular(10)),
                      width: 100,
                      child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, child: commonWidgets.getNormalTextWithBold("Cancel",Colors.white , 1, fontSize)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
  @override
  void initState() {

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    WidgetsBinding.instance!.addObserver(this);
      setStatus('online');
     getUserName();
    super.initState();
  }

  void setStatus( String status) async {
    await firebaseFirestore.collection('users').doc(firebaseAuth.currentUser!.uid).update(
        {'status': status});
  }

  void getUserName() async {
    userName = await CommonWidgets().getStringFromSharedPreferences('name');
  }

  @override
  void didChangeAppLifeCycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setStatus('online');
    } else {
      setStatus('offline');
    }
  }

  @override
  Widget build(BuildContext buildContext) {

    textContainerWidth = MediaQuery.of(context).size.width * 0.3;
    container = formContainer(buildContext);
    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }

  formContainer(BuildContext buildContext) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
         widget.photoUrl != null && widget.photoUrl != ""
          ? Container(
           height: 70,
           color: Colors.indigo,
           child: Expanded(
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Container(
                   margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                   height: 45,
                   width: 45,
                   child: CircleAvatar(
                     radius: 40,
                     backgroundImage: NetworkImage(widget.photoUrl),
                   ),
                 ),
                 commonWidgets.getNormalText(widget.title, Colors.white, 1, fontSize),
                 commonWidgets.getIcon(Icons.logout, Colors.white, 30, (){
                   final provider = Provider.of<FirebaseAuthServices>(context,listen: false);
                   provider.Logout();
                   commonWidgets.storeBooleanInSharedPreferences('isRememberLogin', false);
                   commonWidgets.launchPage(context, NewLoginView());
                 }),
               ],
             ),
           ),
         )
          : commonWidgets.commonAppBar(fontSize,widget.title,(){
              final provider = Provider.of<FirebaseAuthServices>(context,listen: false);
              provider.Logout();
            commonWidgets.storeBooleanInSharedPreferences('isRememberLogin', false);
            commonWidgets.launchPage(context, NewLoginView());
          }),
          commonWidgets.getPadding(top: 10),
          formViewPersonDetails(),
          commonWidgets.getPadding(top: 40)
        ],
      ),
    );
  }
  formViewPersonDetails(){
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError){
          return const Text("snapshot error");
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Expanded(
            child: Container(
              alignment: Alignment.topCenter,
              child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
                color: Colors.white,
              ),
            ),
          );
        }
        final data = snapshot.requireData;
        if(data != null) {
          roomId = chatRoomId(widget.title, data.docs[0]['name']);
          isChatClick = true;
          chatTitle = data.docs[0]['name'];
          userId = data.docs[0]['userId'];
          userStatus = data.docs[0]['status'];
        }
        return Expanded(
          child: ListView.builder(
              itemCount: data.docs.length,
              itemBuilder: ( context,index ){
                print("ListId${data.docs[index]}");
                return chatList(data.docs[index]['name'],index, data);
              }),
        );
      },
    );
  }

  Widget chatList(String name, int index,data) {
    return name != widget.title
        ? GestureDetector(
      onTap: () {
        setState(() {
          roomId = chatRoomId(widget.title, name);
          isChatClick = true;
          chatTitle = name;
          userId = data.docs[index]['userId'];
          userStatus = data.docs[index]['status'];
        });
        commonWidgets.launchPage(context, ChatOthers(widget.title,widget.photoUrl,userStatus,data.docs[index]['name'],name,roomId));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey,width: 0.2))),
        child: Row(
          children: [
            data.docs[index]['photoUrl']  != null
            ? Container(
              margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              height: 45,
              width: 45,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(data.docs[index]['photoUrl']),
              ),
            )
            : Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                  color: Colors.orange,
                borderRadius: BorderRadius.circular(50)
              ),
              child: commonWidgets.getNormalTextWithBold(name[0].toUpperCase(), Colors.white, 1, 23),
            ),
            commonWidgets.getPadding(left: 20),
            commonWidgets.getNormalText(name, Colors.black, 1, fontSize)
          ],
        ),
      ),
    ): Container();
  }
}