import 'package:flutter/material.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan Kesan'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Kesan : ',
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Text(
              'Selama mengikuti perkuliahan TPM ini, diajarkan mulai dari awal konsep mobile hingga jadinya sebuah program mobile. hal ini membantu saya dalam memperoleh pengetahuan dan berpikir kritis dalam matkul ini',
            ),
            SizedBox(height: 15),
            Text(
              'Pesan :',
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Text(
              'Terima kasih atas ilmu dan bimbingannya, bapak 🙏🙏🙏',
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
