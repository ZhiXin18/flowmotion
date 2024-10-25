// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Rating extends Rating {
  @override
  final DateTime ratedOn;
  @override
  final String modelId;
  @override
  final num value;

  factory _$Rating([void Function(RatingBuilder)? updates]) =>
      (new RatingBuilder()..update(updates))._build();

  _$Rating._(
      {required this.ratedOn, required this.modelId, required this.value})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(ratedOn, r'Rating', 'ratedOn');
    BuiltValueNullFieldError.checkNotNull(modelId, r'Rating', 'modelId');
    BuiltValueNullFieldError.checkNotNull(value, r'Rating', 'value');
  }

  @override
  Rating rebuild(void Function(RatingBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RatingBuilder toBuilder() => new RatingBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Rating &&
        ratedOn == other.ratedOn &&
        modelId == other.modelId &&
        value == other.value;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, ratedOn.hashCode);
    _$hash = $jc(_$hash, modelId.hashCode);
    _$hash = $jc(_$hash, value.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Rating')
          ..add('ratedOn', ratedOn)
          ..add('modelId', modelId)
          ..add('value', value))
        .toString();
  }
}

class RatingBuilder implements Builder<Rating, RatingBuilder> {
  _$Rating? _$v;

  DateTime? _ratedOn;
  DateTime? get ratedOn => _$this._ratedOn;
  set ratedOn(DateTime? ratedOn) => _$this._ratedOn = ratedOn;

  String? _modelId;
  String? get modelId => _$this._modelId;
  set modelId(String? modelId) => _$this._modelId = modelId;

  num? _value;
  num? get value => _$this._value;
  set value(num? value) => _$this._value = value;

  RatingBuilder() {
    Rating._defaults(this);
  }

  RatingBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _ratedOn = $v.ratedOn;
      _modelId = $v.modelId;
      _value = $v.value;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Rating other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Rating;
  }

  @override
  void update(void Function(RatingBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Rating build() => _build();

  _$Rating _build() {
    final _$result = _$v ??
        new _$Rating._(
            ratedOn: BuiltValueNullFieldError.checkNotNull(
                ratedOn, r'Rating', 'ratedOn'),
            modelId: BuiltValueNullFieldError.checkNotNull(
                modelId, r'Rating', 'modelId'),
            value: BuiltValueNullFieldError.checkNotNull(
                value, r'Rating', 'value'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
