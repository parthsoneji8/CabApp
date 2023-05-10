import 'package:cabapp/Screen/HomePage.dart';
import 'package:cabapp/Screen/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _email;
  String? _regEmail;
  String? _userEmail;

  Future<void> getEmailFromSharedPref() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    setState(() {
      _email = localData.getString('email');
      _regEmail = localData.getString('regEmail');
      _userEmail = localData.getString('userEmail');
    });
  }

  @override
  void initState() {
    super.initState();
    getEmailFromSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              User? user = snapshot.data;
              if (FirebaseAuth.instance.currentUser == null ||
                  FirebaseAuth.instance.currentUser!.email == null ||
                  FirebaseAuth.instance.currentUser!.email != _regEmail) {
                return const LoginPage();
              }
              else if (_email == _regEmail) {
                return const HomePage();
              } else if (user?.email == _userEmail) {
                return const HomePage();
              }
              else {
                return const LoginPage();
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
