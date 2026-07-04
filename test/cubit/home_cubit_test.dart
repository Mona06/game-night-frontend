import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:party_planner/src/ui/features/home/cubit/home_cubit.dart';
import 'package:party_planner/src/ui/features/home/cubit/home_state.dart';

void main() {
  group('HomeCubit', () {
    late HomeCubit homeCubit;

    setUp(() {
      homeCubit = HomeCubit();
    });

    tearDown(() {
      homeCubit.close();
    });

    test('initial state is HomeState with selectedTabIndex = 0', () {
      expect(homeCubit.state, const HomeState(selectedTabIndex: 0));
    });

    blocTest<HomeCubit, HomeState>(
      'emits updated state when updateSelectedTab is called',
      build: () => homeCubit,
      act: (cubit) => cubit.updateSelectedTab(1),
      expect: () => [
        const HomeState(selectedTabIndex: 1),
      ],
    );

    blocTest<HomeCubit, HomeState>(
      'emits multiple states for consecutive calls to updateSelectedTab',
      build: () => homeCubit,
      act: (cubit) {
        cubit.updateSelectedTab(2);
        cubit.updateSelectedTab(3);
      },
      expect: () => [
        const HomeState(selectedTabIndex: 2),
        const HomeState(selectedTabIndex: 3),
      ],
    );
  });
}
