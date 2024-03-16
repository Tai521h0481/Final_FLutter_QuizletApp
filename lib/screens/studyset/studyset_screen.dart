import 'package:flutter/material.dart';

class StudySetScreen extends StatefulWidget {
  static String routeName = "/studyset";

  @override
  _StudySetScreenState createState() => _StudySetScreenState();
}

class _StudySetScreenState extends State<StudySetScreen> {
  bool showDescription = false;
  List<Widget> containers = [];
  final ScrollController scrollController = ScrollController();
  List<FocusNode> focusNodes = [];
  FocusNode subjectFocusNode = FocusNode();
  FocusNode? descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    containers.add(_buildContainer('Term', 'Definition', 0));
    containers.add(_buildContainer('Term', 'Definition', 1));
    addFocusListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(
          subjectFocusNode); // Auto focus vào field đầu tiên khi mở trang
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: const Text(
          'Create set',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              _buildField('Subject, chapter, unit', 'Title', subjectFocusNode),
              const SizedBox(height: 10),
              if (!showDescription)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _toggleDescriptionField,
                    child: const Text('+ Description',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (showDescription)
                _buildField("What's your set about", "Description",
                    descriptionFocusNode!),
              SizedBox(height: 20),
              ...containers,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewContainer,
        child: Icon(
          Icons.add,
          size: 15,
        ),
        backgroundColor: Color(0xFF007BFF),
        shape: CircleBorder(),
        mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void addFocusListeners() {
    subjectFocusNode.addListener(() => scrollToFocus(subjectFocusNode));
    focusNodes.forEach((node) {
      node.addListener(() => scrollToFocus(node));
    });
  }

  void scrollToFocus(FocusNode node) {
    final widgetIndex = focusNodes.indexOf(node);
    final position =
        widgetIndex >= 0 ? widgetIndex * 200.0 : 0.0; // Ứớc lượng vị trí cuộn

    scrollController.animateTo(
      position,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    subjectFocusNode.dispose();
    descriptionFocusNode?.dispose();
    focusNodes.forEach((node) => node.dispose());
    super.dispose();
  }

  Widget _buildContainer(String subFirst, String subSecond, int index) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildField('', subFirst, focusNodes[index * 2]),
              SizedBox(height: 10),
              _buildField('', subSecond, focusNodes[index * 2 + 1]),
              SizedBox(height: 30),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String hint, String subTitle, FocusNode focusNode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: hint,
              contentPadding: const EdgeInsets.only(bottom: -5, top: 6),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 1.5),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 4.0),
              ),
              hintStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 179, 179, 179),
              ),
            ),
            focusNode: focusNode,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              subTitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 132, 131, 131),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewContainer() {
    int currentIndex = containers.length;
    focusNodes.addAll([FocusNode(), FocusNode()]);
    setState(() {
      containers.add(_buildContainer('Term', 'Definition', currentIndex));
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNodes[currentIndex * 2]);
    });
  }

  void _toggleDescriptionField() {
    if (descriptionFocusNode == null) {
      descriptionFocusNode = FocusNode();
      descriptionFocusNode!
          .addListener(() => scrollToFocus(descriptionFocusNode!));
    }
    setState(() {
      showDescription = !showDescription;
    });
    if (showDescription) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(descriptionFocusNode);
      });
    }
  }
}
