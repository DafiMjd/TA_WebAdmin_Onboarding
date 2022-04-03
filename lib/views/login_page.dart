import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/providers/auth_provider.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BROWN_GARUDA,
        body: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.2,
          ),
          children: [
            // Menu(),
            // MediaQuery.of(context).size.width >= 980
            //     ? Menu()
            //     : SizedBox(), // Responsive
            Body()
          ],
        ));
  }
}

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = context.watch<AuthProvider>();

    void _login(String email, String password) {
      authProvider.isLoginButtonDisabled = true;
      authProvider.auth(email, password).catchError((onError) {
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Auth Error"),
                content: Text("$onError"),
                actions: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context, rootNavigator: true).pop(),
                      child: Text("okay"))
                ],
              );
            });
      });
    }

    Widget _formLogin() {
      return Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Login Administrator",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 70),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  )),
              Visibility(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "* Email harus diisi",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: authProvider.isEmailFieldEmpty,
              ),
              SizedBox(height: 30),
              TextFormField(
                  obscureText: authProvider.isPasswordHidden,
                  controller: _passwordController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      suffix: InkWell(
                          onTap: () => authProvider.changePasswordHidden(),
                          child: Icon(authProvider.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility)))),
              Visibility(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "* Password harus diisi",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                visible: authProvider.isPasswordFieldEmpty,
              ),
              SizedBox(height: 30),
              Container(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                      onTap: () {},
                      child: Text("Forgot Password?",
                          style: TextStyle(fontWeight: FontWeight.w600)))),
              SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: authProvider.isLoginButtonDisabled
                        ? Colors.blue[300]
                        : Colors.blue),
                child: Container(
                    width: 60,
                    height: 45,
                    child: Center(
                      child: authProvider.isLoginButtonDisabled
                          ? Text(
                              "Wait",
                              style: TextStyle(fontSize: 18),
                            )
                          : Text(
                              "Login",
                              style: TextStyle(fontSize: 18),
                            ),
                    )),
                onPressed: authProvider.isLoginButtonDisabled
                    ? () {}
                    : () {
                        if (_emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          authProvider.isEmailFieldEmpty =
                              _emailController.text.isEmpty;
                          authProvider.isPasswordFieldEmpty =
                              _passwordController.text.isEmpty;
                          _login(
                              _emailController.text, _passwordController.text);
                        } else {
                          authProvider.isEmailFieldEmpty =
                              _emailController.text.isEmpty;
                          authProvider.isPasswordFieldEmpty =
                              _passwordController.text.isEmpty;
                        }
                      },
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _loginWithButton(image: 'images/google.png'),
              //     _loginWithButton(image: 'images/github.png', isActive: true),
              //     _loginWithButton(image: 'images/facebook.png'),
              //   ],
              // ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 100,
        vertical: MediaQuery.of(context).size.height * 0.2,
      ),
      child: _formLogin(),
    );
  }
}
