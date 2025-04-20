import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home_affordability_profile.dart';
import 'history_manager.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HomeAffordabilityProfile> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() async {
    final data = await HistoryManager.loadHistory();
    setState(() {
      history = data;
    });
  }

  void _clearHistory() async {
    await HistoryManager.clearHistory();
    setState(() {
      history.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("History cleared.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(symbol: "\$");

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Recent History"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear History',
            onPressed: _clearHistory,
          ),
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
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: history.isEmpty
                ? const Center(
                    child: Text(
                      "No recent history.",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final profile = history[index];
                      return Card(
                        color: Colors.white.withOpacity(0.95),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            '${currency.format(profile.conservativePrice)} - ${currency.format(profile.flexiblePrice)}',
                            style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('ZIP: ${profile.zipCode} | Income: \$${profile.income.toStringAsFixed(0)}'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
