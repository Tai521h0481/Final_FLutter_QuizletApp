const {BookmarkTopic} = require('../models');

const createBookmarkTopic = async (req, res) => {
    const userId = req.user.data._id;
    const topicId = req.body.topicId;
    try {
        const bookmarkTopic = await BookmarkTopic.findOne({userId, topicId});
        if(bookmarkTopic){
            return res.status(400).json({error: 'Topic is already bookmarked'});
        }

        const newBookmarkTopic = new BookmarkTopic({
            userId,
            topicId
        });
        await newBookmarkTopic.save();

        res.status(200).json({message: 'Bookmark topic created successfully'});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
}

const deleteBookmarkTopic = async (req, res) => {
    const userId = req.user.data._id;
    const topicId = req.params.id || req.query.id;

    try {
        const bookmarkTopic = await BookmarkTopic.findOne({userId, topicId});
        if(!bookmarkTopic){
            return res.status(404).json({error: 'Bookmark topic not found'});
        }

        await bookmarkTopic.delete();

        res.status(200).json({message: 'Bookmark topic deleted successfully'});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
}

const getAllBookmarkTopic = async (req, res) => {
    const userId = req.user.data._id;
    try {
        const bookmarkTopics = await BookmarkTopic.find({userId}).populate('topicId');
        res.status(200).json({bookmarkTopics});
    } catch (error) {
        res.status(500).json({error: error.message});
    }
}

module.exports = {
    createBookmarkTopic,
    deleteBookmarkTopic,
    getAllBookmarkTopic
}