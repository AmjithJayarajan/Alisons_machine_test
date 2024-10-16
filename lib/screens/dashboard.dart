import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Constants/globals.dart';
import '../models/homepage_model.dart' ;
import '../widgets/cartBadge.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  HomePageModel? homePageData;
  late Future<HomePageModel> futureHomePageData;
  bool isLoading = true;

  void fetchHomePageData() async {
    String id = Globals.id;
    String token = Globals.token;

    final url = Uri.parse('https://swan.alisonsnewdemo.online/api/home');
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'token': token,
        }),
      );

      print('ID: $id');
      print('Token: $token');

      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          homePageData = HomePageModel.fromRawJson(response.body);
        });
      } else {
        print('Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load data: ${response.statusCode} ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error occurred: $e");

    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchHomePageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/logos/logo.png',
                    height: 50,
                    fit: BoxFit.fitHeight,
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.search,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          print('Search tapped');
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border,
                            color: Colors.black, size: 30),
                        onPressed: () {
                          print('Favorites tapped');
                        },
                      ),
                      const ShoppingCartBadge(
                        itemCount: 3,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      body: isLoading ? Center(child: CircularProgressIndicator()) : (homePageData != null) ? SingleChildScrollView(
        child: Column(
          children: [
            buildBannerSection(homePageData?.banner1 ?? []),
            SizedBox(height: 8),
            buildBrandsSection(homePageData?.featuredbrands ?? []),
            SizedBox(height: 8),
            buildSuggestedSection(homePageData?.suggestedProducts ?? []),
            SizedBox(height: 8),
            buildBanner0Section(homePageData?.banner4 ?? []),
            SizedBox(height: 8),
            buildBestSellersSection(homePageData?.bestSeller ?? []),
            SizedBox(height: 8),
            buildTrendingCategorySection(homePageData?.featuredbrands ?? []),
            SizedBox(height: 8),
            buildBanner3Section(homePageData?.banner3 ?? []),
            SizedBox(height: 8),
            buildBanner5Section(homePageData?.banner5 ?? []),
          ],
        ),
      ) : Text("no results found")
      );
  }


  Widget buildBannerSection(List<HomeBanner> banners) {
    return Column(
      children: banners.map((banner) {
        return Container(
          margin: EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Image.network(
                "https://swan.alisonsnewdemo.online/images/banner/${banner.image}",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 20,
                child: OutlinedButton(
                  onPressed: () {

                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    side: BorderSide(color: Colors.white),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    "Shop Now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildBrandsSection(List<Featuredbrand> featuredbrands) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Our Brands',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredbrands.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://swan.alisonsnewdemo.online/images/product/${featuredbrands[index].image}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      featuredbrands[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildSuggestedSection(List<BestSeller> suggestedProducts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Suggested For You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suggestedProducts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://swan.alisonsnewdemo.online/images/product/${suggestedProducts[index].image}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      suggestedProducts[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₹ ${suggestedProducts[index].price}',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildBanner0Section(List<HomeBanner> banners4) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
            ],
          ),
        ),
        Column(
          children: banners4.map((banner) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Image.network("https://swan.alisonsnewdemo.online/images/banner/${banner.image}"),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget buildBestSellersSection(List<BestSeller> bestSellers) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Bestsellers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bestSellers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://swan.alisonsnewdemo.online/images/product/${bestSellers[index].image}",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      bestSellers[index].name,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 10),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '₹ ${bestSellers[index].price}',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildTrendingCategorySection(List<Featuredbrand> brands) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Trending Categories',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: brands.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://swan.alisonsnewdemo.online/images/category/${brands[index].image}",
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  brands[index].name,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget buildBanner3Section(List<HomeBanner> banners3) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Shop Exclusive Deals',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Column(
            children: banners3.map((banner) {
              return Container(
                margin: EdgeInsets.all(8.0),
                child: Image.network("https://swan.alisonsnewdemo.online/images/banner/${banner.image}"),
              );
            }).toList(),
          )
      ],
    );
    // return Column(
    //   children: banners3.map((banner) {
    //     return Container(
    //       margin: EdgeInsets.all(8.0),
    //       child: Image.network("https://swan.alisonsnewdemo.online/images/banner/${banner.image}"),
    //     );
    //   }).toList(),
    // );
  }

  Widget buildBanner5Section(List<dynamic> banners5) {
    print("banners5 ${banners5}");
    return Column(
      children: [
        Column(
          children: banners5.map((banner) {
            return Container(
              margin: EdgeInsets.all(8.0),
              child: Image.network("https://swan.alisonsnewdemo.online/images/banner/${banner.image}"),
            );
          }).toList(),
        )
      ],
    );
  }


}