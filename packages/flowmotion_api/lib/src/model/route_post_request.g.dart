// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePostRequest extends RoutePostRequest {
  @override
  final RoutePostRequestSrc? src;
  @override
  final RoutePostRequestDest? dest;

  factory _$RoutePostRequest(
          [void Function(RoutePostRequestBuilder)? updates]) =>
      (new RoutePostRequestBuilder()..update(updates))._build();

  _$RoutePostRequest._({this.src, this.dest}) : super._();

  @override
  RoutePostRequest rebuild(void Function(RoutePostRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePostRequestBuilder toBuilder() =>
      new RoutePostRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePostRequest && src == other.src && dest == other.dest;
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
    return (newBuiltValueToStringHelper(r'RoutePostRequest')
          ..add('src', src)
          ..add('dest', dest))
        .toString();
  }
}

class RoutePostRequestBuilder
    implements Builder<RoutePostRequest, RoutePostRequestBuilder> {
  _$RoutePostRequest? _$v;

  RoutePostRequestSrcBuilder? _src;
  RoutePostRequestSrcBuilder get src =>
      _$this._src ??= new RoutePostRequestSrcBuilder();
  set src(RoutePostRequestSrcBuilder? src) => _$this._src = src;

  RoutePostRequestDestBuilder? _dest;
  RoutePostRequestDestBuilder get dest =>
      _$this._dest ??= new RoutePostRequestDestBuilder();
  set dest(RoutePostRequestDestBuilder? dest) => _$this._dest = dest;

  RoutePostRequestBuilder() {
    RoutePostRequest._defaults(this);
  }

  RoutePostRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _src = $v.src?.toBuilder();
      _dest = $v.dest?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePostRequest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePostRequest;
  }

  @override
  void update(void Function(RoutePostRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePostRequest build() => _build();

  _$RoutePostRequest _build() {
    _$RoutePostRequest _$result;
    try {
      _$result = _$v ??
          new _$RoutePostRequest._(src: _src?.build(), dest: _dest?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'src';
        _src?.build();
        _$failedField = 'dest';
        _dest?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RoutePostRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
