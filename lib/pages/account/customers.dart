class Customers {
  final String? customers_id;
  final String customers_name;
  final String customers_phone;
  final String customers_email;
  final String customersProfileImage;
  final String customer_address;
  final String address;
  final String status;
  final String lat;
  final String lng;
  final String earnings;

  Customers(
    this.customer_address,
    this.address,
    this.status,
    this.lat,
    this.lng,
    this.earnings, {
    this.customers_id,
    required this.customers_name,
    required this.customers_phone,
    required this.customers_email,
    required this.customersProfileImage,
  });

  toJson() {
    return {
      'user_name': customers_name,
      'user_phone': customers_phone,
      'user_email': customers_email,
      'userProfileImage': customersProfileImage,
    };
  }
}
