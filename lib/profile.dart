import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        children: [
          ProfileMember(
            name: 'Nicholas Gendy Putra Mahardika',
            nim: '123210017',
            photoUrl: 'assets/gendy.jpeg', // URL foto
          ),
        ],
      ),
    );
  }
}

class ProfileMember extends StatelessWidget {
  final String name;
  final String nim;
  final String photoUrl;

  ProfileMember({
    required this.name,
    required this.nim,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage(photoUrl),
          ),
          const SizedBox(height: 10.0),
          Text(
            name,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5.0),
          Text(
            'NIM: $nim',
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
