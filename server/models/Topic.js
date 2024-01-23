const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TopicSchema = new Schema({
    topicNameEnglish: { type: String, required: true },
    topicNameVietnamese: { type: String, required: true },
    vocabularyCount : { type : Number, default: 0 },
    isPublic : { type : Boolean, default: false },
    upVoteCount : { type : Number, default: 0 },
    downVoteCount : { type : Number, default: 0 },
    descriptionEnglish: { type: String, required: true },
    descriptionVietnamese: { type: String, required: true },
    userId: [{ type: Schema.Types.ObjectId, ref: 'User'}],
    ownerId : { type: Schema.Types.ObjectId, ref: 'User'},
    learningStatisticsId: [{ type: Schema.Types.ObjectId, ref: 'LearningStatistics'}],
    topicInFolderId: [{ type: Schema.Types.ObjectId, ref: 'TopicInFolder' }],
    vocabularyId: [{ type: Schema.Types.ObjectId, ref: 'Vocabulary' }],
    folderId : [{ type: Schema.Types.ObjectId, ref: 'Folder'}],
});

const Topic = mongoose.model('Topic', TopicSchema);
module.exports = Topic;