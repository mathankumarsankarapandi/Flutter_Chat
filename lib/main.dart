import 'package:chat/CommonFiiles/CommonWidgets.dart';
import 'package:chat/CommonFiiles/NetWorkView.dart';
import 'package:chat/Services/DefaultFirebaseConfig.dart';
import 'package:chat/Services/FirebaseAuthServices.dart';
import 'package:chat/Views/ChatView.dart';
import 'package:chat/Views/LogInView.dart';
import 'package:chat/Views/SignInView.dart';
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
                return isRememberLogin ? ChatView(name) : LogInView();
              } else {
                return SignInView();
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

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,LogInView());
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
                    child: commonWidgets.passwordTextFieldWithBackground(context, passwordController, "Password", (value) { }, (value) { }, 12,() {})),
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: commonWidgets.getBoxDecorationWithColor(CommonWidgets.boxGrey,CommonWidgets.boxGrey, 10),
                    child: commonWidgets.passwordTextFieldWithBackground(context, confirmPasswordController, "Repeat Password", (value) { }, (value) { }, 12,() {})),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign Up", 20, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor, Colors.white,  () { })),
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

  Future<bool> onWillPop() {
    return CommonWidgets().launchPage(context,LogInView());
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
                    child: commonWidgets.passwordTextFieldWithBackground(context, passwordController, "Password", (value) { }, (value) { }, 12,() {})),

                Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    child: commonWidgets.commonSubmitButton(context, "Sign In", 20, CommonWidgets.appThemeColor, CommonWidgets.appThemeColor, Colors.white,  () { })),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                    child: commonWidgets.getNormalTextWithCenterAlignment("Or", CommonWidgets.appThemeColor, 1, 15, FontWeight.normal)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                       height: 50,
                       decoration: const BoxDecoration(
                       image: DecorationImage(
                       fit: BoxFit.fitWidth,
                       image: AssetImage("assets/googleImage.png"),
                       ),
                      ),
                    ),
                    commonWidgets.getPadding(right: 30,left: 30),
                    Container(
                       width: 50,
                       height: 50,
                       decoration: const BoxDecoration(
                       image: DecorationImage(
                       fit: BoxFit.fitWidth,
                       image: AssetImage("assets/facebook.png"),
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


