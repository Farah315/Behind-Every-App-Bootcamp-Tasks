import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showSkills = true;

  final List<String> _skills = ['Kotlin', 'Jetpack Compose', 'Flutter', 'Git'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      appBar: AppBar(
        title: const Text('Profile Page'),
        titleTextStyle: const TextStyle(fontSize: 20, color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
        ),
        backgroundColor: Colors.blueGrey,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_rounded),
            color: Colors.white,
            onPressed: () {
              // TODO: implement dark mode toggle logic
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Farah',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'Android & Flutter Developer',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),

            // About me card
            _buildCard(
              title: 'About me',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Age', '21'),
                  _infoRow('University', 'Al-Aqsa University'),
                  _infoRow('Major', 'Computer Science'),
                  const SizedBox(height: 14),
                  const Text(
                    'Bio',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'CS student and Android developer, mentoring at '
                        'ByteBloom and building with Kotlin & Jetpack Compose.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Skills card
            _buildCard(
              title: 'Skills',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showSkills)
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills
                          .map(
                            (skill) => Chip(
                              label: Text(skill),
                              backgroundColor:
                                  Colors.blueGrey.withOpacity(0.1),
                              labelStyle: const TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                              ),
                              side: BorderSide.none,
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() => _showSkills = !_showSkills);
                    },
                    icon: Icon(
                      _showSkills
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18,
                    ),
                    label: Text(_showSkills ? 'Hide Skills' : 'Show Skills'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blueGrey,
                      side: const BorderSide(color: Colors.blueGrey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.blueGrey,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}