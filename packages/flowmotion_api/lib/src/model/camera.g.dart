// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Camera extends Camera {
  @override
  final String id;
  @override
  final DateTime capturedOn;
  @override
  final DateTime retrievedOn;
  @override
  final CameraLocation location;

  factory _$Camera([void Function(CameraBuilder)? updates]) =>
      (new CameraBuilder()..update(updates))._build();

  _$Camera._(
      {required this.id,
      required this.capturedOn,
      required this.retrievedOn,
      required this.location})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Camera', 'id');
    BuiltValueNullFieldError.checkNotNull(capturedOn, r'Camera', 'capturedOn');
    BuiltValueNullFieldError.checkNotNull(
        retrievedOn, r'Camera', 'retrievedOn');
    BuiltValueNullFieldError.checkNotNull(location, r'Camera', 'location');
  }

  @override
  Camera rebuild(void Function(CameraBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CameraBuilder toBuilder() => new CameraBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Camera &&
        id == other.id &&
        capturedOn == other.capturedOn &&
        retrievedOn == other.retrievedOn &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, capturedOn.hashCode);
    _$hash = $jc(_$hash, retrievedOn.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Camera')
          ..add('id', id)
          ..add('capturedOn', capturedOn)
          ..add('retrievedOn', retrievedOn)
          ..add('location', location))
        .toString();
  }
}

class CameraBuilder implements Builder<Camera, CameraBuilder> {
  _$Camera? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _capturedOn;
  DateTime? get capturedOn => _$this._capturedOn;
  set capturedOn(DateTime? capturedOn) => _$this._capturedOn = capturedOn;

  DateTime? _retrievedOn;
  DateTime? get retrievedOn => _$this._retrievedOn;
  set retrievedOn(DateTime? retrievedOn) => _$this._retrievedOn = retrievedOn;

  CameraLocationBuilder? _location;
  CameraLocationBuilder get location =>
      _$this._location ??= new CameraLocationBuilder();
  set location(CameraLocationBuilder? location) => _$this._location = location;

  CameraBuilder() {
    Camera._defaults(this);
  }

  CameraBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _capturedOn = $v.capturedOn;
      _retrievedOn = $v.retrievedOn;
      _location = $v.location.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Camera other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Camera;
  }

  @override
  void update(void Function(CameraBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Camera build() => _build();

  _$Camera _build() {
    _$Camera _$result;
    try {
      _$result = _$v ??
          new _$Camera._(
              id: BuiltValueNullFieldError.checkNotNull(id, r'Camera', 'id'),
              capturedOn: BuiltValueNullFieldError.checkNotNull(
                  capturedOn, r'Camera', 'capturedOn'),
              retrievedOn: BuiltValueNullFieldError.checkNotNull(
                  retrievedOn, r'Camera', 'retrievedOn'),
              location: location.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'location';
        location.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Camera', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
