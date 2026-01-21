import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirsak_pop_nasabah/features/drop_point/drop_point_view.dart';
import 'package:sirsak_pop_nasabah/features/home/home_content.dart';
import 'package:sirsak_pop_nasabah/features/profile/profile_view.dart';
import 'package:sirsak_pop_nasabah/features/wallet/wallet_view.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_provider.dart';
import 'package:sirsak_pop_nasabah/shared/navigation/bottom_nav_widget.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(bottomNavProvider).selectedIndex;

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          HomeContent(), // 0 - Home
          DropPointView(), // 1 - Drop Point
          SizedBox(), // 2 - QR Scan (empty)
          WalletView(), // 3 - Wallet
          ProfileView(), // 4 - Profile
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(),
    );
  }
}
