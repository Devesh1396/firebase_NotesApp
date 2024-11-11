import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notesapp/Noteshome_UI.dart';
import 'package:firebase_notesapp/datamodel.dart';
import 'package:firebase_notesapp/fb_service.dart';
import 'package:firebase_notesapp/session_service.dart';
import 'package:flutter/material.dart';

class RegisterUI extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();  // Form key for validation

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Register user function
  void _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        UserModel newUser = UserModel(
          uid: userCredential.user!.uid,
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          contact: contactController.text.trim(),
        );

        await _firestoreService.addUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successful!")));

        String uid = userCredential.user!.uid;

        // Fetch user from Firestore
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        String userName = userDoc['name'];

        // Save user data in SessionManager
        await SessionManager().setUid(uid);
        await SessionManager().setUsername(userName);


        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NoteUI()),
        );

      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'The email address is already in use.';
        } else if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else {
          message = 'An error occurred. Please try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.white,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            //stops: [0.1, 1],
          ),
        ),
        child:
              Stack(
                children: [
                  _registerUI(context),
                ],
              )
      ),

    );
  }

  Widget _registerUI(BuildContext context){

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15.0,
                spreadRadius: 5.0,
                offset: Offset(0,5),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        "Create Account",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),

                _textfieldLabel(text: "Name"),
                SizedBox(height: 5),
                _TextFormField(
                  text: 'Name',
                  controller: nameController,
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    } else if (value.length < 5) {
                      return 'Name should be at least 5 characters';
                    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {  // Alphabetic characters and spaces only
                      return 'Name should contain only letters';
                    }
                    return null;  // Valid input
                  },
                ),

                SizedBox(height: 20),

                _textfieldLabel(text: "Email"),
                SizedBox(height: 5),
                _TextFormField(
                  text: 'Email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  icon: Icons.email,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;  // Valid input
                  },
                ),

                SizedBox(height: 20),

                _textfieldLabel(text: "Password"),
                SizedBox(height: 5),
                _TextFormField(
                  text: 'Password',
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  icon: Icons.lock,
                  validator: (value) {
                    if (value == null || value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),

                _textfieldLabel(text: "Contact"),
                SizedBox(height: 5),
                _TextFormField(
                  text: 'Contact',
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  icon: Icons.phone,  // Update to a phone icon for accuracy
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    } else if (value.length != 10) {  // Check for exactly 10 digits
                      return 'Please enter a valid 10-digit contact number';
                    } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {  // Ensure only digits
                      return 'Contact number should contain only digits';
                    }
                    return null;  // Valid input
                  },
                ),

                SizedBox(height: 25),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _registerUser();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: EdgeInsets.symmetric(vertical:20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      )
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create My Account",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Icon(Icons.double_arrow_outlined, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textfieldLabel({
    required String text,
  }){
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: Colors.black,
      ),
    );
  }

  Widget _TextFormField({
    required String text,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    String? Function(String?)? validator,  // Add validator parameter
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,  // Apply the validator to TextFormField
      decoration: InputDecoration(
        suffixIcon: Icon(icon),
        hintText: text,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5), width: 2.0),
        ),
      ),
    );
  }


}