import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Added for user data storage
import 'models/user_info.dart' as AppModels;
import 'dashboard_screen.dart';

class AuthScreen extends StatefulWidget {
  final String role; // "Parent" or "Child"

  const AuthScreen({super.key, required this.role});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _parentEmailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController(); // Added for user name

  bool _isSignUp = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _parentEmailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  // Validate parent email by checking Firestore
  Future<bool> _validateParentEmail(String email) async {
    try {
      final QuerySnapshot query = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .where('role', isEqualTo: 'Parent')
          .get();

      return query.docs.isNotEmpty;
    } catch (e) {
      print('Error validating parent email: $e');
      return false;
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _handleAuth() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential;
        final String email = _emailController.text.trim();
        final String password = _passwordController.text;
        final String name = _nameController.text.trim();

        if (_isSignUp) {
          // For child accounts, validate parent email
          if (widget.role == "Child") {
            final parentEmail = _parentEmailController.text.trim();
            final isValidParent = await _validateParentEmail(parentEmail);

            if (!isValidParent) {
              _showErrorMessage("Parent email not recognized");
              setState(() => _isLoading = false);
              return;
            }
          }

          // Create user account
          userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Store user data in Firestore
          await _firestore.collection('users').doc(userCredential.user!.uid).set({
            'name': name,
            'email': email,
            'role': widget.role,
            'createdAt': FieldValue.serverTimestamp(),
            'profileImage': widget.role == "Parent"
                ? 'assets/parent_profile.png'
                : 'assets/child_profile.png',
            if (widget.role == "Child")
              'parentEmail': _parentEmailController.text.trim(),
          });
        } else {
          // Sign in
          userCredential = await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          // Role mismatch protection
          final roleCheck = await _firestore.collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (!roleCheck.exists || roleCheck.data()?['role'] != widget.role) {
            await _auth.signOut();
            _showErrorMessage("No ${widget.role.toLowerCase()} account found with these credentials");
            setState(() => _isLoading = false);
            return;
          }
        }

        // Fetch full user data
        final userDoc = await _firestore.collection('users')
            .doc(userCredential.user!.uid)
            .get();

        final userData = userDoc.data();
        if (userData == null) {
          _showErrorMessage("User data not found.");
          setState(() => _isLoading = false);
          return;
        }

        final userInfo = AppModels.UserInfo(
          name: userData['name'] ?? '',
          role: userData['role'] ?? '',
          profileImage: userData['profileImage'] ?? '',
        );

        // Go to Dashboard
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DashboardScreen(userInfo: userInfo),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Authentication failed';
        switch (e.code) {
          case 'email-already-in-use':
            message = 'This email is already in use';
            break;
          case 'user-not-found':
            message = 'No user found with this email';
            break;
          case 'wrong-password':
            message = 'Wrong password';
            break;
          case 'invalid-email':
            message = 'Invalid email format';
            break;
          case 'weak-password':
            message = 'Password is too weak';
            break;
        }
        _showErrorMessage(message);
      } catch (e) {
        _showErrorMessage('An error occurred: ${e.toString()}');
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isParent = widget.role == "Parent";

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFFD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: const Color(0xFF5A3DA0),
                      onPressed: () {
                        Navigator.pop(context); // Go back to previous screen
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Image.asset('assets/final logo.png', width: 80, height: 80),
                  const SizedBox(height: 20),
                  Text(
                    widget.role,
                    style: GoogleFonts.kodchasan(
                      fontSize: 22,
                      color: const Color(0xFF5A3DA0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Only show name field for sign up
                  if (_isSignUp) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Name",
                        style: GoogleFonts.kodchasan(
                          fontSize: 14,
                          color: const Color(0xFF5A3DA0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: GoogleFonts.kodchasan(fontSize: 14),
                      validator: (val) {
                        if (_isSignUp && (val == null || val.isEmpty)) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Email field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Email",
                      style: GoogleFonts.kodchasan(
                        fontSize: 14,
                        color: const Color(0xFF5A3DA0),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.kodchasan(fontSize: 14),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Email is required";
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Password",
                      style: GoogleFonts.kodchasan(
                        fontSize: 14,
                        color: const Color(0xFF5A3DA0),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    style: GoogleFonts.kodchasan(fontSize: 14),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Password is required";
                      }
                      if (_isSignUp && val.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  // Parent email field for child signup
                  if (_isSignUp && !isParent) ...[
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Parent's Email",
                        style: GoogleFonts.kodchasan(
                          fontSize: 14,
                          color: Color(0xFF5A3DA0),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _parentEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Enter your parent's email",
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      style: GoogleFonts.kodchasan(fontSize: 14),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Parent email is required";
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                  ],

                  const SizedBox(height: 40),

                  // Sign in/up button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleAuth,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFC94D),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                        _isSignUp ? "Sign Up" : "Sign In",
                        style: GoogleFonts.kodchasan(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Toggle between sign in and sign up
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSignUp = !_isSignUp;
                      });
                    },
                    child: Text(
                      _isSignUp
                          ? "Already have an account? Sign In"
                          : "Create Account",
                      style: GoogleFonts.kodchasan(
                        fontSize: 14,
                        color: const Color(0xFFFF7EA2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}