const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const BookmarkTopicSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    topicId: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
    bookmarkTime : { type : Date, default: Date.now }
});

const BookmarkTopic = mongoose.model('BookmarkTopic', BookmarkTopicSchema);
module.exports = BookmarkTopic;