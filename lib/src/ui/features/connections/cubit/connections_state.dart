import 'package:equatable/equatable.dart';
import '../../../../core/models/user.dart';

class ConnectionsState extends Equatable {
  final bool isLoading;
  final List<UserPublic> users;
  final List<UserPublic> filteredUsers;
  final String searchQuery;
  final String? error;

  const ConnectionsState({
    this.isLoading = false,
    this.users = const [],
    this.filteredUsers = const [],
    this.searchQuery = '',
    this.error,
  });

  ConnectionsState copyWith({
    bool? isLoading,
    List<UserPublic>? users,
    List<UserPublic>? filteredUsers,
    String? searchQuery,
    String? error,
  }) {
    return ConnectionsState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      filteredUsers: filteredUsers ?? this.filteredUsers,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        users,
        filteredUsers,
        searchQuery,
        error,
      ];
}
