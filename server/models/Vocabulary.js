const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const VocabularySchema = new Schema({
    englishWord: { type: String, required: true },
    vietnameseWord: { type: String, required: true },
    englishMeaning: { type: String },
    vietnameseMeaning: { type: String },
    topicId : { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
    vocabularyStatisticId : [{ type: Schema.Types.ObjectId, ref: 'VocabularyStatistic' }],
    bookmarkVocabularyId : [{ type: Schema.Types.ObjectId, ref: 'BookmarkVocabulary' }],
});

const Vocabulary = mongoose.model('Vocabulary', VocabularySchema);
module.exports = Vocabulary;