String IP = "52.221.210.100";
// String IP = "192.168.118.76";
String baseUrl = "http://$IP:3001/android";

String users = baseUrl + "/users";
String register = users + "/register";
String login = users + "/login";
String recover_Password = users + "/recover-password";
String updateUsername = users + "/profiles/";
String uploadAvatarUrl = users + "/profiles/change-profile-image/";
String changePasswordUrl = users + "/profiles/password/";
String createAchievementUrl = users + "/achievement/";

// topic
String topic = baseUrl + "/topics";
String getTopic = topic + "/";
String getTopicByIdUrl = topic + "/";
String getTopicByFolderId = topic + "/folders/";
String getPublicTopicUrl = topic + "/public/getPublicTopic";
String createTopicUrl = topic;
String getTopicByUser = topic + "/get-topic-user";
String deleteTopicUrl = topic + "/";
String updateTopicUrl = topic + "/";
String updateVocabInTopicUrl = topic + "/:id/vocabularies/:vocabularyId";
String createVocabToTopicUrl = topic + "/:id/vocabularies";
String deleteVocabInTopicUrl = topic + "/:id/vocabularies/:vocabularyId";

// vocab
String vocab = baseUrl + "/vocabularies";
String getVocabByTopicId = vocab + "/topics/";

//folder
String folder = baseUrl + "/folders";
String getFolderByUser = folder + "/users/";
String createFolderUrl = folder + "/";
String addTopicToFolder = folder + ":id/topics/:topicId";
String editFolderUrl = folder + "/";
String deleteFolderUrl = folder + "/";
String deleteTopicInFolder = folder + ":id/topics/:topicId";
