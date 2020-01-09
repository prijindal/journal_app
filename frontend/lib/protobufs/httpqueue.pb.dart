///
//  Generated code. Do not modify.
//  source: httpqueue.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'httpqueue.pbenum.dart';

export 'httpqueue.pbenum.dart';

class HttpApiQueue extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HttpApiQueue', package: const $pb.PackageName('protobufs'), createEmptyInstance: create)
    ..pc<HttpApiQueueItem>(1, 'queue', $pb.PbFieldType.PM, subBuilder: HttpApiQueueItem.create)
    ..hasRequiredFields = false
  ;

  HttpApiQueue._() : super();
  factory HttpApiQueue() => create();
  factory HttpApiQueue.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HttpApiQueue.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  HttpApiQueue clone() => HttpApiQueue()..mergeFromMessage(this);
  HttpApiQueue copyWith(void Function(HttpApiQueue) updates) => super.copyWith((message) => updates(message as HttpApiQueue));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HttpApiQueue create() => HttpApiQueue._();
  HttpApiQueue createEmptyInstance() => create();
  static $pb.PbList<HttpApiQueue> createRepeated() => $pb.PbList<HttpApiQueue>();
  @$core.pragma('dart2js:noInline')
  static HttpApiQueue getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HttpApiQueue>(create);
  static HttpApiQueue _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<HttpApiQueueItem> get queue => $_getList(0);
}

class HttpApiQueueItem extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('HttpApiQueueItem', package: const $pb.PackageName('protobufs'), createEmptyInstance: create)
    ..e<HttpApiQueueItem_HttpApiQueueItemType>(1, 'type', $pb.PbFieldType.OE, defaultOrMaker: HttpApiQueueItem_HttpApiQueueItemType.NEW_JOURNAL, valueOf: HttpApiQueueItem_HttpApiQueueItemType.valueOf, enumValues: HttpApiQueueItem_HttpApiQueueItemType.values)
    ..m<$core.String, $core.String>(2, 'params', entryClassName: 'HttpApiQueueItem.ParamsEntry', keyFieldType: $pb.PbFieldType.OS, valueFieldType: $pb.PbFieldType.OS, packageName: const $pb.PackageName('protobufs'))
    ..hasRequiredFields = false
  ;

  HttpApiQueueItem._() : super();
  factory HttpApiQueueItem() => create();
  factory HttpApiQueueItem.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HttpApiQueueItem.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  HttpApiQueueItem clone() => HttpApiQueueItem()..mergeFromMessage(this);
  HttpApiQueueItem copyWith(void Function(HttpApiQueueItem) updates) => super.copyWith((message) => updates(message as HttpApiQueueItem));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static HttpApiQueueItem create() => HttpApiQueueItem._();
  HttpApiQueueItem createEmptyInstance() => create();
  static $pb.PbList<HttpApiQueueItem> createRepeated() => $pb.PbList<HttpApiQueueItem>();
  @$core.pragma('dart2js:noInline')
  static HttpApiQueueItem getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HttpApiQueueItem>(create);
  static HttpApiQueueItem _defaultInstance;

  @$pb.TagNumber(1)
  HttpApiQueueItem_HttpApiQueueItemType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(HttpApiQueueItem_HttpApiQueueItemType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.Map<$core.String, $core.String> get params => $_getMap(1);
}

