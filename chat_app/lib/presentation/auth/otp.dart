import 'package:chat_app/presentation/auth/signup.dart';
import 'package:chat_app/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../bloc/auth/auth_bloc.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Verifcation",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 166, 6, 194)),
            ),
            Text(
              "Enter the code sent to the number ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            Text(
              context.read<AuthBloc>().phoneNumber,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey),
            ),
            buildPinPut(),
            Text("Didn't Recieve Code ?"),
            Text(
              "Resend",
              style: TextStyle(),
            )
          ],
        ),
      )),
    );
  }
}

Widget buildPinPut() {
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(0, 64, 119, 1.0),
        fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      color: Colors.white38,
      border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
      borderRadius: BorderRadius.circular(20),
    ),
  );
  return BlocConsumer<AuthBloc, AuthState>(
    listener: (context, state) {
      // TODO: implement listener
      if (state is AuthVerifyOtpSuccess) {
        if (context.read<AuthBloc>().registerdUser) {
          Navigator.push(
              context, MaterialPageRoute(builder: (ccontext) => Home()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (ccontext) => Signup()));
        }
      }
    },
    builder: (context, state) {
      return state is AuthVerifyOtpLoaading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Pinput(
              defaultPinTheme: defaultPinTheme,
              length: 6,
              androidSmsAutofillMethod:
                  AndroidSmsAutofillMethod.smsUserConsentApi,
              onCompleted: (pin) =>
                  {context.read<AuthBloc>().add(AuthVerifyOtp(otp: pin))},
            );
    },
  );
}
