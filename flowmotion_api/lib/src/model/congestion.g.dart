// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congestion.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Congestion extends Congestion {
  @override
  final Camera camera;
  @override
  final Rating rating;
  @override
  final DateTime updatedOn;

  factory _$Congestion([void Function(CongestionBuilder)? updates]) =>
      (new CongestionBuilder()..update(updates))._build();

  _$Congestion._(
      {required this.camera, required this.rating, required this.updatedOn})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(camera, r'Congestion', 'camera');
    BuiltValueNullFieldError.checkNotNull(rating, r'Congestion', 'rating');
    BuiltValueNullFieldError.checkNotNull(
        updatedOn, r'Congestion', 'updatedOn');
  }

  @override
  Congestion rebuild(void Function(CongestionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CongestionBuilder toBuilder() => new CongestionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Congestion &&
        camera == other.camera &&
        rating == other.rating &&
        updatedOn == other.updatedOn;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, camera.hashCode);
    _$hash = $jc(_$hash, rating.hashCode);
    _$hash = $jc(_$hash, updatedOn.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Congestion')
          ..add('camera', camera)
          ..add('rating', rating)
          ..add('updatedOn', updatedOn))
        .toString();
  }
}

class CongestionBuilder implements Builder<Congestion, CongestionBuilder> {
  _$Congestion? _$v;

  CameraBuilder? _camera;
  CameraBuilder get camera => _$this._camera ??= new CameraBuilder();
  set camera(CameraBuilder? camera) => _$this._camera = camera;

  RatingBuilder? _rating;
  RatingBuilder get rating => _$this._rating ??= new RatingBuilder();
  set rating(RatingBuilder? rating) => _$this._rating = rating;

  DateTime? _updatedOn;
  DateTime? get updatedOn => _$this._updatedOn;
  set updatedOn(DateTime? updatedOn) => _$this._updatedOn = updatedOn;

  CongestionBuilder() {
    Congestion._defaults(this);
  }

  CongestionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _camera = $v.camera.toBuilder();
      _rating = $v.rating.toBuilder();
      _updatedOn = $v.updatedOn;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Congestion other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Congestion;
  }

  @override
  void update(void Function(CongestionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Congestion build() => _build();

  _$Congestion _build() {
    _$Congestion _$result;
    try {
      _$result = _$v ??
          new _$Congestion._(
              camera: camera.build(),
              rating: rating.build(),
              updatedOn: BuiltValueNullFieldError.checkNotNull(
                  updatedOn, r'Congestion', 'updatedOn'));
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'camera';
        camera.build();
        _$failedField = 'rating';
        rating.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            r'Congestion', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
