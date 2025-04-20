import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'home_affordability_profile.dart';
import 'history_manager.dart';
import 'history_page.dart';
import 'explore_filters_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Affordability Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.openSansTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF800000), // ✅ Maroon
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),
      home: const HomeAffordabilityPage(),
    );
  }
}

class HomeAffordabilityPage extends StatefulWidget {
  const HomeAffordabilityPage({super.key});

  @override
  State<HomeAffordabilityPage> createState() => _HomeAffordabilityPageState();
}

class _HomeAffordabilityPageState extends State<HomeAffordabilityPage> {
  final incomeController = TextEditingController();
  final debtController = TextEditingController();
  final downPaymentController = TextEditingController();
  final zipCodeController = TextEditingController();

  double? minPrice;
  double? maxPrice;
  String? userZip;

  void calculateAffordability() async {
    final income = double.tryParse(incomeController.text);
    final debt = double.tryParse(debtController.text);
    final downPayment = double.tryParse(downPaymentController.text);
    final zipCode = zipCodeController.text.trim();

    if (income == null || debt == null || downPayment == null || zipCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter all fields."), backgroundColor: Colors.red),
      );
      return;
    }

    final profile = HomeAffordabilityProfile(
      income: income,
      debt: debt,
      downPayment: downPayment,
      zipCode: zipCode,
    );

    await HistoryManager.saveProfile(profile);

    setState(() {
      minPrice = profile.conservativePrice;
      maxPrice = profile.flexiblePrice;
      userZip = zipCode;
    });
  }

  void goToZillowFilters() {
    if (maxPrice != null && userZip != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreFiltersPage(
            maxPrice: maxPrice!.toInt(),
            zipCode: userZip!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: "\$");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Home Affordability Calculator"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'history', child: Text('View History')),
            ],
          )
        ],
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
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: incomeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monthly Income (\$)'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: debtController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Monthly Debt (\$)'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: downPaymentController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Down Payment (\$)'),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: zipCodeController,
                        decoration: const InputDecoration(labelText: 'ZIP Code'),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: calculateAffordability,
                        child: const Text("Calculate"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                if (minPrice != null && maxPrice != null)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: 1.0,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            minPrice == 0
                                ? 'You are not financially stable to look for homes over \$30k.'
                                : 'Estimated Range: ${currency.format(minPrice)} - ${currency.format(maxPrice)}',
                            style: TextStyle(
                              fontSize: 18,
                              color: minPrice == 0 ? Colors.red : Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: minPrice == 0 ? null : goToZillowFilters,
                          icon: const Icon(Icons.house_outlined),
                          label: const Text("Explore Listings"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF800000), // ✅ Maroon
                            foregroundColor: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
