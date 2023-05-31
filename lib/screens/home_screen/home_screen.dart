import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movie_list/screens/authentication/login_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  Future<void> fetchMovies() async {
    final url = Uri.parse('https://hoblist.com/api/movieList');
    final response = await http.post(
      url,
      body: jsonEncode({
        'category': 'movies',
        'language': 'kannada',
        'genre': 'all',
        'sort': 'voting',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      setState(() {
        movies = jsonData['result'];
        print(movies);
        isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Can't fetch movies data"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: "Logout",
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          icon: Icon(Icons.logout),
        ),
        centerTitle: true,
        title: Text('Movie List'),
        actions: [
          IconButton(
            tooltip: "Company Information",
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(

                    title: Text('Company Info',style: TextStyle(fontSize: 30.0)),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Geeksynergy Technologies Pvt Ltd',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Address: Sanjayanagar, Bengaluru-56',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Phone: (+91)- 8904654505',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Email: support@geeksynergy.com',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final releaseDate = DateTime.fromMillisecondsSinceEpoch(
                    movie['releasedDate'] * 1000,
                  );
                  final formattedDate =
                      '${releaseDate.day} ${_getMonthName(releaseDate.month)} ${releaseDate.year}';

                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5.0),
                        child: Row(

                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,

                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,

                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_drop_up,
                                          size: 60,
                                        ),
                                      ),
                                      SizedBox(height: 15,),
                                      Text(
                                        "1",
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          size: 60,
                                        ),

                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5.0,),
                                  Text("votes",style: TextStyle(color: Colors.grey),),
                                ],
                              ),

                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(5, 5),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: SizedBox(
                                  width: 100,
                                  height: 150,
                                  child: Image.network(
                                    movie['poster'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),


                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    movie['title'],
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: [
                                      Text(
                                        "Genre",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(":"),
                                      Text(movie['genre']),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Director",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(":"),
                                      Text(movie['director'].join(', ')),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Starring",
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(":"),
                                      Expanded(
                                        child: Text(
                                          movie['stars'].join(', '),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          softWrap: false,
                                        ),
                                      ),

                                    ],
                                  ),
                                  Row(
                                    children: [
                                      movie['runTime'] == null
                                          ? Text("N/A mins |")
                                          : Text(movie['runTime'].toString() +
                                              " mins |"),
                                      SizedBox(width: 5),
                                      Text(movie["language"] + " | "),
                                      SizedBox(width: 5),
                                      Text(
                                        '$formattedDate',
                                        style: TextStyle(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        movie["pageViews"].toString() + " | ",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        "voted by 1 people",
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),

                                ],
                              ),

                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 450,

                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text('Watch Trailer'),
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 1,
                        thickness: 1,
                        indent: 20,
                        endIndent: 20,
                      )

                    ],
                  );
                },
              ),
            ),
    );
  }
}
