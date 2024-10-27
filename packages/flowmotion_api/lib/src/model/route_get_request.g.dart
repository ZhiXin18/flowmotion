// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteGetRequest extends RouteGetRequest {
  @override
  final RouteGetRequestSrc? src;
  @override
  final RouteGetRequestDest? dest;

  factory _$RouteGetRequest([void Function(RouteGetRequestBuilder)? updates]) =>
      (new RouteGetRequestBuilder()..update(updates))._build();

  _$RouteGetRequest._({this.src, this.dest}) : super._();

  @override
  RouteGetRequest rebuild(void Function(RouteGetRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGetRequestBuilder toBuilder() =>
      new RouteGetRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGetRequest && src == other.src && dest == other.dest;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, src.hashCode);
    _$hash = $jc(_$hash, dest.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteGetRequest')
          ..add('src', src)
          ..add('dest', dest))
        .toString();
  }
}

class RouteGetRequestBuilder
    implements Builder<RouteGetRequest, RouteGetRequestBuilder> {
  _$RouteGetRequest? _$v;

  RouteGetRequestSrcBuilder? _src;
  RouteGetRequestSrcBuilder get src =>
      _$this._src ??= new RouteGetRequestSrcBuilder();
  set src(RouteGetRequestSrcBuilder? src) => _$this._src = src;

  RouteGetRequestDestBuilder? _dest;
  RouteGetRequestDestBuilder get dest =>
      _$this._dest ??= new RouteGetRequestDestBuilder();
  set dest(RouteGetRequestDestBuilder? dest) => _$this._dest = dest;

  RouteGetRequestBuilder() {
    RouteGetRequest._defaults(this);
  }

  RouteGetRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _src = $v.src?.toBuilder();
      _dest = $v.dest?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteGetRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGetRequest;
  }

  @override
  void update(void Function(RouteGetRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGetRequest build() => _build();

  _$RouteGetRequest _build() {
    _$RouteGetRequest _$result;
    try {
      _$result = _$v ??
          new _$RouteGetRequest._(src: _src?.build(), dest: _dest?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'src';
        _src?.build();
        _$failedField = 'dest';
        _dest?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RouteGetRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
