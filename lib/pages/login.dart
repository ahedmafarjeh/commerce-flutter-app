import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/reset_password.dart';
import 'package:flutter_application_1/provider/google_signin.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/snackbar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isVisible = false;
  bool isLoading = false;
  sigunIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      //showSnackBar(context, "Done");
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR! ${e.code}");
    }
    setState(() {
      isLoading = false;
    });
  }

  // must use statefull to use dispose()
  @override
  void dispose() {
    // TODO: implement dispose
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignInProvider = Provider.of<GoogleSignInProvider>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: appbarGreen,
          title: const Text(
            "Sign in",
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: [
              
              const SizedBox(
                height: 60,
              ),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: myTextFieldDecoration.copyWith(
                    suffixIcon: const Icon(Icons.email)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: password,
                keyboardType: TextInputType.text,
                obscureText: isVisible ? false : true,
                // copyWith: used to use the same code (copy) with
                // capability to change specific attribute
                decoration: myTextFieldDecoration.copyWith(
                  hintText: "Enter Your Password: ",
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off)),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  await sigunIn();
                  if (!mounted) return;
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(BTNgreen),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(12)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ResetPassword()));
                  },
                  child: const Text("Forget password ?",
                      style: TextStyle(
                        fontSize: 20,
                        decoration: TextDecoration.underline,
                      ))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 22),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Register()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 20, decoration: TextDecoration.underline),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              SizedBox(
                width: 299,
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                      color: Colors.red,
                    )),
                    Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.6,
                      color: Colors.red,
                    )),
                  ],
                ),
              ),
              SizedBox(height: 18,),
              Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.red, width: 1)),
                child: GestureDetector(
                  onTap: () {
                    googleSignInProvider.googlelogin();
                  },
                  child: SvgPicture.asset(
                    "assets/icons/googlesvg.svg",
                    height: 27,
                  ),
                ),
              )
            ]),
          ),
        )));
  }
}
