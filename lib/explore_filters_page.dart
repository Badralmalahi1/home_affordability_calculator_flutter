import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreFiltersPage extends StatefulWidget {
  final int maxPrice;
  final String zipCode;

  const ExploreFiltersPage({
    super.key,
    required this.maxPrice,
    required this.zipCode,
  });

  @override
  State<ExploreFiltersPage> createState() => _ExploreFiltersPageState();
}

class _ExploreFiltersPageState extends State<ExploreFiltersPage> {
  final TextEditingController bedsController = TextEditingController();
  final TextEditingController bathsController = TextEditingController();

  void searchZillow() {
    final beds = bedsController.text;
    final baths = bathsController.text;

    if (beds.isEmpty || baths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both bedrooms and bathrooms")),
      );
      return;
    }

    final zip = widget.zipCode;
    final price = widget.maxPrice;

    final url =
        "https://www.zillow.com/homes/for_sale/${zip}_rb/?searchQueryState=%7B%22filterState%22:%7B%22price%22:%7B%22max%22:$price%7D,%22beds%22:%7B%22min%22:$beds%7D,%22baths%22:%7B%22min%22:$baths%7D%7D%7D";

    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Explore Listings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      "Apply Filters",
                      style: GoogleFonts.openSans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: bedsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Number of Bedrooms"),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: bathsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Number of Bathrooms"),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: searchZillow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF800000),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      ),
                      child: const Text("Search on Zillow"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
