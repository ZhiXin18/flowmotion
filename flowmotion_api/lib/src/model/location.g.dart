// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Location extends Location {
  @override
  final double latitude;
  @override
  final double longitude;

  factory _$Location([void Function(LocationBuilder)? updates]) =>
      (new LocationBuilder()..update(updates))._build();

  _$Location._({required this.latitude, required this.longitude}) : super._() {
    BuiltValueNullFieldError.checkNotNull(latitude, r'Location', 'latitude');
    BuiltValueNullFieldError.checkNotNull(longitude, r'Location', 'longitude');
  }

  @override
  Location rebuild(void Function(LocationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LocationBuilder toBuilder() => new LocationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Location &&
        latitude == other.latitude &&
        longitude == other.longitude;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, latitude.hashCode);
    _$hash = $jc(_$hash, longitude.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Location')
          ..add('latitude', latitude)
          ..add('longitude', longitude))
        .toString();
  }
}

class LocationBuilder implements Builder<Location, LocationBuilder> {
  _$Location? _$v;

  double? _latitude;
  double? get latitude => _$this._latitude;
  set latitude(double? latitude) => _$this._latitude = latitude;

  double? _longitude;
  double? get longitude => _$this._longitude;
  set longitude(double? longitude) => _$this._longitude = longitude;

  LocationBuilder() {
    Location._defaults(this);
  }

  LocationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _latitude = $v.latitude;
      _longitude = $v.longitude;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Location other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Location;
  }

  @override
  void update(void Function(LocationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Location build() => _build();

  _$Location _build() {
    final _$result = _$v ??
        new _$Location._(
            latitude: BuiltValueNullFieldError.checkNotNull(
                latitude, r'Location', 'latitude'),
            longitude: BuiltValueNullFieldError.checkNotNull(
                longitude, r'Location', 'longitude'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
