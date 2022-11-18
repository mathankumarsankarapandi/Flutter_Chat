import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/Views/ChatView.dart';
import 'package:chat/Views/LogInView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ChatOthers extends StatefulWidget {
  String title;
  String userStatus;
  String userName;
  String userTitle;
  String roomId;
  ChatOthers(this.title,this.userStatus,this.userName,this.userTitle,this.roomId);

  @override
  State<StatefulWidget> createState() {
    return ChatViewState();
  }
}

class ChatViewState extends State<ChatOthers> {



  CommonWidgets commonWidgets = CommonWidgets();
  double fontSize = 15;
  late Widget container;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isObscurePassword = true;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  double textContainerWidth = 0;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,ChatView(widget.title));
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
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
          commonWidgets.commonAppBar(fontSize,widget.userTitle,(){
            commonWidgets.storeBooleanInSharedPreferences('isRememberLogin', false);
            commonWidgets.launchPage(context, LogInView());
          }),
          commonWidgets.getPadding(top: 10),
          /*    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:1,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(20,10,10,10),
                            decoration: BoxDecoration(color: Colors.greenAccent,
                                border: Border.all(color: Colors.green,width: 5),
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                commonWidgets.getNormalTextWithBold(widget.title, Colors.green, 4, fontSize),
                                commonWidgets.getNormalText(widget.userStatus, Colors.green, 1, fontSize)
                              ],
                            )),
                      ),
                    ],
                  ),*/
          Expanded(
              child: Container(
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.transparent,
                    border: Border.all(color: Colors.black,width: 1),
                    borderRadius: BorderRadius.circular(20)),
                child:  formChatView(),
              )),
          Row(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10,0,5,10),
                decoration: const BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.all(Radius.circular(50)),),
                child: IconButton(
                  icon: const Icon(Icons.camera_alt_rounded,color: Colors.white),
                  onPressed: () {

                  },
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0,0,0,10),
                  decoration: BoxDecoration(color: Colors.white,
                      border: Border.all(color: Colors.black,width: 1),
                      borderRadius: BorderRadius.circular(30)),
                  child: commonWidgets.commonTextInputFieldWithSuffixIcon(
                      context, fontSize,
                      "Enter Message...", 1,
                       passwordTextEditingController,
                          (value) { }, (value) { }, () { },() async{
                    if(passwordTextEditingController.text.isNotEmpty) {
                      Map<String, dynamic> message = {
                        'sendby': widget.userName,
                        'message': passwordTextEditingController.text,
                        'time': FieldValue.serverTimestamp(),
                        'receivedby': widget.userTitle,
                      };
                      await firebaseFirestore.collection('chatroom').
                      doc(widget.roomId).collection('chats').add(message);
                    }
                    passwordTextEditingController.clear();
                  }),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.fromLTRB(5,0,10,10),
                decoration: const BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.all(Radius.circular(50)),),
                child: IconButton(
                  icon: const Icon(Icons.send,color: Colors.white),
                  onPressed: () async{
                    if(passwordTextEditingController.text.isNotEmpty) {
                      Map<String, dynamic> message = {
                        'sendby': widget.userName,
                        'message': passwordTextEditingController.text,
                        'time': FieldValue.serverTimestamp(),
                        'receivedby': widget.userTitle,
                      };
                      await firebaseFirestore.collection('chatroom').
                      doc(widget.roomId).collection('chats').add(message);
                    }
                    passwordTextEditingController.clear();
                  },
                ),
              ),
            ],
          ),
          commonWidgets.getPadding(bottom: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
  formChatView(){
    return  StreamBuilder<QuerySnapshot>(
        stream: firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').orderBy('time', descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.data != null){
            return Expanded(
              child: ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: snapshot.data!.docs[index]['receivedby'] == widget.userTitle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(80, 5, 5, 5),
                                    padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                    decoration: BoxDecoration(color: Colors.orange,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Expanded(child: commonWidgets.getNormalText(snapshot.data!.docs[index]['message'], Colors.white, 4, fontSize),)),
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: commonWidgets.getNormalTextWithBold(widget.title[0].toUpperCase(), Colors.white, 1, fontSize),
                              ),
                              commonWidgets.getPadding(right: 15)
                            ],
                          ),
                        ),
                        Visibility(
                          visible: snapshot.data!.docs[index]['receivedby'] != widget.userTitle,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonWidgets.getPadding(left: 10),
                              Container(
                                alignment: Alignment.center,
                                margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                    color: Colors.pinkAccent,
                                    borderRadius: BorderRadius.circular(50)
                                ),
                                child: commonWidgets.getNormalTextWithBold(widget.userTitle[0].toUpperCase(), Colors.white, 1, fontSize),
                              ),
                              Expanded(
                                child: Container(
                                    margin: const EdgeInsets.fromLTRB(5, 5, 80, 5),
                                    padding: const EdgeInsets.fromLTRB(10, 7, 10,7),
                                    decoration: BoxDecoration(color: Colors.amber,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Expanded(child: commonWidgets.getNormalText(snapshot.data!.docs[index]['message'], Colors.white, 4, fontSize))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
            );
          }
          else {
            return Container();
          }
        });
  }
}