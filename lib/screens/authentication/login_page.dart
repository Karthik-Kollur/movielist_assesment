import 'package:flutter/material.dart';
import 'package:movie_list/screens/authentication/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home_screen/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _storedName;
  String? _storedPassword;
  bool _invalidCredentials = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _storedName = prefs.getString('name');
    _storedPassword = prefs.getString('password');
  }

  void _login() {
    String enteredName = _nameController.text;
    String enteredPassword = _passwordController.text;

    if (enteredName == _storedName && enteredPassword == _storedPassword) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {

      setState(() {
        _invalidCredentials = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                Image.asset(
                  'lib/images/login_Image.png',
                  width: 200,
                  height: 200,
                ),
                Text("Login",style: TextStyle(fontSize: 40.0),)
              ],
            ),
          ),
       Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_invalidCredentials)
                Text(
                  'Invalid Credentials',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16.0,
                  ),
                ),

              SizedBox(height: 16.0),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: Text('Create an account'),
              ),
            ],
          ),
        ),
    ],
      ),
    );
  }
}
