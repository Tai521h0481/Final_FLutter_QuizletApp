import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/controllers/topic.dart';
import 'package:shop_app/models/NewVocabulary.dart';
import 'package:shop_app/models/VocabularyChange.dart';
import 'package:shop_app/models/VocabularyItem.dart';
import 'package:shop_app/screens/flipcard/flipcard_screen.dart';

class EditTopic extends StatefulWidget {
  static String routeName = "/edit-topic";

  @override
  _StudySetScreenState createState() => _StudySetScreenState();
}

class _StudySetScreenState extends State<EditTopic> {
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
  List<VocabularyItem> vocabularyItems = [];
  bool _isDataLoaded = false;
  String originalSubject = '';
  String? originalDescription;
  List<VocabularyItem> originalVocabularyItems = [];
  String _topicId = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isDataLoaded) {
      final arguments =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      _topicId = arguments?['topicId'] ?? '';
      subjectController.text = arguments?['title'] ?? '';
      originalSubject = subjectController.text;
      descriptionController?.text = arguments?['description'] ?? '';
      originalDescription = descriptionController?.text;

      if (arguments != null && arguments['vocabularies'] != null) {
        List<dynamic> vocabularies = arguments['vocabularies'];
        containers.clear();
        focusNodes.clear();
        vocabularyItems.clear();

        for (var vocab in vocabularies) {
          FocusNode termFocusNode = FocusNode();
          FocusNode definitionFocusNode = FocusNode();
          TextEditingController termController =
              TextEditingController(text: vocab['englishWord']);
          TextEditingController definitionController =
              TextEditingController(text: vocab['vietnameseWord']);

          focusNodes.addAll([termFocusNode, definitionFocusNode]);

          containers.add(_buildContainer("Term", "Definition", termFocusNode,
              termController, definitionController));

          VocabularyItem item = VocabularyItem(
            id: vocab['_id'],
            termController: termController,
            definitionController: definitionController,
            originalTerm: vocab['englishWord'],
            originalDefinition: vocab['vietnameseWord'],
          );
          vocabularyItems.add(item);
        }

        _isDataLoaded = true;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    focusNodes = List.generate(4, (_) => FocusNode());
    descriptionController = TextEditingController();
    addFocusListeners();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(subjectFocusNode);
    });
    getToken();
  }

  void onSavePressed() async {
    List<Future<dynamic>> operations = [];
    Map<String, dynamic> updated = {};

    bool titleOrDescriptionChanged =
        subjectController.text != originalSubject ||
            descriptionController?.text != originalDescription;

    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Loading',
      text: 'Updating set...',
    );

    if (titleOrDescriptionChanged) {
      operations.add(updateTopic(
        _token,
        _topicId,
        subjectController.text,
        descriptionController?.text ?? '',
      ));
    }

    vocabularyItems.forEach((item) {
      if (item.id == null) {
        if (item.termController.text.isNotEmpty &&
            item.definitionController.text.isNotEmpty) {
          operations.add(createVocabToTopic(
            _token,
            _topicId,
            item.termController.text,
            item.definitionController.text,
          ));
        }
      } else if (item.termController.text.isEmpty &&
          item.definitionController.text.isEmpty) {
        operations.add(deleteVocabInTopic(_token, _topicId, item.id!));
      } else if (item.termController.text != item.originalTerm ||
          item.definitionController.text != item.originalDefinition) {
        operations.add(updateVocabInTopic(
          _token,
          _topicId,
          item.id!,
          item.termController.text,
          item.definitionController.text,
        ));
      }
    });

    try {
      final results = await Future.wait(operations, eagerError: true);

      await getTopicByID(_topicId, _token)
        .then((value) => updated = value['topic']);
      Navigator.pop(context);

      bool hasError = false;

      for (var result in results) {
        if (result['error'] != null) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: result['error'],
          );
          hasError = true;
          break;
        }
      }

      if (!hasError) {
        // ignore: use_build_context_synchronously
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: results.first['message'],
          onConfirmBtnTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context,
                FlipCardScreen.routeName,
                arguments: {
                  "_id": updated["_id"],
                  "title": updated["topicNameEnglish"],
                  'image': updated['ownerId']['profileImage'] ?? '',
                  'username': updated['ownerId']['username'] ?? '',
                  'description': updated["descriptionEnglish"] ?? '',
                  'terms': updated["vocabularyCount"].toString(),
                },
                (route) => false);
          },
        );
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Edit set',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_rounded),
            onPressed: onSavePressed,
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
              _buildField('Subject, chapter, unit', 'Title', subjectController),
              if (descriptionController!.text.isEmpty && !showDescription)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _toggleDescriptionField,
                    child: const Text('+ Description',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (descriptionController!.text.isNotEmpty || showDescription)
                _buildField("What's your set about", "Description",
                    descriptionController!),
              SizedBox(height: 20),
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

  Widget _buildContainer(
      String hintTerm,
      String hintDefinition,
      FocusNode termFocusNode,
      TextEditingController termController,
      TextEditingController definitionController) {
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
              _buildField(hintTerm, "Enter English Word", termController,
                  focusNode: termFocusNode),
              _buildField(hintDefinition, "Enter Vietnamese Word",
                  definitionController),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildField(
    String hint,
    String subTitle,
    TextEditingController controller, {
    FocusNode? focusNode,
  }) {
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
    FocusNode termFocusNode = FocusNode();
    FocusNode definitionFocusNode = FocusNode();
    TextEditingController termController = TextEditingController();
    TextEditingController definitionController = TextEditingController();

    // Cập nhật danh sách termControllers, definitionControllers, và focusNodes nếu cần

    // Đây là phần quan trọng: thêm mục từ vựng mới vào vocabularyItems
    vocabularyItems.add(VocabularyItem(
      id: null, // ID mới sẽ là null
      termController: termController,
      definitionController: definitionController,
      originalTerm: '',
      originalDefinition: '',
    ));

    // Cập nhật UI
    setState(() {
      containers.add(_buildContainer("Term", "Definition", termFocusNode,
          termController, definitionController));
    });

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => FocusScope.of(context).requestFocus(termFocusNode));
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
