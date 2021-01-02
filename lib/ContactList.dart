import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_bar/common/NavigationBloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactList extends StatefulWidget with NavigationStates {
  @override
  _ContactList createState() => _ContactList();
}

class _ContactList extends State<ContactList> {
  Iterable<Contact> _contactList;
  @override
  void initState() {
    _getContacts();
    super.initState();
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ??
          PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Future<void> _getContacts() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      var contacts = (await ContactsService.getContacts(withThumbnails: false));
      setState(() {
        _contactList = contacts;
      });
    } else {
      _handleInvalidPermissions(permissionStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _contactList != null
          ? ListView.builder(
              itemCount: _contactList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                Contact contact = _contactList?.elementAt(index);
                return ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(5, 2, 40, 2),
                  leading: (contact.avatar != null && contact.avatar.isNotEmpty)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),
                        )
                      : CircleAvatar(
                          child: Text(contact.initials()),
                          backgroundColor: Colors.black,
                        ),
                  title: Text(contact.displayName ?? ''),
                  onTap: () => alertDialog(context, contact),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            )),
    );
  }

  void alertDialog(BuildContext context, Contact contact) {
    var alert = AlertDialog(
        title: Text(contact.displayName),
        content: setupAlertDialogContainer(contact));
    showDialog(context: context, builder: (BuildContext context) => alert);
  }

  Widget setupAlertDialogContainer(Contact contact) {
    return Container(
      width: 200.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contact.phones.length,
        itemBuilder: (BuildContext context, int index) {
          String phone = contact.phones.elementAt(index).value;
          return ListTile(
            leading: Icon(Icons.phone),
            title: Text(phone),
            onTap: () async => await launch("tel:" + phone),
          );
        },
      ),
    );
  }
}
