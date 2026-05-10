import 'package:amazon/src/feature/home/widget/nav_item.dart';
import 'package:amazon/src/feature/home/widget/tabs/home_tab.dart';
import 'package:amazon/src/feature/home/widget/tabs/order_tab.dart';
import 'package:amazon/src/feature/home/widget/tabs/user_tab.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static MaterialPageRoute route() =>
      MaterialPageRoute(builder: (context) => const HomeScreen());

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;
  List<Widget> tabs = [HomeTab(), OrderTab(), UserTab()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentTab],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFF0F0F0), width: 0.5)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                NavItem(
                  icon: Icons.home,
                  index: 0,
                  currentIndex: currentTab,
                  onTap: (i) => setState(() => currentTab = i),
                ),
                NavItem(
                  icon: Icons.shopping_bag,
                  index: 1,
                  currentIndex: currentTab,
                  onTap: (i) => setState(() => currentTab = i),
                ),
                NavItem(
                  icon: Icons.person,
                  index: 2,
                  currentIndex: currentTab,
                  onTap: (i) => setState(() => currentTab = i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
