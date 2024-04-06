
import 'package:flutter/foundation.dart';

import '../../features/contact/models/contact.dart';

typedef LogoutCallback = VoidCallback;

typedef DeleteAccountCallback = VoidCallback;

typedef GoBackCallback = VoidCallback;

typedef LoginFunction = void Function(
  String email,
  String password,
);

typedef RegisterFunction = void Function(
  String email,
  String password,
);

typedef CreateContactCallback = void Function(
  String firstName,
  String lastName,
  String phoneNumber,
);

typedef DeleteContactCallback = void Function(
  Contact contact,
);
