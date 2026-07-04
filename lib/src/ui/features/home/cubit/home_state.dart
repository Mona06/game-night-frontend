import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final int selectedTabIndex;

  const HomeState({
    this.selectedTabIndex = 0,
  });

  HomeState copyWith({
    int? selectedTabIndex,
  }) {
    return HomeState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [selectedTabIndex];
}
