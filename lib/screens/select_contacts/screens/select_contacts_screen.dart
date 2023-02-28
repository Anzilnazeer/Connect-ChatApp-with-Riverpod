import 'package:connect_riverpod/constants/colors.dart';
import 'package:connect_riverpod/screens/select_contacts/repository/select_contacts_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/widgets/error.dart';

import '../controller/select_contact_control.dart';

class SelectContactScreen extends ConsumerStatefulWidget {
  static const String routeName = '/select-contact';
  const SelectContactScreen({super.key});

  @override
  ConsumerState<SelectContactScreen> createState() =>
      _SelectContactScreenState();
}

class _SelectContactScreenState extends ConsumerState<SelectContactScreen> {
  void selectContact(
      WidgetRef ref, Contact selectedContact, BuildContext context) {
    ref.read(selectContactControllerProvider).selectContact(
          selectedContact,
          context,
        );
  }

  List<Contact> searchList = [];
  bool isSearching = false;

  void runFilter(String keyword) {
    List<Contact> results = [];
    if (keyword.isEmpty) {
      results = contacts;
    } else {
      results = contacts
          .where((Contact item) =>
              item.displayName.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }
    setState(() {
      searchList = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scafoldcolor,
      appBar: AppBar(
        toolbarHeight: 80,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                    hintText: 'search contact', border: InputBorder.none),
                onChanged: (value) {
                  searchList.clear();
                  for (var i in contacts) {
                    if (i.displayName
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      searchList.add(i);
                    }
                    setState(() {
                      searchList;
                    });
                  }
                },
              )
            : Text(
                'select contacts',
                style: GoogleFonts.poppins(color: textColor, fontSize: 20),
              ),
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              FontAwesomeIcons.angleLeft,
              color: buttonColor,
              size: 20,
            )),
        backgroundColor: scafoldcolor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
              icon: Icon(
                isSearching
                    ? FontAwesomeIcons.ban
                    : FontAwesomeIcons.magnifyingGlass,
                color: textColor,
                size: 20,
              ))
        ],
      ),
      body: ref.watch(getContactsProvider).when(
            data: (contactList) => ListView.builder(
              itemCount: isSearching ? searchList.length : contactList.length,
              itemBuilder: ((context, index) {
                final contact = contactList[index];
                return InkWell(
                  onTap: () => selectContact(ref, contact, context),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      tileColor: const Color.fromARGB(35, 48, 136, 244),
                      title: Text(contact.displayName,
                          style: GoogleFonts.poppins(fontSize: 19)),
                      leading: contact.photo == null
                          ? const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://static.toiimg.com/thumb/resizemode-4,msid-76729750,imgsize-249247,width-720/76729750.jpg'),
                              radius: 25,
                            )
                          : CircleAvatar(
                              backgroundImage: MemoryImage(contact.photo!),
                              radius: 30,
                            ),
                      trailing: Text(
                        contact.phones[0].number,
                        style: GoogleFonts.aBeeZee(),
                      ),
                    ),
                  ),
                );
              }),
            ),
            error: (err, trace) => ErrorScreen(error: err.toString()),
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
    );
  }
}
