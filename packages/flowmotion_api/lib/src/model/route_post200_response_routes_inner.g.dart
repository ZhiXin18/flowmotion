// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post200_response_routes_inner.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$RoutePost200ResponseRoutesInner
    extends RoutePost200ResponseRoutesInner {
  @override
  final String geometry;
  @override
  final double duration;
  @override
  final double distance;
  @override
  final BuiltList<RoutePost200ResponseRoutesInnerStepsInner> steps;

  factory _$RoutePost200ResponseRoutesInner(
          [void Function(RoutePost200ResponseRoutesInnerBuilder)? updates]) =>
      (new RoutePost200ResponseRoutesInnerBuilder()..update(updates))._build();

  _$RoutePost200ResponseRoutesInner._(
      {required this.geometry,
      required this.duration,
      required this.distance,
      required this.steps})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        geometry, r'RoutePost200ResponseRoutesInner', 'geometry');
    BuiltValueNullFieldError.checkNotNull(
        duration, r'RoutePost200ResponseRoutesInner', 'duration');
    BuiltValueNullFieldError.checkNotNull(
        distance, r'RoutePost200ResponseRoutesInner', 'distance');
    BuiltValueNullFieldError.checkNotNull(
        steps, r'RoutePost200ResponseRoutesInner', 'steps');
  }

  @override
  RoutePost200ResponseRoutesInner rebuild(
          void Function(RoutePost200ResponseRoutesInnerBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePost200ResponseRoutesInnerBuilder toBuilder() =>
      new RoutePost200ResponseRoutesInnerBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePost200ResponseRoutesInner &&
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
    return (newBuiltValueToStringHelper(r'RoutePost200ResponseRoutesInner')
          ..add('geometry', geometry)
          ..add('duration', duration)
          ..add('distance', distance)
          ..add('steps', steps))
        .toString();
  }
}

class RoutePost200ResponseRoutesInnerBuilder
    implements
        Builder<RoutePost200ResponseRoutesInner,
            RoutePost200ResponseRoutesInnerBuilder> {
  _$RoutePost200ResponseRoutesInner? _$v;

  String? _geometry;
  String? get geometry => _$this._geometry;
  set geometry(String? geometry) => _$this._geometry = geometry;

  double? _duration;
  double? get duration => _$this._duration;
  set duration(double? duration) => _$this._duration = duration;

  double? _distance;
  double? get distance => _$this._distance;
  set distance(double? distance) => _$this._distance = distance;

  ListBuilder<RoutePost200ResponseRoutesInnerStepsInner>? _steps;
  ListBuilder<RoutePost200ResponseRoutesInnerStepsInner> get steps =>
      _$this._steps ??=
          new ListBuilder<RoutePost200ResponseRoutesInnerStepsInner>();
  set steps(ListBuilder<RoutePost200ResponseRoutesInnerStepsInner>? steps) =>
      _$this._steps = steps;

  RoutePost200ResponseRoutesInnerBuilder() {
    RoutePost200ResponseRoutesInner._defaults(this);
  }

  RoutePost200ResponseRoutesInnerBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _geometry = $v.geometry;
      _duration = $v.duration;
      _distance = $v.distance;
      _steps = $v.steps.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RoutePost200ResponseRoutesInner other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePost200ResponseRoutesInner;
  }

  @override
  void update(void Function(RoutePost200ResponseRoutesInnerBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePost200ResponseRoutesInner build() => _build();

  _$RoutePost200ResponseRoutesInner _build() {
    _$RoutePost200ResponseRoutesInner _$result;
    try {
      _$result = _$v ??
          new _$RoutePost200ResponseRoutesInner._(
              geometry: BuiltValueNullFieldError.checkNotNull(
                  geometry, r'RoutePost200ResponseRoutesInner', 'geometry'),
              duration: BuiltValueNullFieldError.checkNotNull(
                  duration, r'RoutePost200ResponseRoutesInner', 'duration'),
              distance: BuiltValueNullFieldError.checkNotNull(
                  distance, r'RoutePost200ResponseRoutesInner', 'distance'),
              steps: steps.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'steps';
        steps.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'RoutePost200ResponseRoutesInner', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
