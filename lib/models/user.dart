class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  UserModel(
      {required this.email,
      required this.uid,
      required this.username,
      required this.photoUrl,
      required this.bio,
      required this.followers,
      required this.following});
}
