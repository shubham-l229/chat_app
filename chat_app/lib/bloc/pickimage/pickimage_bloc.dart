import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'pickimage_event.dart';
part 'pickimage_state.dart';

class PickimageBloc extends Bloc<PickimageEvent, PickimageState> {
  late String _image="";
  String get image => _image;

  // Setter for phoneNumber
  set image(String value) {
    _image = value;
  }

  PickimageBloc() : super(PickimageInitial()) {
    on<PickImage>(_pickImage);
  }

 _pickImage(PickImage event, Emitter<PickimageState> emit) async{
    emit(PickImageLoading());
    try{
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      image = pickedFile!.path;
      emit(PickImageSuccess());
    }catch(e){
      emit(PickImageFailure());
    }

  }
}
