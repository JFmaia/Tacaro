import 'package:flutter/material.dart';
import 'package:tacaro/modules/login/repositories/login_repository.dart';
import 'package:tacaro/modules/models/user_model.dart';
import 'package:tacaro/shared/utils/app_state.dart';

class LoginController extends ChangeNotifier {
  final LoginRepository repository;

  AppState state = AppState.empty();
  String _email = "";
  String _password = "";
  final formKey = GlobalKey<FormState>();

  LoginController({
    required this.repository,
  });

  void onChange({String? email, String? password}) {
    _email = email ?? _email;
    _password = password ?? _password;
  }

  bool validate() {
    final form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void update(AppState state) {
    this.state = state;
    notifyListeners();
  }

  Future<void> login() async {
    if (validate()) {
      try {
        update(AppState.loading());
        final response =
            await repository.login(email: _email, password: _password);
        update(AppState.success<UserModel>(response));
      } catch (e) {
        update(AppState.error(e.toString()));
      }
    }
  }
}
