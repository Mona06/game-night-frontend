import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:party_planner/src/ui/features/connections/cubit/connections_cubit.dart';
import 'package:party_planner/src/core/models/user.dart';
import 'package:party_planner/src/core/services/user_service.dart';
import 'package:party_planner/src/ui/features/connections/cubit/connections_state.dart';

import 'connections_cubit_test.mocks.dart';

@GenerateMocks([UserService])
void main() {
  late MockUserService mockUserService;
  late ConnectionsCubit connectionsCubit;

  final testUsers = [
    UserPublic(
      id: 1,
      username: 'john_doe',
      displayName: 'John Doe',
      email: 'john@example.com',
    ),
    UserPublic(
      id: 2,
      username: 'jane_smith',
      displayName: 'Jane Smith',
      email: 'jane@example.com',
    ),
    UserPublic(
      id: 3,
      username: 'bob_wilson',
      displayName: 'Bob Wilson',
      email: 'bob@example.com',
    ),
  ];

  setUp(() {
    mockUserService = MockUserService();
    connectionsCubit = ConnectionsCubit(mockUserService);
  });

  tearDown(() {
    connectionsCubit.close();
  });

  test('initial state is correct', () {
    expect(
      connectionsCubit.state,
      equals(const ConnectionsState()),
    );
  });

  group('fetchUsers', () {
    blocTest<ConnectionsCubit, ConnectionsState>(
      'emits [loading, success] when fetchUsers succeeds',
      build: () {
        when(mockUserService.getUsers()).thenAnswer((_) async => testUsers);
        return connectionsCubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const ConnectionsState(isLoading: true),
        ConnectionsState(
          isLoading: false,
          users: testUsers,
          filteredUsers: testUsers,
        ),
      ],
      verify: (cubit) {
        verify(mockUserService.getUsers()).called(1);
      },
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'emits [loading, error] when fetchUsers fails',
      build: () {
        when(mockUserService.getUsers()).thenThrow(Exception('Network error'));
        return connectionsCubit;
      },
      act: (cubit) => cubit.fetchUsers(),
      expect: () => [
        const ConnectionsState(isLoading: true),
        const ConnectionsState(
          isLoading: false,
          error: 'Failed to load users: Exception: Network error',
        ),
      ],
      verify: (cubit) {
        verify(mockUserService.getUsers()).called(1);
      },
    );
  });

  group('filterUsers', () {
    blocTest<ConnectionsCubit, ConnectionsState>(
      'filters users by username correctly',
      build: () => connectionsCubit,
      seed: () => ConnectionsState(
        users: testUsers,
        filteredUsers: testUsers,
      ),
      act: (cubit) => cubit.filterUsers('john'),
      expect: () => [
        ConnectionsState(
          users: testUsers,
          filteredUsers: [testUsers[0]],
          searchQuery: 'john',
        ),
      ],
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'filters users by display name correctly',
      build: () => connectionsCubit,
      seed: () => ConnectionsState(
        users: testUsers,
        filteredUsers: testUsers,
      ),
      act: (cubit) => cubit.filterUsers('Jane'),
      expect: () => [
        ConnectionsState(
          users: testUsers,
          filteredUsers: [testUsers[1]],
          searchQuery: 'Jane',
        ),
      ],
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'returns empty list when no matches found',
      build: () => connectionsCubit,
      seed: () => ConnectionsState(
        users: testUsers,
        filteredUsers: testUsers,
      ),
      act: (cubit) => cubit.filterUsers('xyz'),
      expect: () => [
        ConnectionsState(
          users: testUsers,
          filteredUsers: const [],
          searchQuery: 'xyz',
        ),
      ],
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'returns all users when search query is empty',
      build: () => connectionsCubit,
      seed: () => ConnectionsState(
        users: testUsers,
        filteredUsers: [testUsers[0]], // Start with filtered list
        searchQuery: 'john',
      ),
      act: (cubit) => cubit.filterUsers(''),
      expect: () => [
        ConnectionsState(
          users: testUsers,
          filteredUsers: testUsers,
          searchQuery: '',
        ),
      ],
    );

    blocTest<ConnectionsCubit, ConnectionsState>(
      'is case insensitive',
      build: () => connectionsCubit,
      seed: () => ConnectionsState(
        users: testUsers,
        filteredUsers: testUsers,
      ),
      act: (cubit) => cubit.filterUsers('JOHN'),
      expect: () => [
        ConnectionsState(
          users: testUsers,
          filteredUsers: [testUsers[0]],
          searchQuery: 'JOHN',
        ),
      ],
    );
  });
}
