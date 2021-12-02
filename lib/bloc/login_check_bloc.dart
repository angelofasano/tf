import 'dart:async';
import 'package:tf/repositories/login_check_repository.dart';
import 'package:tf/utils/apiResponse.dart';

class LoginCheckBloc {
  late LoginCheckRepository _loginCheckRepository;
  late StreamController<ApiResponse<bool>> _loginCheckController;

  StreamSink<ApiResponse<bool>> get userLoggedSink =>
      _loginCheckController.sink;

  Stream<ApiResponse<bool>> get userLoggedStream =>
      _loginCheckController.stream;

  LoginCheckBloc(String accessToken) {
    _loginCheckController = StreamController<ApiResponse<bool>>();
    _loginCheckRepository = LoginCheckRepository();
    checkIfUserIsLogged(accessToken);
  }

  checkIfUserIsLogged(String accessToken) async {
    userLoggedSink.add(ApiResponse.loading('Checking if user is logged in'));
    try {
      bool isUserLogged =
          await _loginCheckRepository.checkIfUserIsLogged(accessToken);
      userLoggedSink.add(ApiResponse.completed(isUserLogged));
    } catch (e) {
      userLoggedSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    print('DISPOSE LOGIN CHECK');
    _loginCheckController.close();
  }
}
