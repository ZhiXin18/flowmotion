// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CameraLocation extends CameraLocation {
  @override
  final num longitude;
  @override
  final num latitude;

  factory _$CameraLocation([void Function(CameraLocationBuilder)? updates]) =>
      (new CameraLocationBuilder()..update(updates))._build();

  _$CameraLocation._({required this.longitude, required this.latitude})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        longitude, r'CameraLocation', 'longitude');
    BuiltValueNullFieldError.checkNotNull(
        latitude, r'CameraLocation', 'latitude');
  }

  @override
  CameraLocation rebuild(void Function(CameraLocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CameraLocationBuilder toBuilder() =>
      new CameraLocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CameraLocation &&
        longitude == other.longitude &&
        latitude == other.latitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CameraLocation')
          ..add('longitude', longitude)
          ..add('latitude', latitude))
        .toString();
  }
}

class CameraLocationBuilder
    implements Builder<CameraLocation, CameraLocationBuilder> {
  _$CameraLocation? _$v;

  num? _longitude;
  num? get longitude => _$this._longitude;
  set longitude(num? longitude) => _$this._longitude = longitude;

  num? _latitude;
  num? get latitude => _$this._latitude;
  set latitude(num? latitude) => _$this._latitude = latitude;

  CameraLocationBuilder() {
    CameraLocation._defaults(this);
  }

  CameraLocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _longitude = $v.longitude;
      _latitude = $v.latitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CameraLocation other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$CameraLocation;
  }

  @override
  void update(void Function(CameraLocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CameraLocation build() => _build();

  _$CameraLocation _build() {
    final _$result = _$v ??
        new _$CameraLocation._(
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'CameraLocation', 'longitude'),
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'CameraLocation', 'latitude'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
