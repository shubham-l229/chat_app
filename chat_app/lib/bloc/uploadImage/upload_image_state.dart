part of 'upload_image_bloc.dart';

@immutable
abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}
class UploadImageSuccess extends UploadImageState{
final String downloadUrl;

  UploadImageSuccess({required this.downloadUrl});
}
class UploadImageFail extends UploadImageState{

}
class UploadImageLoading extends UploadImageState{

}