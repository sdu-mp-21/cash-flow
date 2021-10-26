import 'package:final_project/models/models.dart';

abstract class Repository {
  loginUser(User user);

  registerUser(User user);
}
