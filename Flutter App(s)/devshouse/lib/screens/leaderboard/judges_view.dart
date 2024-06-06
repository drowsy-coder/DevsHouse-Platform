import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Judge {
  final String name;
  final String designation;
  final String company;
  final String imageUrl;

  Judge({
    required this.name,
    required this.designation,
    required this.company,
    required this.imageUrl,
  });
}

final List<Judge> judgeData = [
  Judge(
      name: 'Ishank Saxena',
      designation: 'Fullstack Developer',
      company: 'Google',
      imageUrl: 'assets/1516617668384.jpeg'),
  Judge(
      name: 'Krishna Agarwal',
      designation: 'Senior Software Engineer',
      company: 'Awone',
      imageUrl: 'assets/1517222898182.jpeg'),
  Judge(
      name: 'Sayak Saha',
      designation: 'Systems Engineer',
      company: 'TCS',
      imageUrl: 'assets/1697268756349.jpeg'),
  Judge(
      name: 'Chakravarthy V P',
      designation: 'Founder & CTO',
      company: 'C4Scale',
      imageUrl: 'assets/1699373896479.jpeg'),
  Judge(
      name: 'Harshvardhan Bajoria',
      designation: 'Campus Expert',
      company: 'GitHub',
      imageUrl: 'assets/1689445352564.jpeg'),
  Judge(
      name: 'Sankhya Siddesh',
      designation: 'R&D and DevRel',
      company: 'Push Protocol',
      imageUrl: 'assets/1708264776601.jpeg'),
];

final List<String> linkedinURLs = [
  'https://www.linkedin.com/in/ishank-saxena',
  'https://www.linkedin.com/in/kriaga',
  'https://www.linkedin.com/in/sayaksaha10',
  'https://www.linkedin.com/in/chakravarthyvp/',
  'https://www.linkedin.com/in/harshavardhan-bajoria/',
  'https://www.linkedin.com/in/siddesh-eth/',
];

class KnowYourJudgesScreen extends StatelessWidget {
  const KnowYourJudgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Know Your Judges'),
      ),
      body: ListView.builder(
        itemCount: judgeData.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => _launchURL(linkedinURLs[index]),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              elevation: 5,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(judgeData[index].name,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Text(judgeData[index].designation,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600])),
                          const SizedBox(height: 5),
                          Text(judgeData[index].company,
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(judgeData[index].imageUrl,
                          width: 100, height: 100, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
