const appThemeMode = "APP_THEME_MODE";
const appColorSeed = "APP_COLOR_SEED";

const hiddenLockedMode = "HIDDEN_LOCKED_MODE";
final pinKey = "PIN";
const backupEncryptionStatus = "BACKUP_ENCYRYPTION_STATUS";
const backupEncryptionKey = "BACKUP_ENCYRYPTION_KEY";
const dbFileName = "journal_app.sqlite";
const dbExportJsonName = "journal_app.db.json";
const dbExportArchiveName = "journal_app.db.zip";
const dbLastUpdatedName = "journal_app.last_updated_date.txt";

const String googleSignInClientIdFromEnv = String.fromEnvironment(
    'GOOGLE_SIGNIN_CLIENT_ID',
    defaultValue: "GOOGLE_SIGNIN_CLIENT_ID");

// In env where we don't override above value, google sign in client id is null
String? googleSignInClientId =
    googleSignInClientIdFromEnv == "GOOGLE_SIGNIN_CLIENT_ID"
        ? null
        : googleSignInClientIdFromEnv;

const String recaptchaSiteKeyFromEnv = String.fromEnvironment(
    'RECAPTCHA_SITE_KEY',
    defaultValue: "RECAPTCHA_SITE_KEY");

// In env where we don't override above value, google sign in client id is null
String? recaptchaSiteKey = recaptchaSiteKeyFromEnv == "RECAPTCHA_SITE_KEY"
    ? null
    : recaptchaSiteKeyFromEnv;
