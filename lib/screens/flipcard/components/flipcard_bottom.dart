import 'package:flutter/material.dart';
import 'package:shop_app/screens/flipcard/components/buildTerm.dart';

class Bottom extends StatefulWidget {
  final int currentPage;
  final List<dynamic> vocabularies;

  const Bottom({
    Key? key,
    required this.vocabularies,
    required this.currentPage,
  }) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  String _currentSort = 'Original';
  List<dynamic> _sortedVocabularies = [];

  @override
  void didUpdateWidget(Bottom oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the vocabularies list has been updated.
    if (widget.vocabularies != oldWidget.vocabularies) {
      _updateSortedVocabularies();
    }
  }

  void _updateSortedVocabularies() {
    setState(() {
      _sortedVocabularies = List.from(widget.vocabularies);
    });
  }

  @override
  void initState() {
    super.initState();
    _updateSortedVocabularies(); // Use the same logic to initialize _sortedVocabularies.
  }

  void _sortVocabularies(String sortType) {
    setState(() {
      if (sortType == 'Alphabetically') {
        _sortedVocabularies
            .sort((a, b) => a["englishWord"].compareTo(b["englishWord"]));
      } else if (sortType == 'Original') {
        _sortedVocabularies = List.from(widget.vocabularies);
      }
      _currentSort = sortType;
    });
  }

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
          itemCount: _sortedVocabularies.length,
          itemBuilder: (context, index) {
            return CreateTerm(_sortedVocabularies[index]["englishWord"]);
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
                  color: Color(0xFFEDEDEF),
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
                        color: Color(0xFFB2B2B2),
                        child: const SizedBox(
                            height: 1.0, width: double.infinity)),
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
                        _sortVocabularies('Original');
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        color: Color(0xFFB2B2B2),
                        child: const SizedBox(
                            height: 1.0, width: double.infinity)),
                    ListTile(
                      title: const Text('Alphabetically',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF3F56FF))),
                      onTap: () {
                        setState(() {
                          _currentSort = 'Alphabetically';
                        });
                        _sortVocabularies('Alphabetically');
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
      backgroundColor: Colors.transparent,
    );
  }
}
