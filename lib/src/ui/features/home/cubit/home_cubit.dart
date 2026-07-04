import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void updateSelectedTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
