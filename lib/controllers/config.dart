String IP = "52.221.210.100";
String baseUrl = "http://52.221.210.100:3001/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String getTopicByUser = users + "/get-topic-by-user";
String updateUsername = users + "/profiles";
String uploadAvatarUrl = users + "/change-profile-image";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";

// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";
