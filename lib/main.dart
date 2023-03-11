import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/CommonFiiles/NetWorkView.dart';
import 'package:chat/Services/DefaultFirebaseConfig.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/ChatView.dart';
import 'package:chat/Views/LogInView.dart';
import 'package:chat/Views/SignInView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool isRememberLogin = false;
  String name = '';
  Future<bool> isServerAccessible(BuildContext context) async {
    try {


      isRememberLogin = await CommonWidgets()
          .getBooleanFromSharedPreferences('isRememberLogin');
      name = await CommonWidgets().getStringFromSharedPreferences('name');


      if (await NetWorkView().isInternetConnected(context)) {
        return true;
      } else {
        return false;
      }
    } catch (exception) {
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthServices>(
            create: (_) => FirebaseAuthServices(FirebaseAuth.instance)),
        StreamProvider(
            create: (context) => context.read<FirebaseAuthServices>().authStateChanges,
            initialData: null)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: isServerAccessible(context),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text("ConnectionState.none");
          case ConnectionState.waiting:
            return loadingContainer();
          case ConnectionState.active:
            return const Text("ConnectionState.active");
          case ConnectionState.done:
            if (snapshot.hasError) {
              return const Text("ConnectionState.hasError");
            } else if (snapshot.hasData) {
              if (snapshot.data == true) {
                return isRememberLogin ? ChatView(name,"") : NewLoginView();
              } else {
                return NewSignInView();
              }
            }
        }
        return Container();
      },
      ),
      ),
    );
  }

  loadingContainer() {
    return Column(
      children: [
        /*Expanded(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: AssetImage("assets/logoImage.jpg"),
              ),
            ),
          ),
        ),*/
        Expanded(child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            backgroundColor: Colors.pinkAccent,
            color: Colors.white,
          ),
        ))
      ],
    );
  }
}


class NewSignInView extends StatefulWidget {
  const NewSignInView({Key? key}) : super(key: key);

  @override
  State<NewSignInView> createState() => _NewSignInViewState();
}

class _NewSignInViewState extends State<NewSignInView> {

  late Widget container;
  CommonWidgets commonWidgets = CommonWidgets();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;
  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,NewLoginView());
  }

  @override
  Widget build(BuildContext context) {
    container = formContainer(context);

    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }

  Widget formContainer(buildContext) {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    // width: 50,
                    // height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/backgroundImage.png"),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                      color: const Color.fromARGB(100, 22, 44, 33),
                      child: const Text("SIGN IN",
                        style: TextStyle(fontSize: 25, color: Colors.white),),
                    ),
                ],
              )),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                    child: commonWidgets.commonTextInputFieldWithBackground(context, 12, "Name",1,TextInputAction.done, TextInputType.text, nameController, (value) { }, (value) { }, () {})),
                 Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                    child: commonWidgets.emailTextFieldWithBackground(context, emailController, "User Mail", (value) { }, (value) { }, 12)),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey,CommonWidgets.boxGrey, 10),
                    child: commonWidgets.passwordTextFieldWithBackground(context, passwordController, "Password", (value) { }, (value) { }, 12,() {
                      isObscurePassword = !isObscurePassword;
                      setState(() {});
                    }, isObscure: isObscurePassword)),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey,CommonWidgets.boxGrey, 10),
                    child: commonWidgets.passwordTextFieldWithBackground(context, confirmPasswordController, "Repeat Password", (value) { }, (value) { }, 12,() {
                      isObscureConfirmPassword = !isObscureConfirmPassword;
                      setState(() {});
                    }, isObscure: isObscureConfirmPassword)),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign Up", 20, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor, Colors.white,  () async {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();
                      final String confirmPassword = confirmPasswordController.text.trim();
                      final String name = nameController.text.trim();
                      String isSignIn = '';
                      if(email.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
                        isSignIn = await context.read<FirebaseAuthServices>().signIn(email, password, context,name);
                        print("SignIn success fully$isSignIn");
                      }
                      if(isSignIn == "signIn"){
                        commonWidgets.launchPage(context, const NewLoginView());
                      }
                    })),
                commonWidgets.getNormalTextWithCenterAlignment("Or", CommonWidgets.appThemeColor, 1, 15, FontWeight.normal),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign In", 20, Colors.white, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor,  () {
                      commonWidgets.launchPage(context, const NewLoginView());
                    })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class NewLoginView extends StatefulWidget {
  const NewLoginView({Key? key}) : super(key: key);

  @override
  State<NewLoginView> createState() => _NewLoginViewState();
}

class _NewLoginViewState extends State<NewLoginView> {
  late Widget container;
  CommonWidgets commonWidgets = CommonWidgets();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isObscurePassword = true;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,NewSignInView());
  }

  @override
  Widget build(BuildContext context) {
    container = formContainer(context);

    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }

  Widget formContainer(buildContext) {
    return LoginViewWidget();
  }

  Widget LoginViewWidget() {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    // width: 50,
                    // height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/backgroundImage.png"),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: const Color.fromARGB(100, 22, 44, 33),
                    child: const Text("LOG IN",
                        style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                    child: commonWidgets.emailTextFieldWithBackground(context, emailController, "User Mail", (value) { }, (value) { }, 12)),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey,CommonWidgets.boxGrey, 10),
                    child: commonWidgets.passwordTextFieldWithBackground(context, passwordController, "Password", (value) { }, (value) { }, 12,() {
                      isObscurePassword = !isObscurePassword;
                      setState(() {});
                    }, isObscure: isObscurePassword)),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign In", 20, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor, Colors.white,  () async {
                      final String email = emailController.text.trim();
                      final String password = passwordController.text.trim();
                      String name = '';
                      String isLogin = '';
                      FirebaseFirestore firestore = FirebaseFirestore.instance;
                      await firestore
                          .collection('users')
                          .where('email',
                          isEqualTo: emailController.text)
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
                    })),
                Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: commonWidgets.getNormalTextWithCenterAlignment("Or", CommonWidgets.appThemeColor, 1, 15, FontWeight.normal)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                       String signIn = '';
                       signIn = await context.read<FirebaseAuthServices>().googleLogIn();
                       final user = FirebaseAuth.instance.currentUser;
                       if(signIn == "Sign"){
                         commonWidgets.storeBooleanInSharedPreferences(
                             'isRememberLogin', true);
                         commonWidgets.launchPage(context, ChatView(user!.displayName!,user.photoURL!));
                       }
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage("assets/googleImage.png"),
                          ),
                        ),
                      ),
                    ),
                    commonWidgets.getPadding(right: 30,left: 30),
                    GestureDetector(
                      onTap: () {
                        commonWidgets.launchPage(context, PhoneNumberAuthentication());
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            image: AssetImage("assets/facebook.png"),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign Up", 20, Colors.white, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor,  () {
                      commonWidgets.launchPage(context, const NewSignInView());
                    })),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberAuthentication extends StatefulWidget {
  const PhoneNumberAuthentication({Key? key}) : super(key: key);

  @override
  State<PhoneNumberAuthentication> createState() => _PhoneNumberAuthenticationState();
}

class _PhoneNumberAuthenticationState extends State<PhoneNumberAuthentication> {
  late Widget container;
  CommonWidgets commonWidgets = CommonWidgets();
  TextEditingController nameTextEditController = TextEditingController();
  TextEditingController phoneNumberTextEditController = TextEditingController();
  TextEditingController OTPTextEditController = TextEditingController();
  String verifivationId = "";
  bool isVerified = false;
  FirebaseAuth auth =  FirebaseAuth.instance;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,NewSignInView());
  }
  @override
  Widget build(BuildContext context) {
    container = formContainer(context);

    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }

  formContainer(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    // width: 50,
                    // height: 50,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: AssetImage("assets/backgroundImage.png"),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    color: const Color.fromARGB(100, 22, 44, 33),
                    child: const Text("LOG IN",
                        style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ],
              )),
          Expanded(
            flex: 4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: !isVerified,
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                      child: commonWidgets.commonTextInputFieldWithBackground(context, 12, "Phone Number",1,TextInputAction.done, TextInputType.phone, phoneNumberTextEditController, (value) { }, (value) { }, () {})),
                ),
                Visibility(
                visible: isVerified,
                child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                      child: commonWidgets.emailTextFieldWithBackground(context, OTPTextEditController, "OTP", (value) { }, (value) { }, 12)),
              ),
                Visibility(
                  visible: true,
                  child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey, CommonWidgets.boxGrey, 10),
                      child: commonWidgets.commonTextInputFieldWithBackground(context, 12, "Name",1,TextInputAction.done, TextInputType.text, nameTextEditController, (value) { }, (value) { }, () {})),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, isVerified ? "Sign In" : "Send OTP", 20, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor, Colors.white, () async {
                     if(!isVerified) {
                       verifyNumber(phoneNumberTextEditController.text.toString());
                     } else {
                       String name, otp;
                       name = nameTextEditController.text.trim();
                       otp = OTPTextEditController.text.trim();
                       // if(name.isNotEmpty && otp.isNotEmpty){
                         String signIn = await VerifyCode(name, otp, verifivationId);
                          final user = FirebaseAuth.instance.currentUser;
                          print("objectobject$signIn");
                          if(signIn == "Sign"){
                            commonWidgets.storeBooleanInSharedPreferences(
                                'isRememberLogin', true);
                            commonWidgets.launchPage(context, ChatView(user!.displayName!,user.photoURL!));
                          }
                       // }

                     }
                    })),
                Visibility(
                  visible: false,
                  child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      child: commonWidgets.getNormalTextWithCenterAlignment("Or", CommonWidgets.appThemeColor, 1, 15, FontWeight.normal)),
                ),
                Visibility(
                  visible: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          String signIn = '';
                          signIn = await context.read<FirebaseAuthServices>().googleLogIn();
                          final user = FirebaseAuth.instance.currentUser;
                          if(signIn == "Sign"){
                            commonWidgets.storeBooleanInSharedPreferences(
                                'isRememberLogin', true);
                            commonWidgets.launchPage(context, ChatView(user!.displayName!,user.photoURL!));
                          }
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/googleImage.png"),
                            ),
                          ),
                        ),
                      ),
                      commonWidgets.getPadding(right: 30,left: 30),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: AssetImage("assets/facebook.png"),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign Up", 20, Colors.white, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor,  () {
                      commonWidgets.launchPage(context, const NewSignInView());
                    })),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Future<String> VerifyCode(String name, String otp, String verficationID) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verficationID, smsCode: otp);
    final authResult = await auth.signInWithCredential(credential);
    if (authResult.user != null) {
      await firebaseFirestore.collection('users').doc(auth.currentUser!.uid).set(
          {
            'name': "nathan madhavan",
            'email': "UnAvailable",
            'followStatus': "follow",
            'status': "UnAvailable",
            'userId': authResult.user!.uid,
            'photoUrl': authResult.user!.photoURL
          });
      return "signIn";
    };
    return "wrong user";
  }

   verifyNumber(String phoneNumber) async {
     await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) =>
          {

          });
        },
        verificationFailed: ( FirebaseAuthException exception) {

        },
        codeSent: (String verificationId, int? resentToken){
          verifivationId = verificationId;
          isVerified = true;
          setState(() {

          });
        },
        codeAutoRetrievalTimeout: ( String verificationId) {

        });
  }
}


class SiginInUserView extends StatefulWidget {
  const SiginInUserView({Key? key}) : super(key: key);

  @override
  State<SiginInUserView> createState() => _SiginInUserViewState();
}

class _SiginInUserViewState extends State<SiginInUserView> {
  late Widget container;
  CommonWidgets commonWidgets = CommonWidgets();
  final user = FirebaseAuth.instance.currentUser;

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,NewLoginView());
  }
  @override
  Widget build(BuildContext context) {
    container = formContainer(context);
    return commonWidgets.getWillPopScopeWidget(context,onWillPop,container,false,null);
  }

  Widget formContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        commonWidgets.commonAppBar(15,user!.displayName!,() {
          final provider = Provider.of<FirebaseAuthServices>(context,listen: false);
          provider.Logout();
          commonWidgets.launchPage(context, NewLoginView());
        }),
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(user!.photoURL!),
        ),
        commonWidgets.getNormalTextWithCenterAlignment(user!.displayName!, Colors.black, 1, 20, FontWeight.bold)
      ],
    );
  }


}



