import 'package:beer_api_screen/beer_response.dart';
import 'package:flutter/material.dart';

class BeerDetailScreen extends StatelessWidget {
  final BeerResponse beer;

  const BeerDetailScreen({Key? key, required this.beer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          beer.name,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: Image.network(
                beer.image,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  return loadingProgress != null
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.deepOrange,
                          ),
                        )
                      : child;
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text(
                      'Error Loading Image',
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Text(
              beer.name,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              beer.price,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Average Rating: ${beer.rating.average.toStringAsFixed(1)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Number of Reviews: ${beer.rating.reviews}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
