import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/select_contacts_repo.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository = ref.watch(selectContactRepositoryProvider);
    return selectContactRepository.getContacts();
  },
);

final selectContactControllerProvider = Provider(
  (ref) {
    final selectContactRepository = ref.watch(selectContactRepositoryProvider);
    return SelectContactController(
      ref: ref,
      selectContactRepository: selectContactRepository,
    );
  },
);

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) async {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
