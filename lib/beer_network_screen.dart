import 'dart:async';
import 'dart:ui';

import 'package:beer_api_screen/beer_detail_screen.dart';
import 'package:beer_api_screen/beer_response.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BeerNetworkScreen extends StatelessWidget {
  BeerNetworkScreen({super.key});

  var client = http.Client();
  final beerController = StreamController<List<BeerResponse>>();
  BuildContext? loaderContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text(
          'BEER API',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () async {
          await getAllResponse(context);
        },
        label: Text(
          'CALL',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<List<BeerResponse>>(
          stream: beerController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No data available.'),
              );
            }

            final data = snapshot.data!;
            return ListView.separated(
              physics: BouncingScrollPhysics(
                decelerationRate: ScrollDecelerationRate.fast,
              ),
              itemBuilder: (context, index) {
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BeerDetailScreen(
                            beer: data[index],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data[index].name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Image.network(
                            data[index].image,
                            loadingBuilder: (context, child, loadingProgress) {
                              return loadingProgress != null
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: SizedBox.square(
                                        dimension: 100,
                                        child: CupertinoActivityIndicator(),
                                      ),
                                    )
                                  : child;
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Align(
                                alignment: Alignment.center,
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
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            data[index].price,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(),
              itemCount: data.length,
            );
          }),
    );
  }

  Future<void> getAllResponse(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) {
        loaderContext = context;
        return BackdropFilter(
          filter: ImageFilter.blur(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            ),
          ),
        );
      },
    );

    try {
      final response = await client.get(
        Uri.https(
          'api.sampleapis.com',
          '/beers/ale',
        ),
      );

      if (response.statusCode == 200) {
        final List<BeerResponse> beerResponse =
            beerResponseFromJson(response.body);
        beerController.add(beerResponse);
      } else {
        debugPrint('Failed to load beers: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      if (loaderContext != null) {
        Navigator.pop(loaderContext!);
      }
    }
  }
}
