import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/model/http_execption.dart';
import 'package:shopping_app/provider/auth.dart';
import 'package:shopping_app/screen/profduct_overview.dart';

enum Authmode { login, signup }

class AuthScreen extends StatelessWidget {
  static const routename = '/auth';
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[200],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              flex: screensize.width > 400 ? 2 : 1,
              child: Center(child: AuthCard()))
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formkey = GlobalKey();
  Authmode _authmode = Authmode.login;
  Map<String, String> _authData = {'Email': '', 'Password': ''};
  final bool _isloading = false;
  final _passwordcontroller = TextEditingController();
  bool _islioading = false;
  late AnimationController _Controller;
  // late Animation<double> _opacitycontroller;

  @override
  void initState() {
    _Controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    // _opacitycontroller = Tween(begin: 0.0, end: 1.0)
    //     .animate(CurvedAnimation(parent: _Controller, curve: Curves.easeIn));
    super.initState();
  }

  @override
  void dispose() {
    _Controller.dispose();
    super.dispose();
  }

  void switchbutton() {
    if (_authmode == Authmode.login) {
      setState(() {
        _authmode = Authmode.signup;
      });
    } else if (_authmode == Authmode.signup) {
      setState(() {
        _authmode = Authmode.login;
      });
    }
  }

  void showerrordiloge(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Occored'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OKY'))
        ],
      ),
    );
  }

  Future<void> submit() async {
    final validator = _formkey.currentState!.validate();
    if (!validator) {
      return;
    }
    setState(() {
      _islioading = true;
    });
    _formkey.currentState!.save();
    try {
      if (_authmode == Authmode.login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['Email']!, _authData['Password']!, context);

        setState(() {
          _islioading = false;
        });
      } else if (_authmode == Authmode.signup) {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['Email']!, _authData['Password']!, context)
            .then((value) {
          setState(() {
            _islioading = false;
          });
        });
      }
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(ProductOverView.routename);
    } on HttpError catch (error) {
      if (kDebugMode) {
        print(' error   $error');
      }
      var errormessage = error.toString();

      if (error.toString().contains('EMAIL_EXISTS')) {
        errormessage = 'This Email is already in use';
      } else if (error.toString().contains('INVALIED_EMAIL')) {
        errormessage = 'This Email is Not valied';
      } else if (error.toString().contains('WEEK_PASSWORD')) {
        errormessage = 'PAssword is too short';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errormessage = 'Could not found a user with this mail Id';
      } else if (error.toString().contains('INVALIED_PASSWORD')) {
        errormessage = 'PAssword Invalied';
      }
      showerrordiloge(errormessage);
    } catch (error) {
      print(error);
      const errormessage = 'Authentification failed pls try again later';
      print(error);
      showerrordiloge(errormessage);
    }
    setState(() {
      _islioading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screensize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.linear,
        padding: const EdgeInsets.all(10),
        height: _authmode == Authmode.signup ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authmode == Authmode.signup ? 320 : 260),
        width: screensize.width * .75,
        child: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Shopping App',
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    validator: (email) {
                      if (email!.isEmpty) {
                        return 'Enter Email';
                      }
                      if (!email.contains('@')) {
                        return 'Invalied Email';
                      }
                      return null;
                    },
                    onSaved: (email) {
                      _authData['Email'] = email!;
                    },
                  ),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (password) {
                      if (password!.isEmpty) {
                        return 'Enter a password';
                      }
                      if (password.length < 6) {
                        return 'Need Minimun 6 charactor';
                      }
                      return null;
                    },
                    controller: _passwordcontroller,
                    onSaved: (password) {
                      _authData['Password'] = password!;
                    },
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInSine,
                    constraints: BoxConstraints(
                        minHeight: _authmode == Authmode.signup ? 60 : 0,
                        maxHeight: _authmode == Authmode.signup ? 120 : 0),
                    child: TextFormField(
                        enabled: _authmode == Authmode.signup,
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password'),
                        validator: _authmode == Authmode.signup
                            ? (password) {
                                if (password!.isEmpty) {
                                  return 'Password not match';
                                }
                                if (password != _passwordcontroller.text) {
                                  return 'Password not match';
                                }
                                return ' something went wrong';
                              }
                            : null),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_islioading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                        onPressed: submit,
                        child: _authmode == Authmode.login
                            ? const Text('Login')
                            : const Text('Signup')),
                  TextButton(
                      onPressed: switchbutton,
                      child: Text(
                          _authmode == Authmode.login ? 'Signup' : 'Login'))
                ],
              ),
            )),
      ),
    );
  }
}
