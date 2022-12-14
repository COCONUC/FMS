import 'package:FMS/constants/color_constant.dart';
import 'package:FMS/features/auth_services.dart';
import 'package:FMS/screens/widgets/custom_button.dart';
import 'package:FMS/screens/widgets/custom_text_field.dart';
//import 'package:FMS/screens/widgets/otp_vertify_screen.dart';
import 'package:flutter/material.dart';

enum Auth {
  signin,
  signup,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signin;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  String resultText = "";
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
    passwordController.dispose();
  }


  void signUpUser() {
    authService.signUpUser(
      context: context,
      username: phoneController.text,
      password: passwordController.text,
    );
  }

  void signInUser() {
    authService.signInUser(
      context: context,
      username: phoneController.text,
      password: passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [Image.asset('assets/images/FMS_logo.png',color: mBackgroundColor.withOpacity(0.8), colorBlendMode: BlendMode.modulate,)]),
                ListTile(
                  tileColor: _auth == Auth.signin ? mBackgroundColor : mGreyColor,
                  title: const Text(
                    '????ng nh???p',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Radio(
                    activeColor: mSecondaryColor,
                    value: Auth.signin,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signin)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: mBackgroundColor,
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: phoneController,
                            hintText: 'S??? ??i???n tho???i',
                            secure: false,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'M???t kh???u',
                            secure: true,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                            text: '????ng nh???p',
                            color: themeColor,
                            onTap: () {
                              if (_signInFormKey.currentState!.validate()) {
                                signInUser();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signup ? mBackgroundColor : mGreyColor,
                  title: const Text(
                    'T???o t??i kho???n',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Radio(
                    activeColor: mSecondaryColor,
                    value: Auth.signup,
                    groupValue: _auth,
                    onChanged: (Auth? val) {
                      setState(() {
                        _auth = val!;
                      });
                    },
                  ),
                ),
                if (_auth == Auth.signup)
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: mBackgroundColor,
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: phoneController,
                            hintText: 'S??? ??i???n tho???i',
                            secure: false,
                          ),
                          const SizedBox(height: 10),
                          CustomTextField(
                            controller: passwordController,
                            hintText: 'M???t kh???u',
                            secure: true,
                          ),

                          const SizedBox(height: 10),
                          CustomButton(
                            text: '????ng k?? t??i kho???n',
                            color: themeColor,
                            onTap: () {
                              if (_signUpFormKey.currentState!.validate()) {
                                signUpUser();
                                //Navigator.of(context).push(MaterialPageRoute(
                                    //builder: (context) => OTPScreen(phone: phoneController.text, password: passwordController.text,)));
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
