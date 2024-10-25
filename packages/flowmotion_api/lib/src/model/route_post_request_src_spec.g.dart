// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post_request_src_spec.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePostRequestSrcSpec extends RoutePostRequestSrcSpec {
  @override
  final OneOf oneOf;

  factory _$RoutePostRequestSrcSpec(
          [void Function(RoutePostRequestSrcSpecBuilder)? updates]) =>
      (new RoutePostRequestSrcSpecBuilder()..update(updates))._build();

  _$RoutePostRequestSrcSpec._({required this.oneOf}) : super._() {
    BuiltValueNullFieldError.checkNotNull(
        oneOf, r'RoutePostRequestSrcSpec', 'oneOf');
  }

  @override
  RoutePostRequestSrcSpec rebuild(
          void Function(RoutePostRequestSrcSpecBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePostRequestSrcSpecBuilder toBuilder() =>
      new RoutePostRequestSrcSpecBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePostRequestSrcSpec && oneOf == other.oneOf;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, oneOf.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoutePostRequestSrcSpec')
          ..add('oneOf', oneOf))
        .toString();
  }
}

class RoutePostRequestSrcSpecBuilder
    implements
        Builder<RoutePostRequestSrcSpec, RoutePostRequestSrcSpecBuilder> {
  _$RoutePostRequestSrcSpec? _$v;

  OneOf? _oneOf;
  OneOf? get oneOf => _$this._oneOf;
  set oneOf(OneOf? oneOf) => _$this._oneOf = oneOf;

  RoutePostRequestSrcSpecBuilder() {
    RoutePostRequestSrcSpec._defaults(this);
  }

  RoutePostRequestSrcSpecBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _oneOf = $v.oneOf;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePostRequestSrcSpec other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePostRequestSrcSpec;
  }

  @override
  void update(void Function(RoutePostRequestSrcSpecBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePostRequestSrcSpec build() => _build();

  _$RoutePostRequestSrcSpec _build() {
    final _$result = _$v ??
        new _$RoutePostRequestSrcSpec._(
            oneOf: BuiltValueNullFieldError.checkNotNull(
                oneOf, r'RoutePostRequestSrcSpec', 'oneOf'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
