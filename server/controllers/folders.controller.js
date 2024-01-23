const { Folder, Topic, TopicInFolder } = require('../models');

const createFolder = async (req, res) => {
    const { folderNameEnglish, folderNameVietnamese } = req.body;
    const user = req.user;
    try {
        const folder = await Folder.create({ folderNameEnglish, folderNameVietnamese, userId: user.data._id });
        res.status(200).json({ folder });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const updateFolder = async (req, res) => {
    const id = req.params.id || req.query.id;
    const { folderNameEnglish, folderNameVietnamese } = req.body;
    try {
        const folder = await Folder.findByIdAndUpdate(id, { folderNameEnglish, folderNameVietnamese }, { new: true });
        res.status(200).json({ message: "update folder successfully", folder });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const deleteFolder = async (req, res) => {
    const id = req.params.id || req.query.id;
    try {
        await TopicInFolder.deleteMany({ folderId: id });
        await Folder.findByIdAndDelete(id);
        res.status(200).json({ message: "delete folder successfully" });
    }
    catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const addTopicToFolder = async (req, res) => {
    const folderId = req.params.id || req.query.id;
    const topicId = req.params.topicId || req.query.topicId;
    try {
        const check = await TopicInFolder.findOne({ folderId, topicId });
        if (check) {
            res.status(409).json({ error: "Topic already exists in folder" });
            return;
        }
        const topicInFolder = await TopicInFolder.create({ folderId, topicId });
        const folder = await Folder.findByIdAndUpdate(folderId, { $inc: { topicCount: 1 }, $push: { topicInFolderId: topicInFolder._id } }, { new: true });
        await Topic.findByIdAndUpdate(topicId, { $push: { topicInFolderId: topicInFolder._id, folderId }});
        res.status(200).json({ message: "add topic to folder successfully", folder, dateTimeAdded: topicInFolder.dateTimeAdded });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const deleteTopicInFolder = async (req, res) => {
    const folderId = req.params.id || req.query.id;
    const topicId = req.params.topicId || req.query.topicId;
    try {
        const topicInFolder = await TopicInFolder.findOne({ folderId, topicId });
        if (!topicInFolder) {
            res.status(404).json({ error: "Topic does not exist in folder" });
            return;
        }
        await TopicInFolder.findByIdAndDelete(topicInFolder._id);
        const folder = await Folder.findByIdAndUpdate(folderId, { $inc: { topicCount: -1 }, $pull: {topicInFolderId : topicId} }, { new: true });
        await Topic.findByIdAndUpdate(topicId, { $pull: { topicInFolderId: topicInFolder._id, folderId } });
        res.status(200).json({ folder });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const getFolderById = async (req, res) => {
    const id = req.params.id || req.query.id;
    try {
        const folder = await Folder.findById(id);
        res.status(200).json({ folder });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const getAllFolders = async (req, res) => {
    try {
        const folders = await Folder.find();
        if (folders.length === 0) {
            res.status(404).json({ error: "Folders not found" });
            return;
        }
        res.status(200).json({ folders });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const getFodersByUserId = async (req, res) => {
    const userId = req.params.id || req.query.id;
    try {
        const folders = await Folder.find({ userId });
        if (folders.length === 0) {
            res.status(404).json({ error: "Folders not found" });
            return;
        }
        res.status(200).json({ folders });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

module.exports = {
    getFolderById,
    getAllFolders,
    createFolder,
    addTopicToFolder,
    updateFolder,
    deleteFolder,
    deleteTopicInFolder,
    getFodersByUserId
}