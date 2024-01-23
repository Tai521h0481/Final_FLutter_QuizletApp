const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const FolderSchema = new Schema({
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    folderNameEnglish: { type: String, required: true },
    folderNameVietnamese: { type: String, required: true },
    topicCount : { type : Number, default: 0 },
    topicInFolderId : [{ type: Schema.Types.ObjectId, ref: 'TopicInFolder' }],
});

const Folder = mongoose.model('Folder', FolderSchema);
module.exports = Folder;