import 'package:bloc/bloc.dart';
import 'package:sekolah/models/sekolah.dart';
import 'package:sekolah/ui/addDataScreen.dart';
import 'package:sekolah/ui/homeScreen.dart';

enum NavigationEvents { HomeClickedEvent, AddDataClickedEvent }

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.HomeClickedEvent:
        yield Home();
        break;
      case NavigationEvents.AddDataClickedEvent:
        yield addData();
        break;
    }
  }
}
