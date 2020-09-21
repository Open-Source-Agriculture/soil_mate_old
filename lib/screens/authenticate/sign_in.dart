import 'package:flutter/material.dart';
import 'package:texture_app/services/auth.dart';
import '';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();


  String email ="";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text("Sign in..."),
        actions: <Widget>[
          FlatButton.icon(onPressed: () {
            widget.toggleView();
          },
              icon: Icon(Icons.person),
              label: Text("Register"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0,),
              TextFormField(
                validator:  (val) => val.isEmpty ? "Enter an email" : null,
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                validator:  (val) => val.length < 6 ? "Enter a password greater than 6 characters" : null,
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                color: Colors.green,
                child: Text("Sign in", style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  if (_formKey.currentState.validate()){
                    print("Valid");
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                    if (result == null){
                      setState(() {
                        error = "Could not sign in with these credentials";
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 12.0,),
              Text(error, style: TextStyle(color: Colors.red),)
            ],
          ),
        ),
      ),
    );
  }
}
