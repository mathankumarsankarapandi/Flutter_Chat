import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/ChatView.dart';
import 'package:chat/Views/SignInView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class LogInView extends StatefulWidget {
  LogInView();

  @override
  State<StatefulWidget> createState() {
    return LoginViewState();
  }
}

class LoginViewState extends State<LogInView> {
  CommonWidgets commonWidgets = CommonWidgets();
  double fontSize = 15;
  late Widget container;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool isObscurePassword = true;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context, SignInView());
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
    container = formContainer(buildContext);

    return commonWidgets.getWillPopScopeWidget(
        context, onWillPop, container, false, null);
  }

  formContainer(BuildContext buildContext) {
    return Container(
      color: Colors.pinkAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: commonWidgets.getNormalTextWithBold(
                  "LOGIN", Colors.white, 1, 23)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.elliptical(10, 10),
                  bottomLeft: Radius.elliptical(600, 350)),
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                 /* decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),*/
                  child: commonWidgets.emailTextField(
                      buildContext,
                      emailTextEditingController,
                      "Email",
                      (value) {},
                      (value) {},
                      fontSize),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                 /* decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),*/
                  child: commonWidgets.passwordTextField(
                      buildContext,
                      passwordTextEditingController,
                      "Password",
                      (value) {},
                      (value) {},
                      fontSize, () {
                    isObscurePassword = !isObscurePassword;
                    setState(() {});
                  }, isObscure: isObscurePassword),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 50, 5, 5),
                        child: commonWidgets.getNormalTextWithBold(
                            "LOGIN", Colors.pinkAccent, 1, fontSize)),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 50, 20, 5),
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(50)),
                      child: commonWidgets.getIcon(
                          Icons.arrow_right_alt_sharp, Colors.white, 30, () async {
                        final String email = emailTextEditingController.text.trim();
                        final String password =
                        passwordTextEditingController.text.trim();
                        String name = '';
                        String isLogin = '';
                        FirebaseFirestore firestore = FirebaseFirestore.instance;
                        await firestore
                            .collection('users')
                            .where('email',
                            isEqualTo: emailTextEditingController.text)
                            .get()
                            .then((value) {
                          setState(() {
                            name = value.docs[0]['name'];
                          });
                          print("testName$name");
                        });

                        if (email.isNotEmpty && password.isNotEmpty) {
                          isLogin = await context
                              .read<FirebaseAuthServices>()
                              .login(email, password, context);
                          print("Login success fully$isLogin");
                        }
                        if (isLogin == "LogIn") {
                          commonWidgets.storeBooleanInSharedPreferences(
                              'isRememberLogin', true);
                          commonWidgets.storeStringInSharedPreferences('name', name);
                          commonWidgets.launchPage(context, ChatView(name,""));
                        }
                      },),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.elliptical(10, 10),
                        topRight: Radius.elliptical(600, 350)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          margin: const EdgeInsets.fromLTRB(10, 40, 5, 5),
                          child: commonWidgets.getNormalTextWithBold(
                              "Don't have an Account", Colors.black, 1, fontSize)),
                      Container(
                        child: commonWidgets.commonButton(
                            context, "SIGN UP",
                            fontSize, Colors.pinkAccent,
                            Colors.pinkAccent,
                            Colors.white, const EdgeInsets.all(10),
                                () {
                                  commonWidgets.launchPage(context, SignInView());
                                }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
/*
  formContainer(BuildContext buildContext) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          commonWidgets.getNormalText("Login", Colors.white, 1, fontSize),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: commonWidgets.emailTextField(
                buildContext,
                emailTextEditingController,
                "email",
                (value) {},
                (value) {},
                fontSize),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
            child: commonWidgets.passwordTextField(
                buildContext,
                passwordTextEditingController,
                "Password",
                (value) {},
                (value) {},
                fontSize, () {
              isObscurePassword = !isObscurePassword;
              setState(() {});
            }, isObscure: isObscurePassword),
          ),
          GestureDetector(
              onTap: () {
                commonWidgets.launchPage(context, SignInView());
              },
              child: commonWidgets.getNormalText(
                  "New User? Sing Up", Colors.blue, 2, fontSize)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.blue, border: Border.all(color: Colors.blue)),
            child: TextButton(
                onPressed: () async {
                  final String email = emailTextEditingController.text.trim();
                  final String password =
                      passwordTextEditingController.text.trim();
                  String name = '';
                  String isLogin = '';
                  FirebaseFirestore firestore = FirebaseFirestore.instance;
                  await firestore
                      .collection('users')
                      .where('email',
                          isEqualTo: emailTextEditingController.text)
                      .get()
                      .then((value) {
                    setState(() {
                      name = value.docs[0]['name'];
                    });
                    print("testName$name");
                  });

                  if (email.isNotEmpty && password.isNotEmpty) {
                    isLogin = await context
                        .read<FirebaseAuthServices>()
                        .login(email, password, context);
                    print("Login success fully$isLogin");
                  }
                  if (isLogin == "LogIn") {
                    commonWidgets.storeBooleanInSharedPreferences(
                        'isRememberLogin', true);
                    commonWidgets.storeStringInSharedPreferences('name', name);
                    commonWidgets.launchPage(context, ChatView(name));
                  }
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )),
          )
        ],
      ),
    );
  }*/
}
