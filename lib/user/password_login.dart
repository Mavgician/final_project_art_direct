import 'package:final_project_art_direct/miscellaneous/auth_service.dart';
import 'package:final_project_art_direct/miscellaneous/helper_widgets.dart';
import 'package:final_project_art_direct/miscellaneous/themes.dart';
import 'package:flutter/material.dart';

import 'package:final_project_art_direct/miscellaneous/buttons.dart';

class PasswordLogin extends StatefulWidget {
  const PasswordLogin({
    super.key,
    required this.loginData,
    required this.loginType,
    this.navigatedFrom = false,
  });

  final String loginData, loginType;
  final bool navigatedFrom;

  @override
  State<PasswordLogin> createState() => _PasswordLoginState();
}

class _PasswordLoginState extends State<PasswordLogin> {

  final _formKey = GlobalKey<FormState>();
  String _login = '', _password = '';
  int? _signInState;

  bool _isPassVisible = true;

  @override
  void initState() {
    super.initState();
    _login = widget.loginData;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: loginTheme,
      home: Scaffold(
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    const Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 32),
                    ),
                    addVerticalSpace(10),
                    const Text(
                      'Login to your ArtDirect account to browse and appreciate art.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white,)
                    ),
                    addVerticalSpace(40),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _login,
                            decoration: InputDecoration( labelText: widget.loginType, ),
                            style: const TextStyle( color: Colors.white ),
                            /* enabled: false, */
                            onChanged: (value) {
                              setState(() {
                                _login = value;
                              });
                            },
                            validator: (value) {
                              if (_signInState == 0 || _signInState == 2) {
                                return 'Invalid email!';
                              } else {
                                return null;
                              }
                            },
                          ),
                          addVerticalSpace(20),
                          TextFormField(
                            obscureText: _isPassVisible,
                            decoration: InputDecoration( 
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  !_isPassVisible ?
                                    Icons.visibility :
                                    Icons.visibility_off
                                  ,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPassVisible = !_isPassVisible;
                                  });
                                },
                              )
                            ),
                            style: const TextStyle( color: Colors.white ),
                            onChanged: (value) {
                              setState(() { _password = value; });
                            },
                            validator: (value) {
                              if (value!.isEmpty) { return 'Password should not be empty!'; }
                              else if (_signInState == 3) { return 'Invalid Password'; }
                              else { return null; }
                            },
                          ),
                          addVerticalSpace(40),
                          NavigationButton(
                            text: 'Login',
                            onTap: () {
                              _formKey.currentState!.validate();
                              AuthService().signInEmailPassword(_login, _password, context)
                              .then((value) {
                                setState(() { _signInState = value; });
                                _formKey.currentState!.validate();
                              });
                            }
                          ),
                          addVerticalSpace(20),
                          NavigationButton(
                            text: 'Back',
                            isOutline: true,
                            onTap: () {
                              AuthService().signOut();
                              widget.navigatedFrom ? Navigator.pop(context) : null;
                            },
                          ),
                        ] ,
                      )
                    ),
                  ],
                )
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isValueValid(regExp, value) {
  final search = RegExp(regExp);
  return search.hasMatch(value);
}