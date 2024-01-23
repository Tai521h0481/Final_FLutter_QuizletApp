const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const VocabularyStatisticSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    vocabularyId: { type: Schema.Types.ObjectId, ref: 'Vocabulary', required: true },
    learningCount : { type : Number, default: 0 },
    learningStatus : {type:String}
});

const VocabularyStatistic = mongoose.model('VocabularyStatistic', VocabularyStatisticSchema);
module.exports = VocabularyStatistic;