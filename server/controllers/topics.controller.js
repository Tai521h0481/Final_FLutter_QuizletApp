require("dotenv").config();
const {
  Users,
  Topic,
  Vocabulary,
  TopicInFolder,
  BookmarkTopic,
  VocabularyStatistic,
  LearningStatistics,
  Folder,
  BookmarkVocabulary,
} = require("../models");

const getTopicById = async (req, res) => {
  const id = req.params.id || req.query.id;
  try {
    const topic = await Topic.findById(id).populate("ownerId").exec();
    res.status(200).json({ topic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getAllTopics = async (req, res) => {
  try {
    const topics = await Topic.find().populate("vocabularyId");
    if (topics.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    res.status(200).json({ topics, size: topics.length });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTopicsByUserId = async (req, res) => {
  const userId = req.params.id || req.query.id || req.user.data._id;
  try {
    const topics = await Topic.find().populate("ownerId").exec();
    const topicsWithMatchingUserId = topics.filter((topic) => {
      const res = topic.ownerId != null && topic.ownerId._id.equals(userId);
      return topic.userId.includes(userId) || res;
    });
    if (topics.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    res.status(200).json({ topics: topicsWithMatchingUserId });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getFolderByTopicId = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  try {
    const topic = await Topic.findById(topicId);
    if (!topic) {
      res.status(404).json({ error: "Topic not found" });
      return;
    }

    let folders = [];
    for (let folderId of topic.folderId) {
      const folder = await Folder.findById(folderId);
      folders.push(folder);
    }
    res.status(200).json({ folders });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateTopic = async (req, res) => {
  const id = req.params.id || req.query.id;
  const {
    topicNameEnglish,
    topicNameVietnamese,
    descriptionEnglish,
    descriptionVietNamese,
  } = req.body;
  try {
    const topic = await Topic.findByIdAndUpdate(
      id,
      {
        topicNameEnglish,
        topicNameVietnamese,
        descriptionEnglish,
        descriptionVietNamese,
      },
      { new: true }
    ).populate("ownerId");
    res.status(200).json({ topic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const userId = req.user.data._id;
  try {
    const topic = await Topic.findById(topicId).populate("vocabularyId");
    if (!topic) {
      return res.status(404).json({ message: "Topic not found" });
    }
    for (let vocab of topic.vocabularyId) {
      await BookmarkVocabulary.deleteMany({ vocabularyId: vocab._id, userId });
      await VocabularyStatistic.deleteMany({ vocabularyId: vocab._id, userId });
    }
    // Người dùng là chủ sở hữu của topic, xóa topic và tất cả các tham chiếu liên quan
    await TopicInFolder.deleteMany({ topicId });
    await BookmarkTopic.deleteMany({ topicId });
    await LearningStatistics.deleteMany({ topicId, userId });
    await Vocabulary.deleteMany({ topicId });
    await Users.updateMany({}, { $pull: { topicId } }); // Xóa topic khỏi tất cả người dùng
    await Topic.findByIdAndDelete(topicId);
    await Folder.findByIdAndUpdate(topicId, {
      $pull: { topicId },
      $inc: { topicCount: -1 },
    });
    res.status(200).json({ message: "Delete topic successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const createVocabularyInTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const { englishWord, vietnameseWord, englishMeaning, vietnameseMeaning } =
    req.body;
  try {
    let topic = await Topic.findByIdAndUpdate(
      topicId,
      { $inc: { vocabularyCount: 1 } },
      { new: true }
    );
    const vocabulary = await Vocabulary.create({
      englishWord,
      vietnameseWord,
      englishMeaning,
      vietnameseMeaning,
      topicId,
    });
    topic.vocabularyId.push(vocabulary._id);
    await topic.save();
    res.status(200).json({
      message: "Vocabulary added to topic successfully",
      topic,
      vocabulary,
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const deleteVocabularyInTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const vocabularyId = req.params.vocabularyId;
  const userId = req.user.data._id;
  try {
    const vocab = await Vocabulary.findOne({ _id: vocabularyId, topicId });
    if (!vocab) {
      return res
        .status(404)
        .json({ error: "Vocabulary does not exist in topic" });
    }
    const topic = await Topic.findByIdAndUpdate(
      topicId,
      { $inc: { vocabularyCount: -1 }, $pull: { vocabularyId } },
      { new: true }
    );
    await BookmarkTopic.findOneAndDelete({ vocabularyId, userId });
    await VocabularyStatistic.findOneAndDelete({ vocabularyId, userId });
    await BookmarkVocabulary.findOneAndDelete({ vocabularyId, userId });
    await Vocabulary.findByIdAndDelete(vocabularyId);

    res.status(200).json({ message: "Vocabulary deleted successfully", topic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const editVocabularyInTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const vocabularyId = req.params.vocabularyId;
  const { englishWord, vietnameseWord, englishMeaning, vietnameseMeaning } =
    req.body;
  try {
    const vocabulary = await Vocabulary.findOneAndUpdate(
      { _id: vocabularyId, topicId },
      { englishWord, vietnameseWord, englishMeaning, vietnameseMeaning },
      { new: true }
    );
    if (!vocabulary) {
      return res
        .status(404)
        .json({ error: "Vocabulary does not exist in topic" });
    }
    res
      .status(200)
      .json({ message: "Vocabulary edited successfully", vocabulary });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const upVoteCount = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  try {
    const topic = await Topic.findByIdAndUpdate(
      topicId,
      { $inc: { upVoteCount: 1 } },
      { new: true }
    );
    res.status(200).json({ message: "Up vote successfully", topic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const downVoteCount = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  try {
    const topic = await Topic.findByIdAndUpdate(
      topicId,
      { $inc: { downVoteCount: 1 } },
      { new: true }
    );
    res.status(200).json({ message: "Down vote successfully", topic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const importCSV = async (req, res) => {
  const {
    topicNameEnglish,
    topicNameVietnamese,
    descriptionEnglish,
    descriptionVietnamese,
    vocabularyList,
    isPublic,
  } = req.body;
  const userId = req.user.data._id;
  try {
    let topic = await Topic.create({
      topicNameEnglish,
      topicNameVietnamese,
      descriptionEnglish,
      descriptionVietnamese,
      vocabularyCount: vocabularyList.length,
      isPublic,
      userId: [],
      ownerId: userId,
    });
    for (let i = 0; i < vocabularyList.length; i++) {
      const { englishWord, vietnameseWord, englishMeaning, vietnameseMeaning } =
        vocabularyList[i];
      const vocab = await Vocabulary.create({
        englishWord,
        vietnameseWord,
        englishMeaning,
        vietnameseMeaning,
        topicId: topic._id,
      });
      topic.vocabularyId.push(vocab._id);
    }
    await topic.save();
    topic = await topic.populate("ownerId");
    res.status(200).json({ message: "Import data successfully", topic });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: error.message });
  }
};

const exportCSV = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  try {
    const vocabularies = await Vocabulary.find({ topicId });
    const jsonArray = [];
    for (let i = 0; i < vocabularies.length; i++) {
      const { englishWord, vietnameseWord, englishMeaning, vietnameseMeaning } =
        vocabularies[i];
      jsonArray.push({
        englishWord,
        vietnameseWord,
        englishMeaning,
        vietnameseMeaning,
      });
    }
    res
      .status(200)
      .json({ message: "Export data successfully", data: jsonArray });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTopicsByFolderId = async (req, res) => {
  const folderId = req.params.folderId || req.query.folderId;
  try {
    const topicsInFolder = await TopicInFolder.find({ folderId }).populate({
      path: "topicId",
      populate: {
        path: "ownerId",
      },
    });
    if (topicsInFolder.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    const topicsWithTimeAdded = topicsInFolder.map((topicInFolder) => ({
      topic: topicInFolder.topicId,
      timeAdded: topicInFolder.dateTimeAdded,
    }));
    res.status(200).json({ topics: topicsWithTimeAdded });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const viewTopicIsPublic = async (req, res) => {
  const userId = req.params.userId || req.query.userId;
  try {
    const topicIsPublic = await Topic.find({ userId, isPublic: true });
    if (topicIsPublic.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    res.status(200).json({ topicIsPublic });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const findPublicTopic = async (req, res) => {
  const userId = req.params.userId || req.query.userId;
  try {
    const publicTopics = await Topic.find({
      isPublic: true,
      userId: { $ne: userId },
    });
    if (publicTopics.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    res.status(200).json({ publicTopics });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const userLearnPublicTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const userId = req.user.data._id;

  try {
    const topic = await Topic.findById(topicId);
    if (!topic.isPublic) {
      return res.status(403).json({ message: "Topic is not public" });
    }

    // Thêm topic vào danh sách của người dùng
    if (!topic.userId.includes(userId)) {
      await Topic.findByIdAndUpdate(topicId, { $push: { userId } });
      await Users.findByIdAndUpdate(userId, { $push: { topicId: topic._id } });
    }
    res.status(200).json({ message: "Topic added to user successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getBookmarkVocabInTopic = async (req, res) => {
  const topicId = req.params.id || req.query.id;
  const userId = req.user.data._id;
  try {
    // get bookmark vocab in topic
    const vocabInTopic = await Topic.findById(topicId).populate("vocabularyId");
    let bookmarkVocab = [];
    for (let i = 0; i < vocabInTopic.vocabularyId.length; i++) {
      const bookmark = await BookmarkVocabulary.findOne({
        vocabularyId: vocabInTopic.vocabularyId[i]._id,
        userId,
      });
      if (bookmark) {
        bookmarkVocab.push(vocabInTopic.vocabularyId[i]);
      }
    }
    res.status(200).json({ bookmarkVocab });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getAllPublicTopics = async (req, res) => {
  const userId = req.user.data._id;
  try {
    const topics = await Topic.find({
      isPublic: true,
      ownerId: { $ne: userId },
    })
      .populate("ownerId")
      .exec();
    if (topics.length === 0) {
      res.status(404).json({ error: "Topics not found" });
      return;
    }
    res.status(200).json({ topics });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  getTopicById,
  getAllTopics,
  updateTopic,
  deleteTopic,
  createVocabularyInTopic,
  deleteVocabularyInTopic,
  upVoteCount,
  downVoteCount,
  editVocabularyInTopic,
  importCSV,
  exportCSV,
  getTopicsByUserId,
  getTopicsByFolderId,
  viewTopicIsPublic,
  userLearnPublicTopic,
  getFolderByTopicId,
  getBookmarkVocabInTopic,
  getAllPublicTopics,
  findPublicTopic,
};
