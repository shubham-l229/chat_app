import 'dart:io';

import 'package:chat_app/presentation/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/pickimage/pickimage_bloc.dart';
import '../../bloc/uploadImage/upload_image_bloc.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              BlocBuilder<PickimageBloc, PickimageState>(
                builder: (context, state) {
                  return context.read<PickimageBloc>().image.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: FileImage(
                              File(context.read<PickimageBloc>().image)),
                        )
                      : SizedBox.shrink();
                },
              ),
              BlocConsumer<PickimageBloc, PickimageState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<PickimageBloc>().add(PickImage());
                    },
                    child: Text('Add Image'),
                  );
                }, listener: (BuildContext context, PickimageState state) {

                  if(state is PickImageSuccess){
                    context.read<UploadImageBloc>().add(UploadImageFirestore(
                        imagePath: context.read<PickimageBloc>().image));
                  }
              },
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if(state is AuthSignupSuccessFull){
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>Home()));
                  }
                },
                builder: (context, state) {
                  return state is AuthSignupLoading?Center(child: CircularProgressIndicator(),): ElevatedButton(
                    onPressed: () async{
                      // Add your signup logic here
                      String name = _nameController.text;
                      String email = _emailController.text;
                      // You can also add image upload logic here
                      // _image contains the selected image
                      print('Name: $name, Email: $email');

                      if (name.isNotEmpty &&
                          email.isNotEmpty &&
                          context
                              .read<UploadImageBloc>()
                              .imageUrl
                              .isNotEmpty) {
                        context.read<AuthBloc>().add(AuthSignUp(email: email,name: name,image: context
                            .read<UploadImageBloc>()
                            .imageUrl));
                      }
                    },
                    child: const Text('Sign Up'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
