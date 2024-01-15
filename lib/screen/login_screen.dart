import 'package:flutter/material.dart';
import 'package:reagen_farm/provider/auth_provider.dart';
import 'package:reagen_farm/widget/imgpick/imgpick_widget.dart';
import 'package:reagen_farm/widget/textfield/textfield_email_widget.dart';
import 'package:reagen_farm/widget/textfield/textfield_pass_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var loadAuth = Provider.of<AuthProvider>(context);
    return Container(
      color: const Color.fromARGB(255, 29, 29, 29),
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              
              
              
              Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loadAuth.islogin ? "Login" : "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.fontSize),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.deepOrange,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 3))
                          ]),
                      child: Form(
                        key: loadAuth.form,
                        child: Column(
                          children: [
                            if (!loadAuth.islogin) ImagePickWidget(),
                            TextfieldEmailWidget(controller: email),
                            const SizedBox(
                              height: 15,
                            ),
                            TextfieldPasswordWidget(controller: password),
                            const SizedBox(
                              height: 30,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  onPressed: () {
                                    loadAuth.submit();
                                  },
                                  child: Text(
                                      loadAuth.islogin ? "Login" : "Register")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    loadAuth.islogin = !loadAuth.islogin;
                                  });
                                },
                                child: Text(loadAuth.islogin
                                    ? "Create account"
                                    : "I already have account"))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
