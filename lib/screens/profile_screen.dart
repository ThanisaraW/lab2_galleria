import 'package:flutter/material.dart';
import '../constant/app_constant.dart';

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

  const ArtToyData({
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

class ArtistProfileScreen extends StatelessWidget {
  const ArtistProfileScreen({super.key});

  final List<ArtToyData> artToys = const [
    ArtToyData(
      id: 'kuromi_rose_1',
      image: 'assets/images/dream_rosegarden/dream_rosegarden_1.jpg',
      name: 'Kuromi Rose Garden',
      artist: 'Sanrio / Central Department Store',
      favorites: 987,
      collectors: '1.2k',
      category: 'PVC Figure, Blind Box',
      description: 'Blind Box Kuromi figures in a Rose Garden setting with a gothic–romantic theme. There are 8 regular and 1 secret to collect.',
      material: 'PVC',
      height: '6.5 cm',
      edition: '8 regular + 1 secret',
      releaseYear: '2023',
      studio: 'Sanrio',
      location: 'Thailand (Central Online)',
      concept: 'Dark floral paradise with gothic Kuromi in dreamy rose garden',
      galleryImages: [
        'assets/images/dream_rosegarden/dream_rosegarden_1.jpg',
        'assets/images/dream_rosegarden/dream_rosegarden_2.jpg',
        'assets/images/dream_rosegarden/dream_rosegarden_3.jpg',
      ],
    ),
    ArtToyData(
      id: 'kuromi_witch_1',
      image: 'assets/images/witch_feast/witch_feast_1.jpg',
      name: 'Kuromi Witch\'s Feast',
      artist: 'TOPTOY Studio',
      favorites: 1450,
      collectors: '1.8k',
      category: 'Vinyl Figure, Blind Box',
      description: 'Kuromi gothic-fantasy style figures – 8 unique designs to collect, each approximately 7–9 cm tall.',
      material: 'Soft Vinyl',
      height: '7-9 cm',
      edition: 'Limited Edition',
      releaseYear: '2024',
      studio: 'TOPTOY',
      location: 'Bangkok, Thailand',
      concept: 'Gothic fantasy feast with cute yet mischievous Kuromi',
      galleryImages: [
        'assets/images/witch_feast/witch_feast_1.jpg',
        'assets/images/witch_feast/witch_feast_2.jpg',
        'assets/images/witch_feast/witch_feast_3.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Top bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                            Text(
                              "Profile", 
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.more_vert, size: 24),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Artist Avatar
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.grey[100],
                        backgroundImage: AssetImage('assets/images/avatar/profile.png'),
                        onBackgroundImageError: (exception, stackTrace) {},
                      ),
                      const SizedBox(height: 16),
                      
                      // Artist Name & Title
                      Text(
                        "Guinea P.",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      Text(
                        "Enthusiast",
                        style: TextStyle(
                          color: Colors.grey[600], 
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Bio
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          "Based in Bangkok. Love everything gothic, cute, and rebellious!",
                          style: TextStyle(
                            color: Colors.grey[700], 
                            fontSize: 14,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Stats Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatItem(count: "2", label: "Collection"),
                            _StatDivider(),
                            _StatItem(count: "3", label: "Years"),
                            _StatDivider(),
                            _StatItem(count: "12", label: "Wishlist"),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  elevation: 0,
                                ),
                                child: Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  side: BorderSide(color: Colors.grey[300]!),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                ),
                                child: Text("Share", style: TextStyle(fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey[500],
                      indicatorColor: Colors.black87,
                      indicatorWeight: 2,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                      tabs: const [
                        Tab(text: "Projects"),
                        Tab(text: "About"),
                        Tab(text: "Reviews"),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                // Projects Tab - FIXED: Proper ListView instead of GridView
                CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _ArtToyCard(artToys[index]),
                          childCount: artToys.length,
                        ),
                      ),
                    ),
                    // Add extra space at bottom
                    SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                  ],
                ),
                
                // About Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _AboutSection(
                        icon: Icons.favorite_outlined,
                        title: "Favorite Characters",
                        content: "Kuromi, My Melody, Cinnamoroll, and all Sanrio gothic-cute characters. Special love for limited editions and blind box series",
                      ),
                      SizedBox(height: 20),
                      _AboutSection(
                        icon: Icons.location_on_outlined,
                        title: "Based in",
                        content: "Bangkok, Thailand - Always hunting for rare figures at Siam Center, Central, and online stores",
                      ),
                      SizedBox(height: 20),
                      _AboutSection(
                        icon: Icons.collections_outlined,
                        title: "Collection Focus",
                        content: "Kuromi blind boxes, gothic Sanrio figures, and kawaii dark aesthetic collectibles. Love trading and sharing collection tips!",
                      ),
                      SizedBox(height: 20),
                      _AboutSection(
                        icon: Icons.shopping_bag_outlined,
                        title: "Where I Shop",
                        content: "Central Online, TOPTOY, Lazada, Shopee, and local toy stores. Always looking for good deals and authentic figures!",
                      ),
                      SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
                
                // Reviews Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _ReviewItem(
                        name: "SanrioCollector_BKK",
                        avatar: "assets/images/avatar/avatar1.png",
                        rating: 5,
                        comment: "Your Kuromi collection is absolutely stunning! I really love how you showcase and review them.",
                        date: "2 days ago",
                      ),
                      _ReviewItem(
                        name: "BlindBoxHunter",
                        avatar: "assets/images/avatar/avatar2.png",
                        rating: 5,
                        comment: "Thanks for the trading tips! Finally got my dream Kuromi figure because of your recommendation.",
                        date: "1 week ago",
                      ),
                      _ReviewItem(
                        name: "KawaiiGothic",
                        avatar: "assets/images/avatar/avatar3.png",
                        rating: 4,
                        comment: "Love your collection posts! Where did you get that rare Rose Garden Kuromi?",
                        date: "2 weeks ago",
                      ),
                      SizedBox(height: 100), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 22,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label, 
          style: TextStyle(
            color: Colors.grey[600], 
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 1,
      color: Colors.grey[200],
    );
  }
}

class _ArtToyCard extends StatelessWidget {
  final ArtToyData artToy;
  
  const _ArtToyCard(this.artToy);

  String _formatNumber(int number) {
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtToyDetailScreen(artToy: artToy),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.asset(
                      artToy.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          child: Icon(
                            Icons.toys,
                            color: Colors.grey[400],
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  // Limited badge
                  if (artToy.edition.toLowerCase().contains('limited'))
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'LIMITED',
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Heart icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Details - Simplified like Emma cards
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artToy.name, 
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
                      artToy.artist,
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
                            artToy.category.split(',')[0], // Show only first category
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          artToy.releaseYear,
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
                          '${_formatNumber(artToy.favorites)} likes',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${artToy.collectors} collectors',
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
}

// Art Toy Detail Screen remains the same
class ArtToyDetailScreen extends StatefulWidget {
  final ArtToyData artToy;

  const ArtToyDetailScreen({super.key, required this.artToy});

  @override
  State<ArtToyDetailScreen> createState() => _ArtToyDetailScreenState();
}

class _ArtToyDetailScreenState extends State<ArtToyDetailScreen> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  bool isFavorite = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header with Visible Buttons
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
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isFavorite ? 'Added to favorites!' : 'Removed from favorites!'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border, 
                        color: isFavorite ? Colors.red : Colors.white, 
                        size: 20
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Image Gallery
            Expanded(
              flex: 3,
              child: SizedBox(
                width: double.infinity,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentImageIndex = index;
                    });
                  },
                  itemCount: widget.artToy.galleryImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          widget.artToy.galleryImages[index],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.toys,
                                  color: Colors.grey[400],
                                  size: 60,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Image Indicators
            if (widget.artToy.galleryImages.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.artToy.galleryImages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentImageIndex == index 
                            ? Colors.black87 
                            : Colors.black26,
                      ),
                    ),
                  ),
                ),
              ),
            
            // Content
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Artist
                      Text(
                        widget.artToy.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.artToy.artist,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Description
                      Text(
                        widget.artToy.description,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Details Table
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildDetailRow('Material', widget.artToy.material),
                            _buildDetailRow('Height', widget.artToy.height),
                            _buildDetailRow('Edition', widget.artToy.edition),
                            _buildDetailRow('Release', widget.artToy.releaseYear),
                            _buildDetailRow('Studio', widget.artToy.studio),
                            _buildDetailRow('Location', widget.artToy.location),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Stats
                      Text(
                        '${widget.artToy.collectors} collectors • ${widget.artToy.favorites} favorites',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
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

class _AboutSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  
  const _AboutSection({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.black87, size: 22),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 6),
              Text(
                content,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final String avatar;
  final int rating;
  final String comment;
  final String date;
  
  const _ReviewItem({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[200],
                backgroundImage: AssetImage(avatar),
                onBackgroundImageError: (exception, stackTrace) {},
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) => Icon(
                  Icons.star,
                  size: 16,
                  color: index < rating ? Colors.amber : Colors.grey[300],
                )),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            comment,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}