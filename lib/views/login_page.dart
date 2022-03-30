import 'package:flutter/material.dart';
import 'package:webadmin_onboarding/utils/custom_colors.dart';

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

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        // horizontal: 100,
        vertical: MediaQuery.of(context).size.height * 0.2,
      ),
      child: _formLogin(),
    );
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
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
            )),
            SizedBox(height: 30),
            TextFormField(
                decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Password",
            )),
            SizedBox(height: 30),
            Container(
                alignment: Alignment.centerLeft,
                child: InkWell(
                    onTap: () {},
                    child: Text("Forgot Password?",
                        style: TextStyle(fontWeight: FontWeight.w600)))),
            SizedBox(height: 60),
            ElevatedButton(
              child: Container(
                  width: 60, height: 45, child: Center(child: Text("Login", style: TextStyle(fontSize: 18),))),
              onPressed: () {},
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

  // Widget _loginWithButton({String image, bool isActive = false}) {
  //   return Container(
  //     width: 90,
  //     height: 70,
  //     decoration: isActive
  //         ? BoxDecoration(
  //             color: Colors.white,
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.grey[300],
  //                 spreadRadius: 10,
  //                 blurRadius: 30,
  //               )
  //             ],
  //             borderRadius: BorderRadius.circular(15),
  //           )
  //         : BoxDecoration(
  //             borderRadius: BorderRadius.circular(15),
  //             border: Border.all(color: Colors.grey[400]),
  //           ),
  //     child: Center(
  //         child: Container(
  //       decoration: isActive
  //           ? BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.circular(35),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey[400],
  //                   spreadRadius: 2,
  //                   blurRadius: 15,
  //                 )
  //               ],
  //             )
  //           : BoxDecoration(),
  //       child: Image.asset(
  //         '$image',
  //         width: 35,
  //       ),
  //     )),
  //   );
  // }
}
