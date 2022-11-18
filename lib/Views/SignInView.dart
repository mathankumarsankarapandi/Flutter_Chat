import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/LogInView.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
class SignInView extends StatefulWidget {
  SignInView();

  @override
  State<StatefulWidget> createState() {
    return SignInViewState();
  }
}

class SignInViewState extends State<SignInView> {
  CommonWidgets commonWidgets = CommonWidgets();
  double fontSize = 15;
  late Widget container;
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController = TextEditingController();
  TextEditingController nameTextEditingController = TextEditingController();
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,LogInView());
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

    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }
  formContainer(BuildContext buildContext) {
    return Container(
      color: Colors.pinkAccent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: commonWidgets.getNormalTextWithBold(
                  "SIGN UP", Colors.white, 1, 23)),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height * 0.6,
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
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                 /* decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),*/
                  child: commonWidgets.commonTextInputField(buildContext,fontSize,"User Name",1,
                      TextInputAction.done,TextInputType.text,
                      nameTextEditingController,  (value) { }, (value) { }, () { }),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                 /* decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),*/
                  child: commonWidgets.emailTextField(buildContext, emailTextEditingController,
                      "Email", (value) { }, (value) { }, fontSize),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  /*decoration: const BoxDecoration(
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
                Container(
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  /*decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),*/
                  child:commonWidgets.passwordTextField(
                      buildContext,
                      confirmPasswordTextEditingController,
                      "Confirm Password",
                          (value) { },
                          (value) { },
                      fontSize,
                          () {
                        isObscureConfirmPassword = !isObscureConfirmPassword;
                        setState(() {

                        });
                      },
                      isObscure: isObscureConfirmPassword),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.fromLTRB(10, 50, 5, 5),
                        child: commonWidgets.getNormalTextWithBold(
                            "SIGN UP", Colors.pinkAccent, 1, fontSize)),
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
                        final String password = passwordTextEditingController.text.trim();
                        final String confirmPassword = passwordTextEditingController.text.trim();
                        final String name = nameTextEditingController.text.trim();
                        String isSignIn = '';
                        if(email.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
                          isSignIn = await context.read<FirebaseAuthServices>().signIn(email, password, context,name);
                          print("SignIn success fully$isSignIn");
                        }
                        if(isSignIn == "signIn"){
                          commonWidgets.launchPage(context, LogInView());
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
                  height: MediaQuery.of(context).size.height * 0.25,
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
                              "Already In User", Colors.black, 1, fontSize)),
                      Container(
                        child: commonWidgets.commonButton(
                            context, "LOGIN",
                            fontSize, Colors.pinkAccent,
                            Colors.pinkAccent,
                            Colors.white, const EdgeInsets.all(10),
                                () {
                              commonWidgets.launchPage(context, LogInView());
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

  /*formContainer(BuildContext buildContext) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          commonWidgets.getNormalText("Sign In", Colors.white, 1, fontSize),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue)
            ),
            child: commonWidgets.emailTextField(buildContext, emailTextEditingController,
             "email", (value) { }, (value) { }, fontSize),
          ),  Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue)
            ),
            child:commonWidgets.commonTextInputField(buildContext,fontSize,"user name",1,
            TextInputAction.done,TextInputType.text,
            nameTextEditingController,  (value) { }, (value) { }, () { }),
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue)
            ),
            child:commonWidgets.passwordTextField(
                buildContext,
                passwordTextEditingController,
                "password",
                    (value) { },
                    (value) { },
                fontSize,
                    () {
                  isObscurePassword = !isObscurePassword;
                  setState(() {

                  });
                },isObscure: isObscurePassword),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue)
            ),
            child: commonWidgets.passwordTextField(
                buildContext,
                confirmPasswordTextEditingController,
                "confirm password",
                    (value) { },
                    (value) { },
                fontSize,
                    () {
                  isObscureConfirmPassword = !isObscureConfirmPassword;
                  setState(() {

                  });
                },
                isObscure: isObscureConfirmPassword),
          ),

          GestureDetector(
              onTap: () {
                commonWidgets.launchPage(context, LogInView());
              },
              child: commonWidgets.getNormalText("Already In user? Login", Colors.blue, 2, fontSize)),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            decoration: BoxDecoration(
                color: Colors.blue,
                border: Border.all(color: Colors.blue)
            ),
            child: TextButton(
                onPressed: () async {
                  final String email = emailTextEditingController.text.trim();
                  final String password = passwordTextEditingController.text.trim();
                  final String name = nameTextEditingController.text.trim();
                  String isSignIn = '';
                  if(email.isNotEmpty && password.isNotEmpty) {
                    isSignIn = await context.read<FirebaseAuthServices>().signIn(email, password, context,name);
                    print("SignIn success fully$isSignIn");
                  }
                  if(isSignIn == "signIn"){
                    commonWidgets.launchPage(context, LogInView());
                  }
                },
                child: const Text("Sign In",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)),
          )
        ],
      ),
    );
  }*/
}