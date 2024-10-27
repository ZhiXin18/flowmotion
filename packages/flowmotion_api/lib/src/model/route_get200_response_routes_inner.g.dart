// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get200_response_routes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RouteGet200ResponseRoutesInner extends RouteGet200ResponseRoutesInner {
  @override
  final String? geometry;
  @override
  final double? duration;
  @override
  final double? distance;
  @override
  final BuiltList<RouteGet200ResponseRoutesInnerStepsInner>? steps;

  factory _$RouteGet200ResponseRoutesInner(
          [void Function(RouteGet200ResponseRoutesInnerBuilder)? updates]) =>
      (new RouteGet200ResponseRoutesInnerBuilder()..update(updates))._build();

  _$RouteGet200ResponseRoutesInner._(
      {this.geometry, this.duration, this.distance, this.steps})
      : super._();

  @override
  RouteGet200ResponseRoutesInner rebuild(
          void Function(RouteGet200ResponseRoutesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGet200ResponseRoutesInnerBuilder toBuilder() =>
      new RouteGet200ResponseRoutesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGet200ResponseRoutesInner &&
        geometry == other.geometry &&
        duration == other.duration &&
        distance == other.distance &&
        steps == other.steps;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, geometry.hashCode);
    _$hash = $jc(_$hash, duration.hashCode);
    _$hash = $jc(_$hash, distance.hashCode);
    _$hash = $jc(_$hash, steps.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RouteGet200ResponseRoutesInner')
          ..add('geometry', geometry)
          ..add('duration', duration)
          ..add('distance', distance)
          ..add('steps', steps))
        .toString();
  }
}

class RouteGet200ResponseRoutesInnerBuilder
    implements
        Builder<RouteGet200ResponseRoutesInner,
            RouteGet200ResponseRoutesInnerBuilder> {
  _$RouteGet200ResponseRoutesInner? _$v;

  String? _geometry;
  String? get geometry => _$this._geometry;
  set geometry(String? geometry) => _$this._geometry = geometry;

  double? _duration;
  double? get duration => _$this._duration;
  set duration(double? duration) => _$this._duration = duration;

  double? _distance;
  double? get distance => _$this._distance;
  set distance(double? distance) => _$this._distance = distance;

  ListBuilder<RouteGet200ResponseRoutesInnerStepsInner>? _steps;
  ListBuilder<RouteGet200ResponseRoutesInnerStepsInner> get steps =>
      _$this._steps ??=
          new ListBuilder<RouteGet200ResponseRoutesInnerStepsInner>();
  set steps(ListBuilder<RouteGet200ResponseRoutesInnerStepsInner>? steps) =>
      _$this._steps = steps;

  RouteGet200ResponseRoutesInnerBuilder() {
    RouteGet200ResponseRoutesInner._defaults(this);
  }

  RouteGet200ResponseRoutesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _geometry = $v.geometry;
      _duration = $v.duration;
      _distance = $v.distance;
      _steps = $v.steps?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RouteGet200ResponseRoutesInner other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGet200ResponseRoutesInner;
  }

  @override
  void update(void Function(RouteGet200ResponseRoutesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGet200ResponseRoutesInner build() => _build();

  _$RouteGet200ResponseRoutesInner _build() {
    _$RouteGet200ResponseRoutesInner _$result;
    try {
      _$result = _$v ??
          new _$RouteGet200ResponseRoutesInner._(
              geometry: geometry,
              duration: duration,
              distance: distance,
              steps: _steps?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        _steps?.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RouteGet200ResponseRoutesInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
