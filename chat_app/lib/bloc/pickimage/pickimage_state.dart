part of 'pickimage_bloc.dart';

@immutable
abstract class PickimageState {}

class PickimageInitial extends PickimageState {}
class PickImageLoading extends PickimageState{}
class PickImageSuccess extends PickimageState{}
class PickImageFailure extends PickimageState{

}