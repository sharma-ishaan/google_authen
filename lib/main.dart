import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>[
  'email',
  'https://www.googleapis.com/auth/contacts.readonly'
]);

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Google Authentication',
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  GoogleSignInAccount? _currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((account) {
      setState(() {
        _currentUser = account!;
      });
      if (_currentUser != null) {
        print("user has already authenticated");
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print("Sign In Error$error");
    }
  }

  Future<void> handleSignOut() => _googleSignIn.disconnect();

  // Widget buildBody() {
  //   GoogleSignInAccount user = currentUser;
  Widget buildBody() {
    GoogleSignInAccount? user = _currentUser;
    if (user != null) {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          GoogleUserCircleAvatar(identity: user),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              user.displayName ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              user.email,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Center(
            child: Text(
              'Welcome to My application',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          ElevatedButton(onPressed: handleSignOut, child: Text('Sign Out'))
        ],
      );
    } else {
      return Column(
        children: [
          SizedBox(
            height: 90,
          ),
          Center(
            child: Image.asset(
              "assets/google.png",
              height: 200,
              width: 200,
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Welcome to Google authentication",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              width: 250,
              child: ElevatedButton(
                  onPressed: handleSignIn,
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/google.png",
                          height: 20,
                          width: 20,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('Google Sign In')
                      ],
                    ),
                  )),
            ),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(
        child: buildBody(),
      ),
    );
  }
}
