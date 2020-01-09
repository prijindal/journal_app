///
//  Generated code. Do not modify.
//  source: httpqueue.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' as $core;
import 'package:protobuf/protobuf.dart' as $pb;

class HttpApiQueueItem_HttpApiQueueItemType extends $pb.ProtobufEnum {
  static const HttpApiQueueItem_HttpApiQueueItemType NEW_JOURNAL = HttpApiQueueItem_HttpApiQueueItemType._(0, 'NEW_JOURNAL');
  static const HttpApiQueueItem_HttpApiQueueItemType SAVE_JOURNAL = HttpApiQueueItem_HttpApiQueueItemType._(1, 'SAVE_JOURNAL');
  static const HttpApiQueueItem_HttpApiQueueItemType DELETE_JOURNAL = HttpApiQueueItem_HttpApiQueueItemType._(2, 'DELETE_JOURNAL');

  static const $core.List<HttpApiQueueItem_HttpApiQueueItemType> values = <HttpApiQueueItem_HttpApiQueueItemType> [
    NEW_JOURNAL,
    SAVE_JOURNAL,
    DELETE_JOURNAL,
  ];

  static final $core.Map<$core.int, HttpApiQueueItem_HttpApiQueueItemType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static HttpApiQueueItem_HttpApiQueueItemType valueOf($core.int value) => _byValue[value];

  const HttpApiQueueItem_HttpApiQueueItemType._($core.int v, $core.String n) : super(v, n);
}

