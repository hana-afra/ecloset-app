class Product {
  final String Id;
  final String name;
  final double price;
  final String imagePath;
  final String ownerId;
  final String ownerName;
  final String ownerPhone;
  final String ownerProfilePicture;
  final String wilaya;
  final String size;
  final String description;
  final String commune;
  final String category;
  final String type;
  bool isFavorite;

  Product({
    required this.Id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.ownerId,
    required this.ownerName,
    required this.ownerPhone,
    required this.ownerProfilePicture,
    required this.wilaya,
    required this.size,
    required this.description,
    required this.commune,
    required this.category,
    required this.type,
    required this.isFavorite,
  });

  static fromJson(item) {}
}