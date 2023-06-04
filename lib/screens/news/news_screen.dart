import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:todo_assignment/helpers/first_later_capitalizationer.dart';
import 'package:todo_assignment/models/latest_news_model.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';
import 'package:todo_assignment/screens/home/home.dart';
import 'package:todo_assignment/screens/news/detail_view.dart';
import 'package:todo_assignment/utils/api_call.dart';

class Newses extends StatefulWidget {
  const Newses({super.key});

  @override
  State<Newses> createState() => _NewsesState();
}

class _NewsesState extends State<Newses>
    with AutomaticKeepAliveClientMixin<Newses> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    ApiCall.apicall;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 2,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: const Text(
          'Latest Newses',
          style: TextStyle(
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
        child: FutureBuilder<LatestNews>(
          future: ApiCall.apicall(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                key: const PageStorageKey<String>('latest_news'),
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                //shrinkWrap: true,
                itemCount: snapshot.data!.results!.length,
                itemBuilder: (
                  BuildContext context,
                  int index,
                ) =>
                    Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailView(
                            title:
                                snapshot.data!.results![index].title.toString(),
                            time: snapshot.data!.results![index].pubDate
                                .toString(),
                            imageUrl: snapshot.data!.results![index].imageUrl
                                .toString(),
                            detailNews: snapshot.data!.results![index].content
                                .toString(),
                            newsLink:
                                snapshot.data!.results![index].link.toString(),
                            description: snapshot
                                .data!.results![index].description
                                .toString(),
                            category: snapshot.data!.results![index].category!
                                .toList(),
                            creator: snapshot.data!.results![index].creator!
                                .toList(),
                            country: snapshot.data!.results![index].country!
                                .toList(),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                snapshot.data!.results![index].imageUrl == null
                                    ? 'https://static.vecteezy.com/system/resources/thumbnails/021/109/637/small_2x/newspaper-icon-design-free-vector.jpg'
                                    : snapshot.data!.results![index].imageUrl
                                        .toString(),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: context.width * 0.56,
                                child: Text(
                                  HtmlUnescape().convert(
                                    snapshot.data!.results![index].title
                                                .toString()
                                                .length >
                                            60
                                        ? '${snapshot.data!.results![index].title.toString().substring(0, 60)}...'
                                        : snapshot.data!.results![index].title
                                            .toString(),
                                  ),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              SizedBox(
                                width: context.width * 0.56,
                                child: Text(
                                  snapshot.data!.results![index].pubDate
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 1,
                              ),
                              SizedBox(
                                height: 25,
                                width: context.width * 0.5,
                                child: ListView.builder(
                                  key: const PageStorageKey<String>('category'),
                                  itemCount: snapshot
                                      .data!.results![index].category?.length,
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (BuildContext context, int i) {
                                    return Container(
                                      height: 25,
                                      margin: const EdgeInsets.only(right: 5),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.black45,
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 5,
                                            bottom: 5,
                                          ),
                                          child: Text(
                                            FirstLaterCapitalizatoner
                                                .capitalizeFirstLetter(
                                              snapshot.data!.results![i]
                                                  .category![i]
                                                  .toString(),
                                            ),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
