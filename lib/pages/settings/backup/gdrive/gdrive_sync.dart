import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';

import '../../../../helpers/constants.dart';

final googleSignIn = GoogleSignIn(
  clientId: googleSignInClientId,
  scopes: [
    DriveApi.driveAppdataScope,
  ],
);
