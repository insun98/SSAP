//로그인 페이지

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_sign_in/google_sign_in.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  //구글 로그인 프로세스
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  final formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String userId = '';
  String password = '';
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: formkey,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 70),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontFamily: 'Yrsa',
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Email";
                                }
                                return null;
                              },
                              textAlign: TextAlign.left,
                              decoration:
                                  const InputDecoration(hintText: 'Email'),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter Password";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                              },
                              textAlign: TextAlign.left,
                              decoration:
                                  const InputDecoration(hintText: 'Password'),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              child: const Text('Confirm'),
                              style: ElevatedButton.styleFrom(
                                primary: const Color(
                                    0xFFB9C98C), // set the background color

                                minimumSize: const Size(300, 35),
                              ),
                              onPressed: () async {
                                if (formkey.currentState!.validate()) {
                                  setState(() {
                                    isloading = true;
                                  });
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);

                                    await Navigator.pushNamed(context, '/home');

                                    setState(() {
                                      isloading = false;
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Login Failed"),
                                        content: Text('${e.message}'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                            },
                                            child: const Text('Okay'),
                                          )
                                        ],
                                      ),
                                    );
                                    print(e);
                                  }
                                  setState(() {
                                    isloading = false;
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 30),
                            GestureDetector(
                              onTap: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (context) => SignupScreen(),
                                //   ),
                                // );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:  [
                                  Text(
                                    "Don't have an Account ?",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                  SizedBox(width: 10),
                                  Hero(
                                    tag: '1',
                                    child: TextButton(
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/signup');
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      primary: Colors.red,
                                      //primary: Colors.red.withOpacity(0.3),
                                    ),
                                    onPressed:
                                        signInWithGoogle, //버튼을 누르면 구글 signin 실행
                                    child: const Text("Google Login"),
                                  ),
                                ]),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// class LoginWidget extends StatelessWidget {
//   const LoginWidget({Key? key}) : super(key: key);
//
//   //구글 로그인 프로세스
//   Future<UserCredential> signInWithGoogle() async {
//     // Trigger the authentication flow
//     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//
//     // Obtain the auth details from the request
//     final GoogleSignInAuthentication? googleAuth =
//         await googleUser?.authentication;
//
//     // Create a new credential
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth?.accessToken,
//       idToken: googleAuth?.idToken,
//     );
//
//     // Once signed in, return the UserCredential
//     return await FirebaseAuth.instance.signInWithCredential(credential);
//   }
//
//   void _signUp() async {
//     //await이니까 async로
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//         email: "eunho111@naver.com",
//         password: "1234",
//       );
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'weak-password') {
//         print('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         print('The account already exists for that email.');
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void _signIn() async {
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: "eunho111@naver.com", password: "1234");
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'user-not-found') {
//         print('No user found for that email.');
//       } else if (e.code == 'wrong-password') {
//         print('Wrong password provided for that user.');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("회원 로그인 "),
//         ),
//         body: Center(
//           child: Column(
//             //버튼 나열하기
//             mainAxisAlignment: MainAxisAlignment.center, //로그인 버튼을 중앙정렬로
//             children: [
//               ElevatedButton(
//                   onPressed: _signUp, //_signUp 이벤트로 처리하기
//                   child: Text("회원가입")),
//               ElevatedButton(onPressed: _signIn, child: Text("로그인")),
//               TextButton(
//                 style: TextButton.styleFrom(
//                   primary: Colors.red,
//                   //primary: Colors.red.withOpacity(0.3),
//                 ),
//                 onPressed: signInWithGoogle, //버튼을 누르면 구글 signin 실행
//                 child: Text("Google Login"),
//               ),
//             ],
//           ),
//         )); //로그인을 구현하기
//   }
// }
