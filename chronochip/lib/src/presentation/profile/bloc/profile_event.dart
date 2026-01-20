abstract class ProfileEvent {}

class FetchProfile extends ProfileEvent {}

class UploadProfileImage extends ProfileEvent {
  final String imagePath;
  UploadProfileImage(this.imagePath);
}
