import 'package:flutter/material.dart';
import 'package:pet_store_mobile_app/widgets/custom_bottom_nav.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('My Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // TODO: Implement edit profile functionality
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500'),
                  ),
                ),
                const SizedBox(height: 16),
                const Center(
                  child: Text(
                    'Randil Tharusha',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Account Information',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildInfoTile(Icons.email, 'Email', 'randil@example.com'),
                _buildInfoTile(Icons.phone, 'Phone', '+1 234 567 890'),
                _buildInfoTile(Icons.location_on, 'Address',
                    '123 Pet Street, Gampaha, PA 12345'),
                const SizedBox(height: 24),
                const Text(
                  'My Pet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // upload pet image
                _buildInfoTile(Icons.pets, 'Pet Name', 'Bella'),
                //image uploader
                _buildInfoTile(Icons.pets, 'Pet Breed', 'Golden Retriever'),
                const SizedBox(height: 24),
                // _buildSwitchTile('Notifications', true),
                // _buildSwitchTile('Dark Mode', false),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement logout functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const CustomBottomNav(currentIndex: 2));
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // TODO: Implement edit functionality for each field
      },
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: (newValue) {
        // TODO: Implement switch functionality
      },
    );
  }
}
