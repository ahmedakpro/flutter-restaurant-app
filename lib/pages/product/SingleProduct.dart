class SingleProduct {
  final String pro_id;
  final String pro_image;
  final String pro_name;
  final String pro_description;
  final int pro_price;
  final String cat_id;

  int quantity;

  SingleProduct({
    required this.pro_id,
    required this.pro_image,
    required this.pro_name,
    required this.pro_description,
    required this.pro_price,
    required this.cat_id,
    required this.quantity,
  });
}
