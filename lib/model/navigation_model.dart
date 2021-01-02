import 'package:flutter/material.dart';
import 'package:side_bar/common/NavigationBloc.dart';

class NavigationModel {
  String title;
  IconData icon;
  NavigationEvents eventName;
  NavigationModel({this.title, this.icon, this.eventName});
}

List<NavigationModel> navigationItems = [
//  NavigationModel(title: 'Call', icon: Icons.call),
  NavigationModel(
      title: 'Add contact',
      icon: Icons.add,
      eventName: NavigationEvents.MyCustomForm),
  NavigationModel(
      title: 'View contacts',
      icon: Icons.contacts,
      eventName: NavigationEvents.ContactList)
];
