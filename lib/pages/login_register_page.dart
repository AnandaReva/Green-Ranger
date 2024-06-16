// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:green_ranger/components/loadingUI.dart';
import 'package:green_ranger/globalVar.dart';
import 'package:green_ranger/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_ranger/mongoDB/authMongodb.dart';
import 'package:green_ranger/mongoDB/questMongodb.dart';
import 'package:green_ranger/mongoDB/userQuestMongodb.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:shared_preferences/shared_preferences.dart';

bool loginForm = true; // Inisialisasi di luar blok if

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required GlobalVar globalVar}) : super(key: key);

  @override
  State<SignInPage> createState() => LoginPageState();
}

class LoginPageState extends State<SignInPage> {
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

  //Cek connection first:

  Future<void> signInWithEmailAndPassword() async {
    try {
      if (_controllerEmail.text.isEmpty || _controllerPassword.text.isEmpty) {
        setState(() {
          errorMessage = 'Please fill in all the data';
        });

        return;
      }

      //  if (_controllerPassword.text.length < 8) {
      //   setState(() {
      //     errorMessage = 'Panjang kata sandi minimal 8';
      //   });
      //   return;
      // }

      // // Dummy validation dont delete
      // if (_controllerEmail.text == 'admin@gmail.com' &&
      //     _controllerPassword.text == 'admin123') {
      //   final SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setBool("hasLoggedInOnce", true);

      //   Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(builder: (context) => MainPage()),
      //     (route) => false,
      //   );
      // } else {
      //   setState(() {
      //     errorMessage = 'Email atau password salah';
      //   });
      // }

      setState(() {
        globalVar.isLoading = true;
      });

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
      // fetch feed quest content
      // await QuestMongodb.fetchQuestDataHomePage();
      await UserQuestMongodb.fetchUserMarkedQuest();
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

  Future<void> createUserWithEmailAndPassword() async {
    try {
      if (_controllerEmail.text.isEmpty ||
          _controllerPassword.text.isEmpty ||
          _controllerUsername.text.isEmpty) {
        setState(() {
          errorMessage = 'Kolom data tidak boleh kosong';
        });
        return;
      }

      // Dummy validation
      if (_controllerEmail.text.contains('@') &&
          _controllerPassword.text.length >= 8) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
          (route) => false,
        );
      } else {
        setState(() {
          errorMessage = 'Email atau password tidak valid';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
      });
      if (kDebugMode) {
        print('Error during account creation: $e');
      }
    }
  }

  Widget _entryField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(
              color: GlobalVar.baseColor,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _entryFieldUsername(
      String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: GlobalVar.baseColor,
          border: Border.all(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                  RegExp(r'^[a-zA-Z0-9 ]*$')), // Allow only letters and numbers
              LengthLimitingTextInputFormatter(25),
            ],
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: labelText,
            ),
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
              : createUserWithEmailAndPassword,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 37, 150, 190),
              borderRadius: BorderRadius.circular(12),
            ),
            width: 170,
            height: 75,
            child: Center(
              child: Text(
                loginForm ? 'Next >>' : 'Buat Akun',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loginRegisterButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
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
                      text:
                          loginForm ? 'Pengguna Baru? ' : 'Sudah punya Akun? ',
                      style: TextStyle(
                        color: Colors.black, // Warna teks untuk bagian pertama
                      ),
                    ),
                    TextSpan(
                      text: loginForm ? 'Buat Akun' : 'Masuk',
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
      ),
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
                              Center(
                                  child: Image.asset(
                                "assets/images/logo.png",
                              )),
                              Padding(
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
                                  child: Text(
                                    "Username",
                                    style: TextStyle(
                                      color: GlobalVar.baseColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                                _entryFieldUsername(
                                    'Username', _controllerUsername),
                                const SizedBox(height: 10),
                              ],
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  "Email",
                                  style: TextStyle(
                                    color: GlobalVar.baseColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              _entryField('Email', _controllerEmail),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                    color: GlobalVar.baseColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              _entryField('Password', _controllerPassword),
                              SizedBox(
                                height: 10,
                              ),
                              _errorMessage(),
                              SizedBox(
                                height: 10,
                              ),
                              _submitButton(),
                              Divider(
                                height: 50,
                                thickness: 1,
                                indent: 30,
                                endIndent: 30,
                                color: Colors.black,
                              ),
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
