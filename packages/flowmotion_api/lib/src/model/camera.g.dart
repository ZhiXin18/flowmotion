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
  final String imageUrl;
  @override
  final DateTime retrievedOn;
  @override
  final Location location;

  factory _$Camera([void Function(CameraBuilder)? updates]) =>
      (new CameraBuilder()..update(updates))._build();

  _$Camera._(
      {required this.id,
      required this.capturedOn,
      required this.imageUrl,
      required this.retrievedOn,
      required this.location})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'Camera', 'id');
    BuiltValueNullFieldError.checkNotNull(capturedOn, r'Camera', 'capturedOn');
    BuiltValueNullFieldError.checkNotNull(imageUrl, r'Camera', 'imageUrl');
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
        imageUrl == other.imageUrl &&
        retrievedOn == other.retrievedOn &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, capturedOn.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
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
          ..add('imageUrl', imageUrl)
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

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  DateTime? _retrievedOn;
  DateTime? get retrievedOn => _$this._retrievedOn;
  set retrievedOn(DateTime? retrievedOn) => _$this._retrievedOn = retrievedOn;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  CameraBuilder() {
    Camera._defaults(this);
  }

  CameraBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _capturedOn = $v.capturedOn;
      _imageUrl = $v.imageUrl;
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
              imageUrl: BuiltValueNullFieldError.checkNotNull(
                  imageUrl, r'Camera', 'imageUrl'),
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
