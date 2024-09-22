const appThemeMode = "APP_THEME_MODE";
const dbFileName = "journal_app.sqlite";
const dbExportName = "journal_app.db.json";

const String googleSignInClientIdFromEnv = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID',
    defaultValue: "GOOGLE_SIGNIN_CLIENT_ID");

// In env where we don't override above value, google sign in client id is null
String? googleSignInClientId =
    googleSignInClientIdFromEnv == "GOOGLE_SIGNIN_CLIENT_ID"
        ? null
        : googleSignInClientIdFromEnv;
