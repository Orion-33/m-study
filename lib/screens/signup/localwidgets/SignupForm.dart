import 'package:book_club/screens/noGroup/nogroup.dart';
import 'package:book_club/screens/signup/signup.dart';
import 'package:book_club/states/currentuser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../widgets/ourContainer.dart';
import '../../Home/home.dart';

class OurSignUpForm extends StatefulWidget {
  const OurSignUpForm({Key? key}) : super(key: key);

  @override
  State<OurSignUpForm> createState() => _OurSignUpFormState();
}

class _OurSignUpFormState extends State<OurSignUpForm> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpassController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context,
      String fullName) async {
    CurrenState currenState = Provider.of<CurrenState>(context, listen: false);

    try {
      String returnString =
          await currenState.signUpUser(email, password, fullName);
      if (returnString == "success") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OurnoGroup(),
            ),
            (route) => false);
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(returnString),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OurContainer(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: (Text(
              "Sign Up",
              style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
          ),
          TextFormField(
            controller: fullNameController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.person_outline), hintText: "Name"),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email), hintText: "Email"),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: passwordController,
            obscureText: true,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline), hintText: "Password"),
          ),
          SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: confirmpassController,
            obscureText: true,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_open),
                hintText: "Confirm Password"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text(
                "Sign Up",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            onPressed: () {
              if (passwordController.text == confirmpassController.text) {
                _signUpUser(emailController.text, passwordController.text,
                    context, fullNameController.text);
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Passwords do not match"),
                  duration: Duration(seconds: 2),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
