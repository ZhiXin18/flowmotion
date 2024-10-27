// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_post_request_dest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RoutePostRequestDestKindEnum _$routePostRequestDestKindEnum_address =
    const RoutePostRequestDestKindEnum._('address');
const RoutePostRequestDestKindEnum _$routePostRequestDestKindEnum_location =
    const RoutePostRequestDestKindEnum._('location');

RoutePostRequestDestKindEnum _$routePostRequestDestKindEnumValueOf(
    String name) {
  switch (name) {
    case 'address':
      return _$routePostRequestDestKindEnum_address;
    case 'location':
      return _$routePostRequestDestKindEnum_location;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RoutePostRequestDestKindEnum>
    _$routePostRequestDestKindEnumValues = new BuiltSet<
        RoutePostRequestDestKindEnum>(const <RoutePostRequestDestKindEnum>[
  _$routePostRequestDestKindEnum_address,
  _$routePostRequestDestKindEnum_location,
]);

Serializer<RoutePostRequestDestKindEnum>
    _$routePostRequestDestKindEnumSerializer =
    new _$RoutePostRequestDestKindEnumSerializer();

class _$RoutePostRequestDestKindEnumSerializer
    implements PrimitiveSerializer<RoutePostRequestDestKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'address': 'address',
    'location': 'location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'address': 'address',
    'location': 'location',
  };

  @override
  final Iterable<Type> types = const <Type>[RoutePostRequestDestKindEnum];
  @override
  final String wireName = 'RoutePostRequestDestKindEnum';

  @override
  Object serialize(Serializers serializers, RoutePostRequestDestKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RoutePostRequestDestKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RoutePostRequestDestKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RoutePostRequestDest extends RoutePostRequestDest {
  @override
  final RoutePostRequestDestKindEnum kind;
  @override
  final Address? address;
  @override
  final Location? location;

  factory _$RoutePostRequestDest(
          [void Function(RoutePostRequestDestBuilder)? updates]) =>
      (new RoutePostRequestDestBuilder()..update(updates))._build();

  _$RoutePostRequestDest._({required this.kind, this.address, this.location})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        kind, r'RoutePostRequestDest', 'kind');
  }

  @override
  RoutePostRequestDest rebuild(
          void Function(RoutePostRequestDestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RoutePostRequestDestBuilder toBuilder() =>
      new RoutePostRequestDestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RoutePostRequestDest &&
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
    return (newBuiltValueToStringHelper(r'RoutePostRequestDest')
          ..add('kind', kind)
          ..add('address', address)
          ..add('location', location))
        .toString();
  }
}

class RoutePostRequestDestBuilder
    implements Builder<RoutePostRequestDest, RoutePostRequestDestBuilder> {
  _$RoutePostRequestDest? _$v;

  RoutePostRequestDestKindEnum? _kind;
  RoutePostRequestDestKindEnum? get kind => _$this._kind;
  set kind(RoutePostRequestDestKindEnum? kind) => _$this._kind = kind;

  AddressBuilder? _address;
  AddressBuilder get address => _$this._address ??= new AddressBuilder();
  set address(AddressBuilder? address) => _$this._address = address;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RoutePostRequestDestBuilder() {
    RoutePostRequestDest._defaults(this);
  }

  RoutePostRequestDestBuilder get _$this {
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
  void replace(RoutePostRequestDest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RoutePostRequestDest;
  }

  @override
  void update(void Function(RoutePostRequestDestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RoutePostRequestDest build() => _build();

  _$RoutePostRequestDest _build() {
    _$RoutePostRequestDest _$result;
    try {
      _$result = _$v ??
          new _$RoutePostRequestDest._(
              kind: BuiltValueNullFieldError.checkNotNull(
                  kind, r'RoutePostRequestDest', 'kind'),
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
            r'RoutePostRequestDest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
