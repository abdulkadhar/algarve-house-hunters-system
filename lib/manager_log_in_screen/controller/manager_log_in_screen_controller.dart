import 'package:algarve_house_hunters_system/manager_log_in_screen/model/manager_response_model.dart';
import 'package:flutter/material.dart';

class ManagerLogInScreenController extends ChangeNotifier {
  ManagerResponseModel managerData = ManagerResponseModel(
    access_token: '',
    role: '',
    token_type: '',
    name: '',
    email: '',
    profile_pic: '',
  );

  void setManagerData(ManagerResponseModel data) {
    managerData = data;
    notifyListeners();
  }
}
