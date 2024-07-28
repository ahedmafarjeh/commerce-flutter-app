import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/shared/colors.dart';
import 'package:flutter_application_1/shared/constants.dart';
import 'package:flutter_application_1/shared/snackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();

  bool isLoading = false;

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login())
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR! ${e.code}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        backgroundColor: appbarGreen,
        title: const Text(
          "Reset Password",
          style: TextStyle(fontSize: 23, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(33.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Enter your email to reset your password",
                style: TextStyle(fontSize: 19),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  // value: it is the input text value
                  return value!.contains(RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
                      ? null
                      : "Enter a valid email";
                },
                // to check/validate the input automaticlly
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: email,
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                decoration: myTextFieldDecoration.copyWith(
                    suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email),
                )),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () async {
                  // send user data to firebase just if the inputs (email & pass)
                  // is valid
                  if (_formKey.currentState!.validate()) {
                    resetPassword();
                  } else {
                    showSnackBar(context, "ERROR! the input is invalid");
                  }
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(BTNgreen),
                  padding: WidgetStateProperty.all(const EdgeInsets.all(12)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        "Reset Password",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
