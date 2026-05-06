import 'package:amazon/src/constants/global_variables.dart';
import 'package:amazon/src/feature/auth/screen/auth_screen.dart';
import 'package:amazon/src/feature/auth/services/auth_cubit.dart';
import 'package:amazon/src/feature/auth/services/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: GlobalVariables.secondaryColor,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          if (state is AuthLoggedIn) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildGreetingSection(user),
                  const SizedBox(height: 15),
                  _buildQuickActionGrid(),
                  const SizedBox(height: 15),
                  const Divider(thickness: 5, color: Colors.black12),
                  _buildAccountSettingsList(),
                  const Divider(thickness: 5, color: Colors.black12),
                  _buildLogoutSection(),
                ],
              ),
            );
          }
          // Fallback state if the user is not logged in or data is loading
          return _buildUnauthenticatedState();
        },
      ),
    );
  }

  Widget _buildUnauthenticatedState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.account_circle_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            const Text(
              'Sign in for the best experience',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Manage your orders, track shipments, and securely save your payment info.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(AuthScreen.route());
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor:
                    Colors.orange.shade400, // E-commerce primary button style
                foregroundColor: Colors.black,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // UI Only - Navigation to Registration goes here
                debugPrint("Navigate to Sign Up Screen");
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.grey.shade200, // Secondary action style
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Create an Account',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 1. Greeting & Profile Info Section
  Widget _buildGreetingSection(dynamic user) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: GlobalVariables.secondaryColor.withOpacity(
          0.2,
        ), // Subtle background
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: user.image.isNotEmpty
                ? NetworkImage(user.image)
                : null,
            child: user.image.isEmpty
                ? const Icon(Icons.person, size: 35, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Hello, ',
                    style: const TextStyle(fontSize: 22, color: Colors.black),
                    children: [
                      TextSpan(
                        text: user.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 2. Quick Action Buttons (E-commerce style)
  Widget _buildQuickActionGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildActionCard(
                label: 'Your Orders',
                icon: Icons.local_shipping_outlined,
              ),
              const SizedBox(width: 10),
              _buildActionCard(
                label: 'Turn Seller',
                icon: Icons.storefront_outlined,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildActionCard(
                label: 'Your Wishlist',
                icon: Icons.favorite_border,
              ),
              const SizedBox(width: 10),
              _buildActionCard(label: 'Recently Viewed', icon: Icons.history),
            ],
          ),
        ],
      ),
    );
  }

  // Helper for Quick Action Cards
  Widget _buildActionCard({required String label, required IconData icon}) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.black87, size: 20),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.normal,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: Colors.grey.shade300),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  // 3. Standard Account Settings List
  Widget _buildAccountSettingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 16, top: 16, bottom: 8),
          child: Text(
            'Account Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.location_on_outlined),
          title: const Text('Your Addresses'),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.payment_outlined),
          title: const Text('Payment Methods'),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.security_outlined),
          title: const Text('Login & Security'),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help Center'),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {},
        ),
      ],
    );
  }

  // 4. Logout Button Section
  Widget _buildLogoutSection() {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          Navigator.of(context).push(AuthScreen.route());
        }
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: state is AuthSubmitting
                ? null
                : () async {
                    // UI Only - No functionality added yet
                    await context.read<AuthCubit>().logout();
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.pink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
