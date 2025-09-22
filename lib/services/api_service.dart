import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  // Change this based on your setup:
  // For localhost testing: 'http://localhost:3000'
  // For Android emulator: 'http://10.0.2.2:3000'
  // For iOS simulator: 'http://127.0.0.1:3000'  
  // For real device: 'http://YOUR_COMPUTER_IP:3000'
  static const String baseUrl = 'http://10.0.2.2:3000';

  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  Future<Product> getProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Product.fromJson(jsonData);
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to server: $e');
    }
  }

  // Mock data สำหรับการทดสอบ (Gallery/Art Collections)
  static List<Product> getMockProducts() {
    return [
      Product(
        id: 1,
        name: 'Beloved Art Collection',
        price: 299.99,
        detail: 'A beautiful collection of romantic and heartwarming artwork featuring tender moments and emotional connections. Perfect for creating an intimate atmosphere in any space.',
        images: [
          'assets/images/beloved/beloved_1.jpg',
          'assets/images/beloved/beloved_2.jpg',
          'assets/images/beloved/beloved_3.jpg',
        ],
      ),
      Product(
        id: 2,
        name: 'Bunny Collector Series',
        price: 199.99,
        detail: 'Adorable collection featuring cute bunny characters in various poses and settings. Ideal for children\'s rooms or anyone who loves whimsical art.',
        images: [
          'assets/images/bunny_collector/bunny_collector_1.jpg',
          'assets/images/bunny_collector/bunny_collector_2.jpg',
          'assets/images/bunny_collector/bunny_collector_3.jpg',
        ],
      ),
      Product(
        id: 3,
        name: 'Pocket Zoo Adventures',
        price: 249.99,
        detail: 'Charming wildlife art collection showcasing various animals in their natural habitats. Educational and entertaining for all ages.',
        images: [
          'assets/images/pocket_zoo/pocket_zoo_1.jpg',
          'assets/images/pocket_zoo/pocket_zoo_2.jpg',
          'assets/images/pocket_zoo/pocket_zoo_3.jpg',
        ],
      ),
      Product(
        id: 4,
        name: 'Rua Rua Zoo Collection',
        price: 179.99,
        detail: 'Playful and colorful zoo-themed artwork featuring friendly animals and vibrant scenes. Great for brightening up any living space.',
        images: [
          'assets/images/rua_rua_zoo/rua_rua_zoo1.jpg',
          'assets/images/rua_rua_zoo/rua_rua_zoo2.jpg',
          'assets/images/rua_rua_zoo/rua_rua_zoo3.jpg',
        ],
      ),
      Product(
        id: 5,
        name: 'Secret Forest Mystery',
        price: 329.99,
        detail: 'Enchanting forest scenes with hidden mysteries and magical elements. Perfect for those who love fantasy and nature-inspired art.',
        images: [
          'assets/images/secret_forest/secret_forest_1.jpg',
          'assets/images/secret_forest/secret_forest_2.jpg',
          'assets/images/secret_forest/secret_forest_3.jpg',
        ],
      ),
      Product(
        id: 6,
        name: 'Elegant Tea Party',
        price: 219.99,
        detail: 'Sophisticated tea party scenes with vintage charm and elegant details. Ideal for adding refinement to dining areas or living rooms.',
        images: [
          'assets/images/tea_party/tea_party_1.jpg',
          'assets/images/tea_party/tea_party_2.jpg',
          'assets/images/tea_party/tea_party_3.jpg',
        ],
      ),
      Product(
        id: 7,
        name: 'Dream Rose Garden',
        price: 289.99,
        detail: 'Beautiful rose garden artwork with dreamy, romantic atmosphere. Features blooming roses in various colors and garden settings.',
        images: [
          'assets/images/dream_rosegarden/dream_rosegarden_1.jpg',
          'assets/images/dream_rosegarden/dream_rosegarden_2.jpg',
          'assets/images/dream_rosegarden/dream_rosegarden_3.jpg',
        ],
      ),
      Product(
        id: 8,
        name: 'Witch Feast Collection',
        price: 259.99,
        detail: 'Mystical and magical artwork featuring witches, spells, and enchanted feasts. Perfect for Halloween decorations or gothic art enthusiasts.',
        images: [
          'assets/images/witch_feast/witch_feast_1.jpg',
          'assets/images/witch_feast/witch_feast_2.jpg',
          'assets/images/witch_feast/witch_feast_3.jpg',
        ],
      ),
    ];
  }
}