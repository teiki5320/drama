import 'package:flutter/material.dart';

import '../../core/colors.dart';
import 'achats_tab.dart';
import 'compte_tab.dart';
import 'investissement_tab.dart';

class BanqueScreen extends StatefulWidget {
  const BanqueScreen({super.key});

  @override
  State<BanqueScreen> createState() => _BanqueScreenState();
}

class _BanqueScreenState extends State<BanqueScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banque'),
        bottom: TabBar(
          controller: _tab,
          labelColor: AppColors.accentOrange,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.accentOrange,
          tabs: const [
            Tab(text: 'Compte'),
            Tab(text: 'Investissement'),
            Tab(text: 'Achats'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [
          CompteTab(),
          InvestissementTab(),
          AchatsTab(),
        ],
      ),
    );
  }
}
