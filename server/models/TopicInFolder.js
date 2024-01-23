const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const TopicInFolderSchema = new Schema({
    folderId: { type: Schema.Types.ObjectId, ref: 'Folder', required: true },
    topicId: { type: Schema.Types.ObjectId, ref: 'Topic', required: true },
    dateTimeAdded : { type : Date, default: Date.now }
});

const TopicInFolder = mongoose.model('TopicInFolder', TopicInFolderSchema);
module.exports = TopicInFolder;