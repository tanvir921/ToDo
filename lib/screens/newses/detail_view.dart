import 'package:appbar_animated/appbar_animated.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:todo_assignment/helpers/first_later_capitalizationer.dart';
import 'package:todo_assignment/responsive/mediaquery.dart';
import 'package:todo_assignment/screens/newses/more_webview.dart';

class DetailView extends StatefulWidget {
  const DetailView(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.detailNews,
      required this.time,
      required this.newsLink,
      required this.description,
      required this.category,
      required this.creator,
      required this.country})
      : super(key: key);

  final String title;
  final String description;
  final String imageUrl;
  final String detailNews;
  final String time;
  final String newsLink;
  final List category;
  final List creator;
  final List country;

  @override
  State<DetailView> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  @override
  Widget build(BuildContext context) {
    DateTime dt1 = DateTime.parse(widget.time);
    DateTime dt2 = DateTime.now();

    Duration diff = dt2.difference(dt1);
    return Scaffold(
      body: ScaffoldLayoutBuilder(
        backgroundColorAppBar: ColorBuilder(Colors.transparent, Colors.green),
        textColorAppBar: const ColorBuilder(Colors.white),
        appBarBuilder: _appBar,
        appBarHeight: 75,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.60,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                  image: NetworkImage(
                    widget.imageUrl == 'null'
                        ? "https://static.vecteezy.com/system/resources/thumbnails/021/109/637/small_2x/newspaper-icon-design-free-vector.jpg"
                        : widget.imageUrl,
                  ),
                )),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 35,
                        width: context.width * 0.5,
                        child: ListView.builder(
                          itemCount: widget.category.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              height: 35,
                              //width: 135,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.white.withOpacity(0.45),
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
                                      widget.category[i].toString(),
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
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        HtmlUnescape().convert(widget.title),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.50,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(35),
                          topRight: Radius.circular(35))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 40,
                              //width: 135,
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.black,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.account_circle_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                      child: Text(
                                    widget.creator.isEmpty
                                        ? 'Admin'
                                        : widget.creator[0].toString().length >
                                                10
                                            ? '${widget.creator[0].toString().substring(0, 10)}.'
                                            : widget.creator[0].toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              //width: 135,
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.green.shade50,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                      child: Text(
                                    '${diff.inHours.toString()} h',
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              //width: 135,
                              padding: const EdgeInsets.fromLTRB(5, 0, 15, 0),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Colors.green.shade50,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    size: 25,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Center(
                                    child: Text(
                                      FirstLaterCapitalizatoner
                                          .capitalizeFirstLetter(
                                        widget.creator.isEmpty
                                            ? 'Unspecified'
                                            : widget.country[0]
                                                        .toString()
                                                        .length >
                                                    10
                                                ? '${widget.country[0].toString().substring(0, 10)}.'
                                                : widget.country[0].toString(),
                                      ),
                                      //widget.country[0].toString(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: widget.description.toString() == 'null'
                              ? false
                              : true,
                          child: Column(
                            children: [
                              const Divider(
                                height: 5,
                                thickness: 2,
                                color: Colors.black,
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                child: Text(
                                  widget.description,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                height: 5,
                                thickness: 2,
                                color: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            widget.detailNews,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.newsLink.toString() == 'null'
                              ? false
                              : true,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoreWebview(
                                    url: widget.newsLink.toString(),
                                  ),
                                ),
                              );
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 40,
                                width: 120,
                                margin: const EdgeInsets.only(top: 10),
                                //padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50),
                                  ),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Center(
                                        child: Text(
                                          'More',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar(BuildContext context, ColorAnimated colorAnimated) {
    return AppBar(
      backgroundColor: colorAnimated.background,
      elevation: 0,
      leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: const Icon(Icons.arrow_back_ios_new_rounded)),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.favorite,
            color: colorAnimated.color,
          ),
        ),
      ],
    );
  }
}
