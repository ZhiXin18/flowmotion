// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get200_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteGet200Response extends RouteGet200Response {
  @override
  final BuiltList<RouteGet200ResponseRoutesInner>? routes;

  factory _$RouteGet200Response(
          [void Function(RouteGet200ResponseBuilder)? updates]) =>
      (new RouteGet200ResponseBuilder()..update(updates))._build();

  _$RouteGet200Response._({this.routes}) : super._();

  @override
  RouteGet200Response rebuild(
          void Function(RouteGet200ResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGet200ResponseBuilder toBuilder() =>
      new RouteGet200ResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGet200Response && routes == other.routes;
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
    return (newBuiltValueToStringHelper(r'RouteGet200Response')
          ..add('routes', routes))
        .toString();
  }
}

class RouteGet200ResponseBuilder
    implements Builder<RouteGet200Response, RouteGet200ResponseBuilder> {
  _$RouteGet200Response? _$v;

  ListBuilder<RouteGet200ResponseRoutesInner>? _routes;
  ListBuilder<RouteGet200ResponseRoutesInner> get routes =>
      _$this._routes ??= new ListBuilder<RouteGet200ResponseRoutesInner>();
  set routes(ListBuilder<RouteGet200ResponseRoutesInner>? routes) =>
      _$this._routes = routes;

  RouteGet200ResponseBuilder() {
    RouteGet200Response._defaults(this);
  }

  RouteGet200ResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _routes = $v.routes?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteGet200Response other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGet200Response;
  }

  @override
  void update(void Function(RouteGet200ResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGet200Response build() => _build();

  _$RouteGet200Response _build() {
    _$RouteGet200Response _$result;
    try {
      _$result = _$v ?? new _$RouteGet200Response._(routes: _routes?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'routes';
        _routes?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RouteGet200Response', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
