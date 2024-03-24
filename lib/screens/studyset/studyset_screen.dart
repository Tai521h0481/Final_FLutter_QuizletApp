import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';

class StudySetScreen extends StatefulWidget {
  static String routeName = "/studyset";

  @override
  _StudySetScreenState createState() => _StudySetScreenState();
}

class _StudySetScreenState extends State<StudySetScreen> {
  TextEditingController subjectController = TextEditingController();
  TextEditingController? descriptionController;
  List<TextEditingController> termControllers = [];
  List<TextEditingController> definitionControllers = [];

  bool showDescription = false;
  List<Widget> containers = [];
  final ScrollController scrollController = ScrollController();
  List<FocusNode> focusNodes = [];
  FocusNode subjectFocusNode = FocusNode();
  FocusNode? descriptionFocusNode;
  int currentIndex = 0;
  String _token = '';
  bool isPublic = false;
  String publicText = 'Just me';
  
  @override
  void initState() {
    super.initState();
    getToken();
    focusNodes = List.generate(4, (_) => FocusNode());
    containers.add(_buildContainer('Term', 'Definition', 0));
    containers.add(_buildContainer('Term', 'Definition', 1));
    descriptionController = TextEditingController();
    for (int i = 0; i < 2; i++) {
      termControllers.add(TextEditingController());
      definitionControllers.add(TextEditingController());
    }
    addFocusListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(subjectFocusNode);
    });
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  Future<void> callAPI() async {
    String subjectText = subjectController.text;
    String? descriptionText = descriptionController?.text;
    List<Map<String, String>> termsDefinitions = [];

    if (subjectText.isEmpty) return;

    for (int i = 0; i < termControllers.length; i++) {
      if (termControllers[i].text.isEmpty) {
        break;
      }
      termsDefinitions.add({
        "englishWord": termControllers[i].text,
        "vietnameseWord": definitionControllers[i].text,
      });
    }

    await createTopic(
            subjectText, descriptionText!, termsDefinitions, _token, isPublic)
        .then((value) async {
      Map<String, dynamic> topic = value['topic'];
      Map<String, dynamic> user = topic['ownerId'];
      Navigator.pop(context);
      await Navigator.pushNamed(context, FlipCardScreen.routeName, arguments: {
        "_id": topic["_id"],
        "title": topic["topicNameEnglish"],
        'image': user["profileImage"] ?? '',
        'username': user["username"] ?? '',
        'description': topic["descriptionEnglish"] ?? '',
        'terms': topic["vocabularyCount"].toString(),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Create set',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.done),
            onPressed: () {
              callAPI();
            },
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
              _buildField('Subject, chapter, unit', 'Title', subjectFocusNode,
                  subjectController),
              if (!showDescription)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _toggleDescriptionField,
                    child: const Text('+ Description',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF4C56FF))),
                  ),
                ),
              if (showDescription)
                _buildField("What's your set about", "Description",
                    descriptionFocusNode!, descriptionController!),
              SizedBox(height: 20),
              _createSwitchListTile(publicText, isPublic, (bool value) {
                setState(() {
                  isPublic = value;
                  publicText = isPublic ? 'Everyone' : 'Just me';
                });
              }, isPublic ? Icons.public : Icons.public_off,
                  isPublic ? Color(0xFF4C56FF) : Colors.grey),
              const Divider(height: 1.0, color: Color(0xFFF2F2F7)),
              ...containers,
              SizedBox(
                height: 200,
              ),
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
    double position = 0.0;
    if (widgetIndex >= 0) {
      position = widgetIndex > currentIndex
          ? widgetIndex * 200.0
          : widgetIndex * 200.0 - 200.0;
    }
    currentIndex = widgetIndex;

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
    while (termControllers.length <= index) {
      termControllers.add(TextEditingController());
      definitionControllers.add(TextEditingController());
    }
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
              _buildField(
                  '', subFirst, focusNodes[index * 2], termControllers[index]),
              _buildField('', subSecond, focusNodes[index * 2 + 1],
                  definitionControllers[index]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(String hint, String subTitle, FocusNode focusNode,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
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
              errorStyle: TextStyle(color: Colors.redAccent),
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

  SwitchListTile _createSwitchListTile(String title, bool value,
      void Function(bool) onChanged, IconData icon, Color color) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(
            color: color, fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      value: value,
      onChanged: onChanged,
      secondary: Icon(icon, color: color),
      activeTrackColor: Color(0xFF4C56FF),
      inactiveThumbColor: Colors.white,
      inactiveTrackColor: const Color(0xFFE9E9EA),
      activeColor: Colors.white,
    );
  }
}
