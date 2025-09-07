import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = "All";
  Set<String> favoriteProjects = {};

  final List<ArtToyData> artToys = [
    ArtToyData(
      id: 'toy_1',
      image: 'assets/images/pocket_zoo/pocket_zoo_1.jpg',
      name: 'Emma Pocket Zoo',
      artist: 'Lucky Emma Studio',
      favorites: 1245,
      collectors: '2.3k',
      category: 'Vinyl',
      description: 'Emma Pocket Zoo Series featuring adorable miniature zoo animals with Emma character in various cute animal costumes and accessories.',
      material: 'Soft Vinyl',
      height: '12 cm',
      edition: '500 pcs Limited',
      releaseYear: '2024',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Pocket Zoo',
      galleryImages: [
        'assets/images/pocket_zoo/pocket_zoo_1.jpg',
        'assets/images/pocket_zoo/pocket_zoo_2.jpg',
        'assets/images/pocket_zoo/pocket_zoo_3.jpg',
      ],
    ),
    ArtToyData(
      id: 'toy_2',
      image: 'assets/images/rua_rua_zoo/rua_rua_zoo1.jpg',
      name: 'Emma Rua Rua Zoo',
      artist: 'Lucky Emma Studio',
      favorites: 3421,
      collectors: '5.1k',
      category: 'PVC',
      description: 'Emma Rua Rua Zoo collection with zoo theme featuring Emma in various animal forms with playful designs and vibrant colors.',
      material: 'PVC',
      height: '9 cm',
      edition: 'Blind Box Series',
      releaseYear: '2024',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Zoo Adventure',
      galleryImages: [
        'assets/images/rua_rua_zoo/rua_rua_zoo1.jpg',
        'assets/images/rua_rua_zoo/rua_rua_zoo2.jpg',
        'assets/images/rua_rua_zoo/rua_rua_zoo3.jpg',
      ],
    ),
    ArtToyData(
      id: 'toy_3',
      image: 'assets/images/secret_forest/secret_forest_1.jpg',
      name: 'Emma Secret Forest',
      artist: 'Lucky Emma Studio',
      favorites: 8967,
      collectors: '12k',
      category: 'Vinyl',
      description: 'Emma Secret Forest series featuring Emma in a magical woodland setting, with whimsical outfits, forest creatures, and enchanting party themes.',
      material: 'Vinyl',
      height: '28 cm',
      edition: '1000 pcs Worldwide',
      releaseYear: '2023',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Secret Forest - Birthday Party',
      galleryImages: [
        'assets/images/secret_forest/secret_forest_1.jpg',
        'assets/images/secret_forest/secret_forest_2.jpg',
        'assets/images/secret_forest/secret_forest_3.jpg',
      ],
    ),
    ArtToyData(
      id: 'toy_4',
      image: 'assets/images/tea_party/tea_party_1.jpg',
      name: 'Emma Tea Party',
      artist: 'Lucky Emma Studio',
      favorites: 2156,
      collectors: '3.2k',
      category: 'Resin',
      description: 'Emma Tea Party collection featuring elegant afternoon tea themes with delicate sweets, teacups, and garden-inspired outfits.',
      material: 'Cast Resin',
      height: '15 cm',
      edition: '300 pcs Limited',
      releaseYear: '2024',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Party Celebration',
      galleryImages: [
        'assets/images/tea_party/tea_party_1.jpg',
        'assets/images/tea_party/tea_party_2.jpg',
        'assets/images/tea_party/tea_party_3.jpg',
      ],
    ),
    ArtToyData(
      id: 'toy_5',
      image: 'assets/images/bunny_collector/bunny_collector_1.jpg',
      name: 'Emma Bunny Collector',
      artist: 'Lucky Emma Studio',
      favorites: 4521,
      collectors: '6.8k',
      category: 'Sofubi',
      description: 'Emma Daily Life series showcasing Emma in everyday scenarios with casual outfits and lifestyle accessories.',
      material: 'Sofubi',
      height: '8 cm',
      edition: 'Open Edition',
      releaseYear: '2024',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Daily Life',
      galleryImages: [
        'assets/images/bunny_collector/bunny_collector_1.jpg',
        'assets/images/bunny_collector/bunny_collector_2.jpg',
        'assets/images/bunny_collector/bunny_collector_3.jpg',
      ],
    ),
    ArtToyData(
      id: 'toy_6',
      image: 'assets/images/beloved/beloved_1.jpg',
      name: 'Emma Beloved Series',
      artist: 'Lucky Emma Studio',
      favorites: 1876,
      collectors: '4.1k',
      category: 'PVC',
      description: 'Emma Forest Friends collection featuring woodland creatures with Emma in nature-inspired outfits and forest accessories.',
      material: 'PVC + Metal',
      height: '20 cm',
      edition: '777 pcs Limited',
      releaseYear: '2023',
      studio: 'Yanchuang Culture',
      location: 'Shenzhen, China',
      concept: 'Forest Adventure',
      galleryImages: [
        'assets/images/beloved/beloved_1.jpg',
        'assets/images/beloved/beloved_2.jpg',
        'assets/images/beloved/beloved_3.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Simplified Header
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: _buildSimpleHeader(),
              ),
            ),
            
            // Categories
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCategoryTabs(),
              ),
            ),
            
            // Art Toys Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              sliver: _buildArtToysSliver(),
            ),
            
            // Bottom Spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "EMMA GALLERY",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Lucky Emma Studio Collections",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.pink.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.toys,
                  color: Colors.pink,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              "Discover Emma collections from Yanchuang Culture",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ["All", "Vinyl", "PVC", "Resin", "Sofubi"];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Browse by Material",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 45,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = selectedCategory == category;
              
              return Padding(
                padding: EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? Colors.pink : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtToysSliver() {
    List<ArtToyData> filteredToys = artToys;
    if (selectedCategory != "All") {
      filteredToys = artToys.where((toy) => 
        toy.category == selectedCategory
      ).toList();
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final toy = filteredToys[index];
          final isFavorite = favoriteProjects.contains(toy.id);
          
          return _SimpleArtToyCard(
            toy: toy,
            isFavorite: isFavorite,
            onFavoriteTap: () {
              setState(() {
                if (isFavorite) {
                  favoriteProjects.remove(toy.id);
                } else {
                  favoriteProjects.add(toy.id);
                }
              });
            },
            onToyTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtToyDetailPage(toy: toy),
                ),
              );
            },
          );
        },
        childCount: filteredToys.length,
      ),
    );
  }
}

class _SimpleArtToyCard extends StatelessWidget {
  final ArtToyData toy;
  final bool isFavorite;
  final VoidCallback onFavoriteTap;
  final VoidCallback onToyTap;

  const _SimpleArtToyCard({
    required this.toy,
    required this.isFavorite,
    required this.onFavoriteTap,
    required this.onToyTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToyTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    toy.image,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[100],
                        child: const Center(
                          child: Icon(Icons.toys, color: Colors.grey, size: 40),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavoriteTap,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (toy.edition.contains('Limited'))
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'LIMITED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            
            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      toy.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      toy.artist,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            toy.category,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          toy.releaseYear,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_formatNumber(toy.favorites)} likes',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${toy.collectors} collectors',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}

// Keep all existing classes: ArtToyData, ArtToyDetailPage, etc.
class ArtToyData {
  final String id;
  final String image;
  final String name;
  final String artist;
  final int favorites;
  final String collectors;
  final String category;
  final String description;
  final String material;
  final String height;
  final String edition;
  final String releaseYear;
  final String studio;
  final String location;
  final String concept;
  final List<String> galleryImages;

  ArtToyData({
    required this.id,
    required this.image,
    required this.name,
    required this.artist,
    required this.favorites,
    required this.collectors,
    required this.category,
    required this.description,
    required this.material,
    required this.height,
    required this.edition,
    required this.releaseYear,
    required this.studio,
    required this.location,
    required this.concept,
    required this.galleryImages,
  });
}

class ArtToyDetailPage extends StatefulWidget {
  final ArtToyData toy;

  const ArtToyDetailPage({super.key, required this.toy});

  @override
  State<ArtToyDetailPage> createState() => _ArtToyDetailPageState();
}

class _ArtToyDetailPageState extends State<ArtToyDetailPage> {
  PageController pageController = PageController();
  int currentImageIndex = 0;
  bool isFollowing = false;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Simplified Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to wishlist!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            
            // Image Gallery
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                itemCount: widget.toy.galleryImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        widget.toy.galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.toys, color: Colors.white, size: 60),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Simple Image Indicators
            if (widget.toy.galleryImages.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.toy.galleryImages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: currentImageIndex == index ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
              ),
            
            // Clean Details Section
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.toy.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.toy.artist,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        widget.toy.description,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Clean Details Table
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('Material', widget.toy.material),
                            _buildDetailRow('Height', widget.toy.height),
                            _buildDetailRow('Edition', widget.toy.edition),
                            _buildDetailRow('Release', widget.toy.releaseYear),
                            _buildDetailRow('Studio', widget.toy.studio),
                            _buildDetailRow('Location', widget.toy.location),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      Text(
                        '${widget.toy.collectors} collectors • ${widget.toy.favorites} favorites',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing ? Colors.grey[300] : Colors.pink,
                            foregroundColor: isFollowing ? Colors.black87 : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              isFollowing = !isFollowing;
                            });
                          },
                          child: Text(isFollowing ? "Following" : "Follow Artist"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}