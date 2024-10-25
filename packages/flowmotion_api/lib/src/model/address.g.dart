// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Address extends Address {
  @override
  final String text;
  @override
  final String postcode;

  factory _$Address([void Function(AddressBuilder)? updates]) =>
      (new AddressBuilder()..update(updates))._build();

  _$Address._({required this.text, required this.postcode}) : super._() {
    BuiltValueNullFieldError.checkNotNull(text, r'Address', 'text');
    BuiltValueNullFieldError.checkNotNull(postcode, r'Address', 'postcode');
  }

  @override
  Address rebuild(void Function(AddressBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AddressBuilder toBuilder() => new AddressBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Address && text == other.text && postcode == other.postcode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, postcode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Address')
          ..add('text', text)
          ..add('postcode', postcode))
        .toString();
  }
}

class AddressBuilder implements Builder<Address, AddressBuilder> {
  _$Address? _$v;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _postcode;
  String? get postcode => _$this._postcode;
  set postcode(String? postcode) => _$this._postcode = postcode;

  AddressBuilder() {
    Address._defaults(this);
  }

  AddressBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _text = $v.text;
      _postcode = $v.postcode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Address other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Address;
  }

  @override
  void update(void Function(AddressBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Address build() => _build();

  _$Address _build() {
    final _$result = _$v ??
        new _$Address._(
            text:
                BuiltValueNullFieldError.checkNotNull(text, r'Address', 'text'),
            postcode: BuiltValueNullFieldError.checkNotNull(
                postcode, r'Address', 'postcode'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
