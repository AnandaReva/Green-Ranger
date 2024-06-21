// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:green_ranger/firebase/firebaseAuth.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_ranger/mongoDB/authMongodb.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
import 'package:green_ranger/mongoDB/userQuestMongodb.dart';

import 'package:shared_preferences/shared_preferences.dart';

bool loginForm = true; // Inisialisasi di luar blok if

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key, required GlobalVar globalVar}) : super(key: key);

  @override
  State<AuthPage> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  GlobalVar globalVar = GlobalVar.instance;

  @override
  void initState() {
    super.initState();
    // Always start with loginForm as false
    setState(() {
      loginForm = true;
    });
  }

  static String? errorMessage = '';

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  //Cek connection first:

  Future<void> signInWithEmailAndPassword() async {
    try {
      if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
        setState(() {
          errorMessage = 'Please fill in all the data';
        });
        return;
      }
      setState(() {
        globalVar.isLoading = true;
      });

      print('chek login 1');

      bool firebaseAuthSuccess =
          await FirebaseAuthService.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      if (firebaseAuthSuccess) {
        bool loginSuccess = await AuthMongodb.findUserDataMongodb(
          _controllerEmail.text,
          _controllerPassword.text,
        );

        // Cek apakah data berhasil ditemukan
        if (!loginSuccess) {
          // Jika gagal login, set pesan error
          setState(() {
            globalVar.isLoading = false;
          });

          setState(() {
            errorMessage = 'Invalid Email or Password';
          });
          return;
        }
      } else {
        print('Failed to sign in');
        setState(() {
          globalVar.isLoading = false;
        });

        setState(() {
          errorMessage = 'Invalid Email or Password';
        });
        return;
      }

      // fetch feed quest content
      // await QuestMongodb.fetchQuestDataHomePage();
      // await UserQuestMongodb.fetchUserMarkedQuest();
      // await QuestMongodb.fetchUserOnProgressQuest();
      // await QuestMongodb.fetchUserCompletedQuest();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("hasLoggedInOnce", true);

      setState(() {
        globalVar.isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => false,
      );

      // Jika berhasil login, kosongkan pesan error
    } catch (e) {
      setState(() {
        globalVar.isLoading = false;
      });

      setState(() {
        errorMessage = 'Failed connecting to server, check internet connection';
      });
      if (kDebugMode) {
        print('Error during sign in: $e');
      }
    }
  }

  Future<void> signUpUserWithEmailAndPassword() async {
    try {
      if (_controllerEmail.text.isEmpty ||
          _controllerPassword.text.isEmpty ||
          _controllerUsername.text.isEmpty ||
          _controllerPhone.text.isEmpty) {
        setState(() {
          errorMessage = 'Please fill the form';
        });
        return;
      }

      if (_controllerUsername.text.length < 2) {
        setState(() {
          errorMessage = 'Username must be at least 2 characters long';
        });
        return;
      }

      // Validasi format email
      bool isValidEmail(String email) {
        // Validasi format email menggunakan regex
        String emailPattern = r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,4}$';
        RegExp regex = RegExp(emailPattern);
        return regex.hasMatch(email);
      }

      if (!isValidEmail(_controllerEmail.text.trim())) {
        setState(() {
          errorMessage = 'Please enter a valid email address';
        });
        return;
      }

      // Validasi minimal karakter password
      if (_controllerPassword.text.length < 8) {
        setState(() {
          errorMessage = 'Password must be at least 8 characters long';
        });
        return;
      }

      if (_controllerPhone.text.length < 10) {
        setState(() {
          errorMessage = 'Please Enter Valid Phone Number';
        });
        return;
      }

      setState(() {
        globalVar.isLoading = true;
      });

      bool registerSuccess = await AuthMongodb.createUserDataMongodb(
        _controllerEmail.text,
        _controllerPassword.text,
        _controllerUsername.text,
        _controllerPhone.text,
      );

      if (!registerSuccess) {
        // Jika gagal register, set pesan error
        setState(() {
          globalVar.isLoading = false;
        });

        setState(() {
          errorMessage = 'Error registering account Please try Again';
        });
        return;
      }

      // fetch feed quest content
      // await QuestMongodb.fetchQuestDataHomePage();
      // await UserQuestMongodb.fetchUserMarkedQuest();
      // await QuestMongodb.fetchUserOnProgressQuest();
      // await QuestMongodb.fetchUserCompletedQuest();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("hasLoggedInOnce", true);

      setState(() {
        globalVar.isLoading = false;
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Error registering account: $e';
      });
      if (kDebugMode) {
        print('Error during account creation: $e');
      }
    }
  }

  Future<bool> signOutUser() async {
    try {
      await FirebaseAuthService.signOut();

      globalVar.userLoginData = null;
      globalVar.questDataSelected = {};
      globalVar.userMarkedQuest = null;
      globalVar.userOnProgressQuest = null;
      globalVar.userCompletedQuest = null;

      return true;
    } catch (e) {
      setState(() {
        errorMessage = 'Error Logout from account: $e';
      });

      return false;
    }
  }

  Widget _entryField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              if (controller == _controllerEmail)
                Icon(
                  Icons.email,
                  size: 25,
                  color: GlobalVar.baseColor,
                ),
              if (controller == _controllerPassword)
                Icon(
                  Icons.lock_sharp,
                  size: 25,
                  color: GlobalVar.baseColor,
                ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: GlobalVar.baseColor,
                  ),
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: labelText,
                    labelStyle: TextStyle(
                      color: GlobalVar.baseColor,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1.0,
            color: GlobalVar.baseColor,
          ),
        ],
      ),
    );
  }

  Widget _entryFieldUsername(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        // Use Column to stack widgets vertically
        children: [
          Row(
            // Use Row for horizontal layout like _entryField
            children: [
              Icon(
                Icons.person,
                size: 25,
                color: GlobalVar.baseColor,
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: GlobalVar.baseColor,
                  ),
                  controller: controller,
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^[a-zA-Z0-9 ]*$')),
                    LengthLimitingTextInputFormatter(25),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: labelText,
                    labelStyle: TextStyle(
                      color: GlobalVar.baseColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            // Add divider below the Row
            thickness: 1.0,
            color: GlobalVar.baseColor,
          ),
        ],
      ),
    );
  }

  Widget _entryFieldPhone(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.phone,
                size: 25,
                color: GlobalVar.baseColor,
              ),
              SizedBox(width: 20),
              Expanded(
                child: TextField(
                  style: TextStyle(
                    color: GlobalVar.baseColor,
                  ),
                  controller: controller,
                  keyboardType:
                      TextInputType.number, // Set keyboard type for numbers
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Allow only digits
                    // Phone number formatting (Indonesia specific)
                    LengthLimitingTextInputFormatter(
                        15), // Maximum length (including + and spaces)
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^[+]*[0-9 ]*$'), // Allow +, digits, and spaces
                    ),
                  ],
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: labelText + " (exp: 0812345678910)",
                    labelStyle: TextStyle(
                      color: GlobalVar.baseColor,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            thickness: 1.0,
            color: GlobalVar.baseColor,
          ),
        ],
      ),
    );
  }

  Widget _googleAuth(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: GlobalVar.baseColor),
          color: Color.fromRGBO(254, 63, 62, 1),
        ),
        child: InkWell(
          onTap: () async {
            try {
              UserCredential? userCredential =
                  await FirebaseAuthService.signInWithGoogle();
              if (userCredential != null) {
                User? user = userCredential.user;
                if (user != null) {
                  String email = user.email.toString();

                  print('email: $email');

                  setState(() {
                    globalVar.isLoading = true;
                  });
                  // fetch data userlogin
                  bool loginSuccess =
                      await AuthMongodb.findUserDataWithouPasswordMongodb(
                          email);
                  // Cek apakah data berhasil ditemukan
                  if (!loginSuccess) {
                    // Jika gagal login, set pesan error
                    setState(() {
                      globalVar.isLoading = false;
                      errorMessage = 'Invalid Email or Password';
                    });

                    return;
                  }

                  setState(() {
                    globalVar.isLoading = false;
                  });

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (route) => false,
                  );
                }
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error during sign in with Google: $e')),
              );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/googleIcon.png',
                width: 24,
                height: 14,
              ),
              SizedBox(width: 10), // Spacer
              Text(
                "Google Account",
                style: TextStyle(
                    fontWeight: FontWeight.normal, color: GlobalVar.mainColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    if (errorMessage == null || errorMessage!.isEmpty) {
      return Container(); // Widget penampung kosong
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.red,
                fontFamily: 'Poppins-Bold',
                fontWeight: FontWeight.bold,
              ),
            ),
          ));
    }
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 35),
        child: GestureDetector(
          onTap: loginForm
              ? signInWithEmailAndPassword
              : signUpUserWithEmailAndPassword,
          child: Container(
            decoration: BoxDecoration(
              color: GlobalVar.secondaryColorGreen,
            ),
            height: 35,
            child: Center(
              child: Text(
                loginForm ? 'Sign In' : 'Sign Up',
                style: TextStyle(
                  color: GlobalVar.mainColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginRegisterButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          child: TextButton(
            onPressed: () {
              setState(() {
                loginForm =
                    !loginForm; // Toggle antara mode login dan registrasi
              });
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: loginForm ? 'Sign Up? ' : 'Already have an account? ',
                    style: TextStyle(
                      color: GlobalVar
                          .baseColor, // Warna teks untuk bagian pertama
                    ),
                  ),
                  TextSpan(
                    text: loginForm ? 'Register' : 'Sign In',
                    style: TextStyle(
                      color: Colors.blue, // Warna teks untuk bagian kedua
                      fontWeight:
                          FontWeight.bold, // Atur gaya teks menjadi tebal
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(backgroundColor: GlobalVar.mainColor),
        backgroundColor: GlobalVar.mainColor,
        body: globalVar.isLoading
            ? LoadingUi()
            : SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              loginForm
                                  ? Center(
                                      child: Column(
                                        children: [
                                          Image.asset(
                                            'assets/images/logo.png',
                                            height: 150,
                                          ),
                                          SizedBox(height: 30),
                                          Text(
                                            "Welcome to Green Ranger \n Please Sign In or Register New Account",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: GlobalVar.baseColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 17,
                                            ),
                                          ),
                                          SizedBox(height: 40),
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Center(
                                        child: Text(
                                          loginForm ? 'Masuk' : 'Daftar',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 30,
                                          ),
                                        ),
                                      )),
                              if (!loginForm) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Center(
                                    child: Text(
                                      "Create Account",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: GlobalVar.baseColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                _entryFieldUsername(
                                    'Username', _controllerUsername),
                                const SizedBox(height: 10),
                              ],
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              _entryField('Email', _controllerEmail),
                              const SizedBox(height: 10),
                              _entryField('Password', _controllerPassword),
                              SizedBox(height: 10),
                              if (!loginForm) ...[
                                _entryFieldPhone('Phone', _controllerPhone),
                                const SizedBox(height: 10),
                              ],
                              _errorMessage(),
                              SizedBox(height: 10),
                              _submitButton(),
                              Divider(
                                height: 50,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                                color: GlobalVar.baseColor,
                              ),
                              _googleAuth(context)
                            ],
                          ),
                          _loginRegisterButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
