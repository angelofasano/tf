import 'dart:async';
import 'package:tf/repositories/user_repository.dart';
import 'package:tf/utils/apiResponse.dart';

class UserBloc {
  late UserRepository _userRepository;
  late StreamController<ApiResponse<UserResponse>> _userListController;

  StreamSink<ApiResponse<UserResponse>> get userSink =>
      _userListController.sink;

  Stream<ApiResponse<UserResponse>> get userStream =>
      _userListController.stream;

  UserBloc(String accessToken) {
    _userListController = StreamController<ApiResponse<UserResponse>>();
    _userRepository = UserRepository();
    fetchUser(accessToken);
  }

  fetchUser(String accessToken) async {
    userSink.add(ApiResponse.loading('Fetching last products'));
    try {
      UserResponse user = await _userRepository.getUser(accessToken);
      userSink.add(ApiResponse.completed(user));
    } catch (e) {
      userSink.add(ApiResponse.error(e.toString()));
      print(e);
    }
  }

  dispose() {
    print('DISPOSE USER');
    _userListController.close();
  }
}
