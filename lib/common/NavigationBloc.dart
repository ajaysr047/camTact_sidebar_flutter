import 'package:bloc/bloc.dart';
import 'package:side_bar/ContactList.dart';
import 'package:side_bar/MyCustomForm.dart';

enum NavigationEvents { MyCustomForm, ContactList }

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => MyCustomForm();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    switch (event) {
      case NavigationEvents.MyCustomForm:
        yield MyCustomForm();
        break;
      case NavigationEvents.ContactList:
        yield ContactList();
        break;
    }
  }
}
