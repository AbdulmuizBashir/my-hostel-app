import 'package:flutter/material.dart';
import 'package:my_hostel_app/component/custom_textfield.dart';
import 'package:my_hostel_app/component/my_loading_circle.dart';
import 'package:my_hostel_app/service/auth/auth_service.dart';
import 'package:my_hostel_app/service/database/database_services.dart';
import 'package:my_hostel_app/pages/profile_page.dart'; // Import ProfilePage

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _auth = AuthService();
  final _db = DatabaseServices();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conPasswordController = TextEditingController();
  final TextEditingController regNumberController = TextEditingController();
  final TextEditingController programController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  // Variables to manage obscure text
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  void register() async {
    if (_passwordController.text == _conPasswordController.text) {
      showLoadingCircle(context);

      try {
        // Register the user
        await _auth.registerEmailAndPassword(
          emailController.text,
          _passwordController.text,
        );

        // Save user profile in the database
        await _db.saveUserInfoIntoFirebase(
          phoneNumber: phoneNumberController.text,
          name: nameController.text,
          email: emailController.text,
          regNumber: regNumberController.text,
          program: programController.text,
        );

        // Navigate to ProfilePage after successful registration
        String uid = _auth.getCurrentUid();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(uid: uid),
          ),
        );
      } catch (e) {
        if (mounted) hideLoadingCircle(context);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(child: Text("Passwords don't match")),
          titleTextStyle:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "My Hostel",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
              const Text(
                "Hello again",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTextfield(
                      controller: nameController,
                      hintText: "Name",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: emailController,
                      hintText: "Email",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: phoneNumberController,
                      hintText: "Phone Number",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: programController,
                      hintText: "Program",
                    ),
                    const SizedBox(height: 10),
                    CustomTextfield(
                      controller: regNumberController,
                      hintText: "Registration Number",
                    ),
                    const SizedBox(height: 10),

                    // Password field with obscure text toggle
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      decoration: InputDecoration(
                        hintText: "Password",
                        filled: true,
                        fillColor: const Color(0xffE5E5E5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured = !_isPasswordObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Confirm Password field with obscure text toggle
                    TextField(
                      controller: _conPasswordController,
                      obscureText: _isConfirmPasswordObscured,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        filled: true,
                        fillColor: const Color(0xffE5E5E5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordObscured =
                                  !_isConfirmPasswordObscured;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: GestureDetector(
                        onTap: register,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            " Login now",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
