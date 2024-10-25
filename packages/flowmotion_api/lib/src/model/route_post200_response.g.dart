// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePost200Response extends RoutePost200Response {
  @override
  final BuiltList<RoutePost200ResponseRoutesInner>? routes;

  factory _$RoutePost200Response(
          [void Function(RoutePost200ResponseBuilder)? updates]) =>
      (new RoutePost200ResponseBuilder()..update(updates))._build();

  _$RoutePost200Response._({this.routes}) : super._();

  @override
  RoutePost200Response rebuild(
          void Function(RoutePost200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePost200ResponseBuilder toBuilder() =>
      new RoutePost200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePost200Response && routes == other.routes;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, routes.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoutePost200Response')
          ..add('routes', routes))
        .toString();
  }
}

class RoutePost200ResponseBuilder
    implements Builder<RoutePost200Response, RoutePost200ResponseBuilder> {
  _$RoutePost200Response? _$v;

  ListBuilder<RoutePost200ResponseRoutesInner>? _routes;
  ListBuilder<RoutePost200ResponseRoutesInner> get routes =>
      _$this._routes ??= new ListBuilder<RoutePost200ResponseRoutesInner>();
  set routes(ListBuilder<RoutePost200ResponseRoutesInner>? routes) =>
      _$this._routes = routes;

  RoutePost200ResponseBuilder() {
    RoutePost200Response._defaults(this);
  }

  RoutePost200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routes = $v.routes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePost200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePost200Response;
  }

  @override
  void update(void Function(RoutePost200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePost200Response build() => _build();

  _$RoutePost200Response _build() {
    _$RoutePost200Response _$result;
    try {
      _$result = _$v ?? new _$RoutePost200Response._(routes: _routes?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routes';
        _routes?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RoutePost200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
