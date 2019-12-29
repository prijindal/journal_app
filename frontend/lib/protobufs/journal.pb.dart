///
//  Generated code. Do not modify.
//  source: journal.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'journal.pbenum.dart';

export 'journal.pbenum.dart';

class Journal extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Journal', package: const $pb.PackageName('protobufs'), createEmptyInstance: create)
    ..aInt64(1, 'id')
    ..aInt64(2, 'userId')
    ..e<Journal_JournalSaveType>(3, 'saveType', $pb.PbFieldType.OE, defaultOrMaker: Journal_JournalSaveType.LOCAL, valueOf: Journal_JournalSaveType.valueOf, enumValues: Journal_JournalSaveType.values)
    ..aOS(4, 'content')
    ..aInt64(5, 'createdAt')
    ..aInt64(6, 'updatedAt')
    ..hasRequiredFields = false
  ;

  Journal._() : super();
  factory Journal() => create();
  factory Journal.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Journal.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Journal clone() => Journal()..mergeFromMessage(this);
  Journal copyWith(void Function(Journal) updates) => super.copyWith((message) => updates(message as Journal));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Journal create() => Journal._();
  Journal createEmptyInstance() => create();
  static $pb.PbList<Journal> createRepeated() => $pb.PbList<Journal>();
  @$core.pragma('dart2js:noInline')
  static Journal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Journal>(create);
  static Journal _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userId => $_getI64(1);
  @$pb.TagNumber(2)
  set userId($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserId() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserId() => clearField(2);

  @$pb.TagNumber(3)
  Journal_JournalSaveType get saveType => $_getN(2);
  @$pb.TagNumber(3)
  set saveType(Journal_JournalSaveType v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSaveType() => $_has(2);
  @$pb.TagNumber(3)
  void clearSaveType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get createdAt => $_getI64(4);
  @$pb.TagNumber(5)
  set createdAt($fixnum.Int64 v) { $_setInt64(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreatedAt() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreatedAt() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get updatedAt => $_getI64(5);
  @$pb.TagNumber(6)
  set updatedAt($fixnum.Int64 v) { $_setInt64(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasUpdatedAt() => $_has(5);
  @$pb.TagNumber(6)
  void clearUpdatedAt() => clearField(6);
}

class JournalResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('JournalResponse', package: const $pb.PackageName('protobufs'), createEmptyInstance: create)
    ..aInt64(1, 'total')
    ..aInt64(2, 'size')
    ..pc<Journal>(3, 'journals', $pb.PbFieldType.PM, subBuilder: Journal.create)
    ..hasRequiredFields = false
  ;

  JournalResponse._() : super();
  factory JournalResponse() => create();
  factory JournalResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory JournalResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  JournalResponse clone() => JournalResponse()..mergeFromMessage(this);
  JournalResponse copyWith(void Function(JournalResponse) updates) => super.copyWith((message) => updates(message as JournalResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static JournalResponse create() => JournalResponse._();
  JournalResponse createEmptyInstance() => create();
  static $pb.PbList<JournalResponse> createRepeated() => $pb.PbList<JournalResponse>();
  @$core.pragma('dart2js:noInline')
  static JournalResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<JournalResponse>(create);
  static JournalResponse _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get total => $_getI64(0);
  @$pb.TagNumber(1)
  set total($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTotal() => $_has(0);
  @$pb.TagNumber(1)
  void clearTotal() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get size => $_getI64(1);
  @$pb.TagNumber(2)
  set size($fixnum.Int64 v) { $_setInt64(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSize() => $_has(1);
  @$pb.TagNumber(2)
  void clearSize() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<Journal> get journals => $_getList(2);
}

