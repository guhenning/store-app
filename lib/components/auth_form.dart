import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/components/custom_button.dart';
import 'package:store/components/continue_with_google.dart';
import 'package:store/exceptions/auth_exeption.dart';
import 'package:store/providers/auth.dart';

enum AuthMode { signup, login, resetpassword, signinwithgoogle }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _passwordControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSignUp() => _authMode == AuthMode.signup;
  bool _isResetPassword() => _authMode == AuthMode.resetpassword;
  bool _isGoogleSignIn() => _authMode == AuthMode.signinwithgoogle;

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  void _switchtoResetPasswordMode() {
    setState(() {
      if (_isResetPassword()) {
        _authMode = AuthMode.login;
      } else {
        _authMode = AuthMode.resetpassword;
      }
    });
  }

  void _googleSignInmodeandLogin() async {
    setState(() {
      _authMode = AuthMode.signinwithgoogle;
    });

    await Provider.of<Auth>(context, listen: false).signinwithgoogle(context);
  }

  void _showErrorDialog(String mensage) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Center(
                child: Text(
                  'An Error Occurred',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color),
                ),
              ),
              content: Text(
                mensage,
                textAlign: TextAlign.center,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.titleLarge?.color),
                  ),
                )
              ],
            ));
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else if (_isSignUp()) {
        // Registrar
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      } else if (_isResetPassword()) {
        await auth.resetPassword(context, _authData['email']!);
      } else if (_isGoogleSignIn()) {
        await auth.signinwithgoogle(context);
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      // to do leave or remain this error?
      _showErrorDialog(
        'An unexpected error occurred.',
      );
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
      ),
      width: 400,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  labelText: 'E-Mail',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty ||
                      email.length < 5 ||
                      !email.contains('@')) {
                    return 'Inform a valid E-mail';
                  }
                  return null;
                },
              ),
            ),
            if (_isSignUp() || (_isLogin()) || (_isGoogleSignIn()))
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText1 = !_obscureText1;
                          });
                        },
                        child: Icon(
                          color: Colors.grey,
                          _obscureText1
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )),
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText1,
                  controller: _passwordControler,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  validator: (_password) {
                    final password = _password ?? '';
                    if (password.trim().isEmpty || password.length < 5) {
                      return 'Inform a valid Password';
                    }
                    return null;
                  },
                ),
              ),
            if (_isSignUp())
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 16),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureText2 = !_obscureText2;
                          });
                        },
                        child: Icon(
                          color: Colors.grey,
                          _obscureText2
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      )),
                  keyboardType: TextInputType.text,
                  obscureText: _obscureText2,
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordControler.text) {
                            return 'The Password\'s don\'t match!';
                          }
                          return null;
                        },
                ),
              ),
            if (!_isSignUp())
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextButton(
                          onPressed: _switchtoResetPasswordMode,
                          child: Text(
                            _isResetPassword()
                                ? 'Go to Login Page'
                                : 'Forgot Password',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.color,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_isLogin() || (_isGoogleSignIn()))
              PersonalizedButton(onPressed: _submit, text: 'LOGIN')
            else if (_isSignUp())
              PersonalizedButton(onPressed: _submit, text: 'REGISTER')
            else if (_isResetPassword())
              PersonalizedButton(onPressed: _submit, text: 'RESET PASSWORD'),
            const SizedBox(height: 25),
            if (_isResetPassword()) const SizedBox(height: 40),
            Stack(
              children: [
                if (_isSignUp() || (_isLogin()) || (_isGoogleSignIn()))
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/form2.webp', height: 240),
                    ],
                  ),
                if (_isResetPassword())
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/images/form2.webp', height: 270),
                    ],
                  ),
                if (_isSignUp() || (_isLogin()) || (_isGoogleSignIn()))
                  // To do
                  ContinueWithGoogle(
                      onTapGoogle: _googleSignInmodeandLogin,
                      onTapFaceBook: () {
                        print('FaceBook tap');
                      }),
                if (_isSignUp() || (_isLogin()) || (_isGoogleSignIn()))
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _isLogin()
                                ? 'Don\'t have an account?'
                                : 'Already have an account?',
                            style: const TextStyle(color: Colors.black45),
                          ),
                          const SizedBox(width: 3),
                          TextButton(
                            onPressed: _switchAuthMode,
                            child: Text(
                              _isLogin() ? 'Register now' : 'Login now',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headlineLarge
                                      ?.color,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
