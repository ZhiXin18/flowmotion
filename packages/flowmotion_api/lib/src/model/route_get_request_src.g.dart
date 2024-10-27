// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get_request_src.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteGetRequestSrc extends RouteGetRequestSrc {
  @override
  final Address? kind;
  @override
  final Location? location;

  factory _$RouteGetRequestSrc(
          [void Function(RouteGetRequestSrcBuilder)? updates]) =>
      (new RouteGetRequestSrcBuilder()..update(updates))._build();

  _$RouteGetRequestSrc._({this.kind, this.location}) : super._();

  @override
  RouteGetRequestSrc rebuild(
          void Function(RouteGetRequestSrcBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGetRequestSrcBuilder toBuilder() =>
      new RouteGetRequestSrcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGetRequestSrc &&
        kind == other.kind &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteGetRequestSrc')
          ..add('kind', kind)
          ..add('location', location))
        .toString();
  }
}

class RouteGetRequestSrcBuilder
    implements Builder<RouteGetRequestSrc, RouteGetRequestSrcBuilder> {
  _$RouteGetRequestSrc? _$v;

  AddressBuilder? _kind;
  AddressBuilder get kind => _$this._kind ??= new AddressBuilder();
  set kind(AddressBuilder? kind) => _$this._kind = kind;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RouteGetRequestSrcBuilder() {
    RouteGetRequestSrc._defaults(this);
  }

  RouteGetRequestSrcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind?.toBuilder();
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteGetRequestSrc other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGetRequestSrc;
  }

  @override
  void update(void Function(RouteGetRequestSrcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGetRequestSrc build() => _build();

  _$RouteGetRequestSrc _build() {
    _$RouteGetRequestSrc _$result;
    try {
      _$result = _$v ??
          new _$RouteGetRequestSrc._(
              kind: _kind?.build(), location: _location?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'kind';
        _kind?.build();
        _$failedField = 'location';
        _location?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RouteGetRequestSrc', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
