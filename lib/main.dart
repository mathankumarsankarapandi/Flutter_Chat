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

