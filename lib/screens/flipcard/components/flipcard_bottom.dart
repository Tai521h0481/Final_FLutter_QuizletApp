import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/components/buildTerm.dart';

class Bottom extends StatefulWidget {
  Bottom({
    Key? key,
    required this.vocabularies,
    required this.currentPage,
  }) : super(key: key);

  final int currentPage;
  final List<dynamic> vocabularies;

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  String _currentSort = 'Original';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Terms',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Text(
                    _currentSort,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 85, 85, 85)),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.sort,
                    ),
                    color: const Color(0xFF555555),
                    onPressed: () {
                      _showBottomSheet(context);
                    },
                  )
                ],
              ),
            )
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.vocabularies.length,
          itemBuilder: (context, index) {
            return CreateTerm(widget.vocabularies[index]["englishWord"]);
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _showBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Sort terms',
                        style: TextStyle(
                          fontSize: 12.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                        color: Colors.grey.shade300,
                        child: const SizedBox(height: 1.0, width: double.infinity)),
                    ListTile(
                      title: const Text(
                        'In original order',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF3F56FF)),
                      ),
                      onTap: () {
                        setState(() {
                          _currentSort = 'Original';
                        });
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        color: Colors.grey.shade300,
                        child: const SizedBox(height: 1.0, width: double.infinity)),
                    ListTile(
                      title: const Text('Alphabetically',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF3F56FF))),
                      onTap: () {
                        setState(() {
                          _currentSort = 'Alphabetically';
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: ListTile(
                  title: const Text(
                    'Cancel',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF3F56FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                      letterSpacing: -1.0,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 30.0)
            ],
          ),
        );
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor:
          Colors.transparent, // Đặt là transparent để có thể tùy chỉnh
    );
  }
}
