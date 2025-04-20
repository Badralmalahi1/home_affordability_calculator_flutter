// listing_search_page.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class ListingSearchPage extends StatefulWidget {
  final double price;
  final String zip;

  const ListingSearchPage({super.key, required this.price, required this.zip});

  @override
  State<ListingSearchPage> createState() => _ListingSearchPageState();
}

class _ListingSearchPageState extends State<ListingSearchPage> {
  final TextEditingController bedsController = TextEditingController();
  final TextEditingController bathsController = TextEditingController();

  void launchZillow() {
    final beds = bedsController.text;
    final baths = bathsController.text;
    final price = widget.price.toInt();
    final zip = widget.zip;

    final zillowUrl =
        'https://www.zillow.com/homes/for_sale/$zip/?beds=$beds&baths=$baths&maxPrice=$price';

    launchUrl(Uri.parse(zillowUrl), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Listings on Zillow"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Customize your search",
              style: GoogleFonts.openSans(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: bedsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Minimum Bedrooms",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bathsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Minimum Bathrooms",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: launchZillow,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Find on Zillow"),
            )
          ],
        ),
      ),
    );
  }
}