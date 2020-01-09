///
//  Generated code. Do not modify.
//  source: httpqueue.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const HttpApiQueue$json = const {
  '1': 'HttpApiQueue',
  '2': const [
    const {'1': 'queue', '3': 1, '4': 3, '5': 11, '6': '.protobufs.HttpApiQueueItem', '10': 'queue'},
  ],
};

const HttpApiQueueItem$json = const {
  '1': 'HttpApiQueueItem',
  '2': const [
    const {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.protobufs.HttpApiQueueItem.HttpApiQueueItemType', '10': 'type'},
    const {'1': 'params', '3': 2, '4': 3, '5': 11, '6': '.protobufs.HttpApiQueueItem.ParamsEntry', '10': 'params'},
  ],
  '3': const [HttpApiQueueItem_ParamsEntry$json],
  '4': const [HttpApiQueueItem_HttpApiQueueItemType$json],
};

const HttpApiQueueItem_ParamsEntry$json = const {
  '1': 'ParamsEntry',
  '2': const [
    const {'1': 'key', '3': 1, '4': 1, '5': 9, '10': 'key'},
    const {'1': 'value', '3': 2, '4': 1, '5': 9, '10': 'value'},
  ],
  '7': const {'7': true},
};

const HttpApiQueueItem_HttpApiQueueItemType$json = const {
  '1': 'HttpApiQueueItemType',
  '2': const [
    const {'1': 'NEW_JOURNAL', '2': 0},
    const {'1': 'SAVE_JOURNAL', '2': 1},
    const {'1': 'DELETE_JOURNAL', '2': 2},
  ],
};

