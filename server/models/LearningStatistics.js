const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const LearningStatisticsSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    topicId: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
    learningPercentage : { type : Number, default: 0 },
    learningTime : { type : Number, default: 0 },
    learningCount : { type : Number, default: 0 },
    vocabLearned : { type : Number, default: 0 },
});

const LearningStatistics = mongoose.model('LearningStatistics', LearningStatisticsSchema);
module.exports = LearningStatistics;