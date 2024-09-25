import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AdvertisementCarousel extends StatefulWidget {
  @override
  AdvertisementCarouselState createState() => AdvertisementCarouselState();
}

class AdvertisementCarouselState extends State<AdvertisementCarousel> {
  List<dynamic> adverts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAdverts();
  }

  Future<void> fetchAdverts() async {
    final String baseUrl =
        dotenv.env['API_URL']!; // Ensure this is correctly set
    final Uri url = Uri.parse('$baseUrl/api/adverts');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        adverts = data['data']; // Store the list of adverts
        isLoading = false;
      });
    } else {
      print('Failed to load adverts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : CarouselSlider.builder(
              itemCount: adverts.length,
              itemBuilder: (context, index, realIndex) {
                final advert = adverts[index]['attributes'];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Row(
                    children: [
                      // Image section
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(advert['image_url']),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Text section with equal size
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          color: const Color.fromARGB(133, 8, 39, 151),
                          child: Center(
                            child: Text(
                              advert['text'],
                              style: GoogleFonts.nunito(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.2,
                viewportFraction: 0.8,
              ),
            ),
    );
  }
}
