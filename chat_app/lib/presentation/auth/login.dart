import 'package:chat_app/presentation/auth/otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../../bloc/auth/auth_bloc.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    bool isFinished = false;
    TextEditingController textEditingController = new TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (ccontext) => OtpScreen()));
                      },
                      child: Text(
                        "ChatApp",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 166, 6, 194)),
                      ),
                    ),
                    Lottie.network(
                        "https://lottie.host/e46b8ae9-3c60-4eb2-9a03-e7ea977ce5ae/9uzsflJixK.json")
                  ],
                )),
            Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: TextFormField(
                        controller: textEditingController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: "Your Phone Number",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state is AuthSendOtpSuccessFull) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (ccontext) => OtpScreen()));
                        }
                      },
                      builder: (context, state) {
                        return state is AuthSendOtpLoading
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (textEditingController.text.length ==
                                        10) {
                                      context.read<AuthBloc>().add(AuthSendOtp(
                                          phoneNumber: "+91" +
                                              textEditingController.text));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 166, 6, 194),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20), // Adjust the value to change the button's roundness
                                    ),
                                  ),
                                  child: Text(
                                    'Send OTP',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
