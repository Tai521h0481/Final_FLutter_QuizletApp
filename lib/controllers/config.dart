String IP = "192.168.3.117";
String baseUrl = "http://$IP:3001/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String getTopicByUser = users + "/get-topic-by-user";
String updateUsername = users + "/profiles/";
String uploadAvatarUrl = users + "/profiles/change-profile-image/";
String changePasswordUrl = users + "/profiles/password/";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";

// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";
