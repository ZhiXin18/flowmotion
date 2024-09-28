class Address {
  String city;
  String countryCode;
  String postcode;
  String state;
  String street;
  bool deleted;
  DateTime? createdOn;

  Address({
    required this.city,
    required this.countryCode,
    required this.postcode,
    required this.state,
    required this.street,
    this.deleted = false,
    this.createdOn,
  });
}

class Route {
  int srcAddressIdx;
  int destAddressIdx;
  DateTime updatedOn;

  Route({
    required this.srcAddressIdx,
    required this.destAddressIdx,
    required this.updatedOn,
  });
}

class User {
  String email;
  String hashedPassword;
  List<Address> addresses;
  List<Route> routes;

  User({
    required this.email,
    required this.hashedPassword,
    required this.addresses,
    required this.routes,
  });
}
