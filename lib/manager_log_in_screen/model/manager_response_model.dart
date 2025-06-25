class ManagerResponseModel {
  final String access_token;
  final String token_type;
  final String role;
  final String name;
  final String email;
  final String profile_pic;

  ManagerResponseModel({
    required this.access_token,
    required this.token_type,
    required this.role,
    required this.name,
    required this.email,
    required this.profile_pic,
  });
}
