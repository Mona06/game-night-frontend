import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/user_service.dart';
import 'connections_state.dart';

class ConnectionsCubit extends Cubit<ConnectionsState> {
  final UserService _userService;

  ConnectionsCubit(this._userService) : super(const ConnectionsState());

  Future<void> fetchUsers() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final users = await _userService.getUsers();

      emit(
        state.copyWith(
          isLoading: false,
          users: users,
          filteredUsers: users,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to load users: $e',
        ),
      );
    }
  }

  void filterUsers(String query) {
    final lowercaseQuery = query.toLowerCase();
    final filtered = state.users.where((user) {
      return user.username.toLowerCase().contains(lowercaseQuery) ||
          (user.displayName?.toLowerCase().contains(lowercaseQuery) ?? false);
    }).toList();

    emit(
      state.copyWith(
        searchQuery: query,
        filteredUsers: filtered,
      ),
    );
  }
}
