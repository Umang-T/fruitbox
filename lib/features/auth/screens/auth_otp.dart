import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fruitbox/features/auth/screens/auth_register.dart';
import 'package:pinput/pinput.dart';
import '../../../constants/global_variables.dart';
import 'enter_user_details.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});
  @override
  State<OTPScreen> createState() => _OTPScreenState();
}
class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp1.png',
                width: 200,
                height: 200,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "OTP Verification",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter the verification code we just sent to your number",
                style: TextStyle(
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                onChanged: (value) {
                  code = value;
                },
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Didn’t receive code? Go back and try again!",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalVariables.secondaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      PhoneAuthCredential credential =
                      PhoneAuthProvider.credential(
                          verificationId: Register.verify, smsCode: code);

                      await auth.signInWithCredential(credential);
                      if (auth.currentUser != null) {
                        bool isNewUser = await checkIfNewUser(auth
                            .currentUser!);
                        if (isNewUser) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const EnterUserDetails()),
                          );
                        } else {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            'bottomNav',
                                (route) => false,
                          );
                        }
                      }
                    } catch (e) {
                      print("Wrong OTP");
                    }
                  },
                  child: const Text("Verify Phone Number"),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'fruit',
                            (route) => false,
                      );
                    },
                    child: const Text(
                      "Edit Phone Number ?",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> checkIfNewUser(User user) async {
    try {
      // Assuming you have a 'users' collection in Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection(
          'users').doc(user.uid).get();

      if (userDoc.exists) {
        // User exists in the 'users' collection
        return false; // Existing user
      } else {
        // User does not exist in the 'users' collection
        return true; // New user
      }
    } catch (e) {
      // Handle exceptions, e.g., if there is an issue connecting to Firestore
      print("Error checking if the user is new: $e");
      return false; // Assume existing user in case of an error
    }
  }
}