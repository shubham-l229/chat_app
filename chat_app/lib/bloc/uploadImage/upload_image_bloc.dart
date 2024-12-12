import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';

part 'upload_image_event.dart';
part 'upload_image_state.dart';

class UploadImageBloc extends Bloc<UploadImageEvent, UploadImageState> {
  String _imageUrl = "";
  String get imageUrl =>_imageUrl;
  UploadImageBloc() : super(UploadImageInitial()) {
    on<UploadImageFirestore>(_uploadImageFirestore);
  }

  Future<void> _uploadImageFirestore(UploadImageFirestore event, Emitter<UploadImageState> emit) async{
    log(event.imagePath);
    emit(UploadImageLoading());
    // try{
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      var storageRef = FirebaseStorage.instance.ref().child('uploads/$imageName.jpg');
      var uploadTask = storageRef.putFile(File(event.imagePath));
      var downloadUrl = await (await uploadTask).ref.getDownloadURL();
      _imageUrl = downloadUrl;
      log(downloadUrl);
      emit(UploadImageSuccess(downloadUrl: downloadUrl));
    // }catch (e){
    //   emit(UploadImageFail());
    // }

   }
  }

