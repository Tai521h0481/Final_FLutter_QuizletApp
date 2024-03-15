String IP = "52.221.210.100";
String baseUrl = "http://$IP:3001/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String getTopicByUser = users + "/get-topic-by-user";
String updateUsername = users + "/profiles/";
String uploadAvatarUrl = users + "/profiles/change-profile-image/";
String changePasswordUrl = users + "/profiles/password/";
String createAchievementUrl = users + "/achievement/";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";
String getTopicById = topic + "/";
String getTopicByFolderId = topic + "/folders/";

// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";

//folder
String folder = baseUrl + "/folders";
String getFolderByUser = folder + "/users/";
String createFolder = folder + "/";
String addTopicToFolder = folder + ":id/topics/:topicId";
String editFolde = folder + "/";
String deleteFolder = folder + "/";
String deleteTopicInFolder = folder + ":id/topics/:topicId";
