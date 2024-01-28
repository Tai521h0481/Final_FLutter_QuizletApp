String IP = "192.168.1.14";
String baseUrl = "http://$IP:3000/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String getTopicByUser = users + "/get-topic-by-user";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";


// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";
