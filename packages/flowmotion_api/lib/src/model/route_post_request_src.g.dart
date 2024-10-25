// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post_request_src.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePostRequestSrc extends RoutePostRequestSrc {
  @override
  final Address? kind;
  @override
  final Location? location;

  factory _$RoutePostRequestSrc(
          [void Function(RoutePostRequestSrcBuilder)? updates]) =>
      (new RoutePostRequestSrcBuilder()..update(updates))._build();

  _$RoutePostRequestSrc._({this.kind, this.location}) : super._();

  @override
  RoutePostRequestSrc rebuild(
          void Function(RoutePostRequestSrcBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePostRequestSrcBuilder toBuilder() =>
      new RoutePostRequestSrcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePostRequestSrc &&
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
    return (newBuiltValueToStringHelper(r'RoutePostRequestSrc')
          ..add('kind', kind)
          ..add('location', location))
        .toString();
  }
}

class RoutePostRequestSrcBuilder
    implements Builder<RoutePostRequestSrc, RoutePostRequestSrcBuilder> {
  _$RoutePostRequestSrc? _$v;

  AddressBuilder? _kind;
  AddressBuilder get kind => _$this._kind ??= new AddressBuilder();
  set kind(AddressBuilder? kind) => _$this._kind = kind;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RoutePostRequestSrcBuilder() {
    RoutePostRequestSrc._defaults(this);
  }

  RoutePostRequestSrcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind?.toBuilder();
      _location = $v.location?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePostRequestSrc other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePostRequestSrc;
  }

  @override
  void update(void Function(RoutePostRequestSrcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePostRequestSrc build() => _build();

  _$RoutePostRequestSrc _build() {
    _$RoutePostRequestSrc _$result;
    try {
      _$result = _$v ??
          new _$RoutePostRequestSrc._(
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
            r'RoutePostRequestSrc', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
