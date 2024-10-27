// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get_request_dest.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteGetRequestDestKindEnum _$routeGetRequestDestKindEnum_address =
    const RouteGetRequestDestKindEnum._('address');
const RouteGetRequestDestKindEnum _$routeGetRequestDestKindEnum_location =
    const RouteGetRequestDestKindEnum._('location');

RouteGetRequestDestKindEnum _$routeGetRequestDestKindEnumValueOf(String name) {
  switch (name) {
    case 'address':
      return _$routeGetRequestDestKindEnum_address;
    case 'location':
      return _$routeGetRequestDestKindEnum_location;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RouteGetRequestDestKindEnum>
    _$routeGetRequestDestKindEnumValues = new BuiltSet<
        RouteGetRequestDestKindEnum>(const <RouteGetRequestDestKindEnum>[
  _$routeGetRequestDestKindEnum_address,
  _$routeGetRequestDestKindEnum_location,
]);

Serializer<RouteGetRequestDestKindEnum>
    _$routeGetRequestDestKindEnumSerializer =
    new _$RouteGetRequestDestKindEnumSerializer();

class _$RouteGetRequestDestKindEnumSerializer
    implements PrimitiveSerializer<RouteGetRequestDestKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'address': 'address',
    'location': 'location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'address': 'address',
    'location': 'location',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteGetRequestDestKindEnum];
  @override
  final String wireName = 'RouteGetRequestDestKindEnum';

  @override
  Object serialize(Serializers serializers, RouteGetRequestDestKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteGetRequestDestKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteGetRequestDestKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteGetRequestDest extends RouteGetRequestDest {
  @override
  final RouteGetRequestDestKindEnum? kind;
  @override
  final Address? address;
  @override
  final Location? location;

  factory _$RouteGetRequestDest(
          [void Function(RouteGetRequestDestBuilder)? updates]) =>
      (new RouteGetRequestDestBuilder()..update(updates))._build();

  _$RouteGetRequestDest._({this.kind, this.address, this.location}) : super._();

  @override
  RouteGetRequestDest rebuild(
          void Function(RouteGetRequestDestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGetRequestDestBuilder toBuilder() =>
      new RouteGetRequestDestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGetRequestDest &&
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
    return (newBuiltValueToStringHelper(r'RouteGetRequestDest')
          ..add('kind', kind)
          ..add('address', address)
          ..add('location', location))
        .toString();
  }
}

class RouteGetRequestDestBuilder
    implements Builder<RouteGetRequestDest, RouteGetRequestDestBuilder> {
  _$RouteGetRequestDest? _$v;

  RouteGetRequestDestKindEnum? _kind;
  RouteGetRequestDestKindEnum? get kind => _$this._kind;
  set kind(RouteGetRequestDestKindEnum? kind) => _$this._kind = kind;

  AddressBuilder? _address;
  AddressBuilder get address => _$this._address ??= new AddressBuilder();
  set address(AddressBuilder? address) => _$this._address = address;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RouteGetRequestDestBuilder() {
    RouteGetRequestDest._defaults(this);
  }

  RouteGetRequestDestBuilder get _$this {
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
  void replace(RouteGetRequestDest other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGetRequestDest;
  }

  @override
  void update(void Function(RouteGetRequestDestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGetRequestDest build() => _build();

  _$RouteGetRequestDest _build() {
    _$RouteGetRequestDest _$result;
    try {
      _$result = _$v ??
          new _$RouteGetRequestDest._(
              kind: kind,
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
            r'RouteGetRequestDest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
