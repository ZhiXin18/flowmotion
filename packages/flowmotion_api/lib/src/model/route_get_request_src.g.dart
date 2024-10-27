// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_get_request_src.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RouteGetRequestSrcKindEnum _$routeGetRequestSrcKindEnum_address =
    const RouteGetRequestSrcKindEnum._('address');
const RouteGetRequestSrcKindEnum _$routeGetRequestSrcKindEnum_location =
    const RouteGetRequestSrcKindEnum._('location');

RouteGetRequestSrcKindEnum _$routeGetRequestSrcKindEnumValueOf(String name) {
  switch (name) {
    case 'address':
      return _$routeGetRequestSrcKindEnum_address;
    case 'location':
      return _$routeGetRequestSrcKindEnum_location;
    default:
      throw new ArgumentError(name);
  }
}

final BuiltSet<RouteGetRequestSrcKindEnum> _$routeGetRequestSrcKindEnumValues =
    new BuiltSet<RouteGetRequestSrcKindEnum>(const <RouteGetRequestSrcKindEnum>[
  _$routeGetRequestSrcKindEnum_address,
  _$routeGetRequestSrcKindEnum_location,
]);

Serializer<RouteGetRequestSrcKindEnum> _$routeGetRequestSrcKindEnumSerializer =
    new _$RouteGetRequestSrcKindEnumSerializer();

class _$RouteGetRequestSrcKindEnumSerializer
    implements PrimitiveSerializer<RouteGetRequestSrcKindEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'address': 'address',
    'location': 'location',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'address': 'address',
    'location': 'location',
  };

  @override
  final Iterable<Type> types = const <Type>[RouteGetRequestSrcKindEnum];
  @override
  final String wireName = 'RouteGetRequestSrcKindEnum';

  @override
  Object serialize(Serializers serializers, RouteGetRequestSrcKindEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RouteGetRequestSrcKindEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RouteGetRequestSrcKindEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RouteGetRequestSrc extends RouteGetRequestSrc {
  @override
  final RouteGetRequestSrcKindEnum kind;
  @override
  final Address? address;
  @override
  final Location? location;

  factory _$RouteGetRequestSrc(
          [void Function(RouteGetRequestSrcBuilder)? updates]) =>
      (new RouteGetRequestSrcBuilder()..update(updates))._build();

  _$RouteGetRequestSrc._({required this.kind, this.address, this.location})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(kind, r'RouteGetRequestSrc', 'kind');
  }

  @override
  RouteGetRequestSrc rebuild(
          void Function(RouteGetRequestSrcBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RouteGetRequestSrcBuilder toBuilder() =>
      new RouteGetRequestSrcBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RouteGetRequestSrc &&
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
    return (newBuiltValueToStringHelper(r'RouteGetRequestSrc')
          ..add('kind', kind)
          ..add('address', address)
          ..add('location', location))
        .toString();
  }
}

class RouteGetRequestSrcBuilder
    implements Builder<RouteGetRequestSrc, RouteGetRequestSrcBuilder> {
  _$RouteGetRequestSrc? _$v;

  RouteGetRequestSrcKindEnum? _kind;
  RouteGetRequestSrcKindEnum? get kind => _$this._kind;
  set kind(RouteGetRequestSrcKindEnum? kind) => _$this._kind = kind;

  AddressBuilder? _address;
  AddressBuilder get address => _$this._address ??= new AddressBuilder();
  set address(AddressBuilder? address) => _$this._address = address;

  LocationBuilder? _location;
  LocationBuilder get location => _$this._location ??= new LocationBuilder();
  set location(LocationBuilder? location) => _$this._location = location;

  RouteGetRequestSrcBuilder() {
    RouteGetRequestSrc._defaults(this);
  }

  RouteGetRequestSrcBuilder get _$this {
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
  void replace(RouteGetRequestSrc other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$RouteGetRequestSrc;
  }

  @override
  void update(void Function(RouteGetRequestSrcBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RouteGetRequestSrc build() => _build();

  _$RouteGetRequestSrc _build() {
    _$RouteGetRequestSrc _$result;
    try {
      _$result = _$v ??
          new _$RouteGetRequestSrc._(
              kind: BuiltValueNullFieldError.checkNotNull(
                  kind, r'RouteGetRequestSrc', 'kind'),
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
            r'RouteGetRequestSrc', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
