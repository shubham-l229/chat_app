part of 'upload_image_bloc.dart';

@immutable
abstract class UploadImageEvent {}
class UploadImageFirestore extends UploadImageEvent{
final String imagePath;

  UploadImageFirestore({required this.imagePath});
}