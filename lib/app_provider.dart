import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sample4/success_page.dart';

enum AppState {
  initial,
  loading,
  success,
  error,
}

class AppProvider with ChangeNotifier {
  AppState _state = AppState.initial;
  AppState get state => _state;

  Future<void> getResult(String searchTrem) async {
    _state = AppState.loading;
    notifyListeners();

    await Future.delayed(Duration(seconds: 1));

    try {
      if (searchTrem == 'fail') {
        throw 'Someting went wrong';
      }
      _state = AppState.success;
      notifyListeners();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) {
      //       return SuccessPage();
      //     },
      //   ),
      // );
    } catch (e) {
      print('***************error: ${e}****************');
      _state = AppState.error;
      notifyListeners();
      // showDialog(
      //   context: context,
      //   builder: (context) => AlertDialog(
      //     content: Text('Someting went wrong'),
      //   ),
      // );
    }
  }
}
