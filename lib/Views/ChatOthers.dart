import 'dart:io';

import 'package:chat/CommonFiles/CommonWidgets.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/ChatView.dart';
import 'package:chat/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';


class ChatOthers extends StatefulWidget {
  String title;
  String photoUrl;
  String userStatus;
  String userName;
  String userTitle;
  String roomId;
  String userPhotoUrl;
  ChatOthers(this.title,this.photoUrl,this.userStatus,this.userName,this.userTitle,this.roomId,this.userPhotoUrl, {Key? key}) : super(key: key);

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
  TextEditingController addCaptionTextEditingController = TextEditingController();
  bool isObscurePassword = true;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  double textContainerWidth = 0;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context, ChatView(widget.title, widget.photoUrl));
  }

  showDialog_(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CommonWidgets().commonDialog(
            context,
            fontSize,
            24,
            24,
            "Logout Alert",
            Colors.red,
            Column(
              children: [
                commonWidgets.getNormalText("Do you want logout the user", CommonWidgets.appThemeColor, 1, fontSize),
                Row(
                  children: [
                    Expanded(
                        child:  Container(
                          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                          decoration: BoxDecoration(color:  CommonWidgets.appThemeColor, borderRadius: BorderRadius.circular(10)),
                          child: TextButton(
                              onPressed: () {
                                final provider = Provider.of<FirebaseAuthServices>(context,listen: false);
                                provider.logout();
                                commonWidgets.storeBooleanInSharedPreferences('isRememberLogin', false);
                                commonWidgets.launchPage(context, const NewLoginView());
                              }, child: commonWidgets.getNormalTextWithBold("OK",Colors.white , 1, fontSize)),
                        )),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(color:  CommonWidgets.appThemeColor, borderRadius: BorderRadius.circular(10)),
                        child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            }, child: commonWidgets.getNormalTextWithBold("Cancel",Colors.white , 1, fontSize)),
                      ),
                    ),
                  ],
                )
              ],
            ), () { });
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
          widget.userPhotoUrl != ""
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
                      backgroundImage: NetworkImage(widget.userPhotoUrl),
                    ),
                  ),
                  commonWidgets.getNormalText(widget.title, Colors.white, 1, fontSize),
                  commonWidgets.getIcon(Icons.logout, Colors.white, 30, (){
                    showDialog_(context);
                  }),
                ],
              ),
            ),
          )
              : commonWidgets.commonAppBar(fontSize,widget.title,(){
            showDialog_(context);
          }),
          commonWidgets.getPadding(top: 10),
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
                    getImageFromImagePicker();
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
                        'type':"message",
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
                        'type': "message",
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


  Future<String> getImageFromImagePicker() async {
    try {
      XFile? image = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);
      String? pickedFilepath;
      if (image != null) {
        pickedFilepath = image.path;
      }
      showDialogImage_(context, pickedFilepath!);
      return (pickedFilepath ?? "");
    } catch (error) {
      return '';
    }
  }
  showDialogImage_(BuildContext context, String? pickedFilepath) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CommonWidgets().commonDialog(
            context,
            fontSize,
            24,
            24,
            "Attached Image",
            Colors.red,
            setImageView(pickedFilepath), () { });
      },
    );
  }

  Widget setImageView(String? pickedFilepath){
    return Column(
      children: [
        Image(
          image: FileImage(
              File(pickedFilepath!)),
          fit: BoxFit.fitHeight,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(0,10,0,0),
                decoration: BoxDecoration(color: Colors.white,
                    border: Border.all(color: Colors.black,width: 1),
                    borderRadius: BorderRadius.circular(30)),
                child: commonWidgets.commonTextInputFieldWithSuffixIcon(
                    context, fontSize,
                    "Add Caption...", 1,
                    addCaptionTextEditingController,
                        (value) { }, (value) { }, () { },() async{
                  var ref = FirebaseStorage.instance.ref().child("image").child("$pickedFilepath.jpg");
                  var upload = await ref.putFile(File(pickedFilepath)).catchError((error) async {
                    await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').doc(pickedFilepath).delete();
                  });
                  String imageUrl = await upload.ref.getDownloadURL();
                  Map<String, dynamic> message = {
                    'sendby': widget.userName,
                    'message': imageUrl,
                    'type': "image",
                    'time': FieldValue.serverTimestamp(),
                    'receivedby': widget.userTitle,
                  };
                  await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').doc(pickedFilepath).set(message);
                  if(addCaptionTextEditingController.text.isNotEmpty){
                    Map<String, dynamic> message1 = {
                      'sendby': widget.userName,
                      'message': addCaptionTextEditingController.text,
                      'type': "message",
                      'time': FieldValue.serverTimestamp(),
                      'receivedby': widget.userTitle,
                    };
                    await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').add(message1);
                  }
                  Navigator.pop(context);

                }),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.fromLTRB(5,10,0,0),
              decoration: const BoxDecoration(color: Colors.pinkAccent, borderRadius: BorderRadius.all(Radius.circular(50)),),
              child: IconButton(
                icon: const Icon(Icons.send,color: Colors.white),
                onPressed: () async {
                  var ref = FirebaseStorage.instance.ref().child("image").child("$pickedFilepath.png");
                  var upload = await ref.putFile(File(pickedFilepath));/*.catchError((error) async {
                    await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').doc(pickedFilepath).delete();
                  });*/
                  String imageUrl = await upload.ref.getDownloadURL();
                  Map<String, dynamic> message = {
                    'sendby': widget.userName,
                    'message': imageUrl,
                    'type': "image",
                    'time': FieldValue.serverTimestamp(),
                    'receivedby': widget.userTitle,
                  };
                  await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').add(message);
                  if(addCaptionTextEditingController.text.isNotEmpty){
                    Map<String, dynamic> message1 = {
                      'sendby': widget.userName,
                      'message': addCaptionTextEditingController.text,
                      'type': "message",
                      'time': FieldValue.serverTimestamp(),
                      'receivedby': widget.userTitle,
                    };
                    await firebaseFirestore.collection('chatroom').doc(widget.roomId).collection('chats').add(message1);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        )
      ],
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
                                child: Visibility(
                                  visible: snapshot.data!.docs[index]['type'] == "message",
                                  replacement: Padding(
                                    padding: const EdgeInsets.fromLTRB(80, 0, 0,0),
                                    child: Image.network(snapshot.data!.docs[index]['message']),
                                  ),
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(80, 5, 5, 5),
                                      padding: const EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                      decoration: BoxDecoration(color: Colors.orange,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Expanded(child: commonWidgets.getNormalText(snapshot.data!.docs[index]['message'], Colors.white, 4, fontSize),)),
                                ),
                              ),
                              widget.photoUrl != ""
                              ? Container(
                                margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                height: 30,
                                width: 30,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(widget.photoUrl),
                                ),
                              )
                              : Container(
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
                              widget.userPhotoUrl != ""
                              ? Container(
                                 margin: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                height: 30,
                                width: 30,
                                 child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(widget.userPhotoUrl),
                                ),
                               )
                              : Container(
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
                                child: Visibility(
                                  visible: snapshot.data!.docs[index]['type'] == "message",
                                  replacement: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 80,0),
                                      child: Image.network(snapshot.data!.docs[index]['message'])),
                                  child: Container(
                                      margin: const EdgeInsets.fromLTRB(5, 5, 80, 5),
                                      padding: const EdgeInsets.fromLTRB(10, 7, 10,7),
                                      decoration: BoxDecoration(color: Colors.amber,
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Expanded(child: commonWidgets.getNormalText(snapshot.data!.docs[index]['message'], Colors.white, 4, fontSize))),
                                ),
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