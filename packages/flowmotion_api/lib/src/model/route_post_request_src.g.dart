// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post_request_src.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RoutePostRequestSrcKindEnum _$routePostRequestSrcKindEnum_address =
    const RoutePostRequestSrcKindEnum._('address');
const RoutePostRequestSrcKindEnum _$routePostRequestSrcKindEnum_location =
    const RoutePostRequestSrcKindEnum._('location');

RoutePostRequestSrcKindEnum _$routePostRequestSrcKindEnumValueOf(String name) {
  switch (name) {
    case 'address':
      return _$routePostRequestSrcKindEnum_address;
    case 'location':
      return _$routePostRequestSrcKindEnum_location;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RoutePostRequestSrcKindEnum>
    _$routePostRequestSrcKindEnumValues = new BuiltSet<
        RoutePostRequestSrcKindEnum>(const <RoutePostRequestSrcKindEnum>[
  _$routePostRequestSrcKindEnum_address,
  _$routePostRequestSrcKindEnum_location,
]);

Serializer<RoutePostRequestSrcKindEnum>
    _$routePostRequestSrcKindEnumSerializer =
    new _$RoutePostRequestSrcKindEnumSerializer();

class _$RoutePostRequestSrcKindEnumSerializer
    implements PrimitiveSerializer<RoutePostRequestSrcKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'address': 'address',
    'location': 'location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'address': 'address',
    'location': 'location',
  };

  @override
  final Iterable<Type> types = const <Type>[RoutePostRequestSrcKindEnum];
  @override
  final String wireName = 'RoutePostRequestSrcKindEnum';

  @override
  Object serialize(Serializers serializers, RoutePostRequestSrcKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RoutePostRequestSrcKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RoutePostRequestSrcKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RoutePostRequestSrc extends RoutePostRequestSrc {
  @override
  final RoutePostRequestSrcKindEnum kind;
  @override
  final Address? address;
  @override
  final Location? location;

  factory _$RoutePostRequestSrc(
          [void Function(RoutePostRequestSrcBuilder)? updates]) =>
      (new RoutePostRequestSrcBuilder()..update(updates))._build();

  _$RoutePostRequestSrc._({required this.kind, this.address, this.location})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(kind, r'RoutePostRequestSrc', 'kind');
  }

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
        address == other.address &&
        location == other.location;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, kind.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, location.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RoutePostRequestSrc')
          ..add('kind', kind)
          ..add('address', address)
          ..add('location', location))
        .toString();
  }
}

class RoutePostRequestSrcBuilder
    implements Builder<RoutePostRequestSrc, RoutePostRequestSrcBuilder> {
  _$RoutePostRequestSrc? _$v;

  RoutePostRequestSrcKindEnum? _kind;
  RoutePostRequestSrcKindEnum? get kind => _$this._kind;
  set kind(RoutePostRequestSrcKindEnum? kind) => _$this._kind = kind;

  AddressBuilder? _address;
  AddressBuilder get address => _$this._address ??= new AddressBuilder();
  set address(AddressBuilder? address) => _$this._address = address;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RoutePostRequestSrcBuilder() {
    RoutePostRequestSrc._defaults(this);
  }

  RoutePostRequestSrcBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _kind = $v.kind;
      _address = $v.address?.toBuilder();
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
              kind: BuiltValueNullFieldError.checkNotNull(
                  kind, r'RoutePostRequestSrc', 'kind'),
              address: _address?.build(),
              location: _location?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'address';
        _address?.build();
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
