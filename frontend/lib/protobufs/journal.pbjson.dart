///
//  Generated code. Do not modify.
//  source: journal.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Journal$json = const {
  '1': 'Journal',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    const {'1': 'user_id', '3': 2, '4': 1, '5': 3, '10': 'userId'},
    const {'1': 'save_type', '3': 3, '4': 1, '5': 14, '6': '.protobufs.Journal.JournalSaveType', '10': 'saveType'},
    const {'1': 'content', '3': 4, '4': 1, '5': 9, '10': 'content'},
    const {'1': 'created_at', '3': 5, '4': 1, '5': 3, '10': 'createdAt'},
    const {'1': 'updated_at', '3': 6, '4': 1, '5': 3, '10': 'updatedAt'},
  ],
  '4': const [Journal_JournalSaveType$json],
};

const Journal_JournalSaveType$json = const {
  '1': 'JournalSaveType',
  '2': const [
    const {'1': 'LOCAL', '2': 0},
    const {'1': 'PLAINTEXT', '2': 1},
    const {'1': 'ENCRYPTED', '2': 2},
  ],
};

const JournalResponse$json = const {
  '1': 'JournalResponse',
  '2': const [
    const {'1': 'total', '3': 1, '4': 1, '5': 3, '10': 'total'},
    const {'1': 'size', '3': 2, '4': 1, '5': 3, '10': 'size'},
    const {'1': 'journals', '3': 3, '4': 3, '5': 11, '6': '.protobufs.Journal', '10': 'journals'},
  ],
};

