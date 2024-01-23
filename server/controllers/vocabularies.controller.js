const {Vocabulary, Topic} = require('../models');

const getVocabularies = async (req, res) => {
    try {
        const vocabularies = await Vocabulary.find();
        res.status(200).json({vocabularies, size: vocabularies.length});
    } catch (error) {
        res.status(500).json({ error : error.message });
    }
}

const getVocabularyById = async (req, res) => {
    const id = req.params.id || req.query.id;
    try {
        const vocabulary = await Vocabulary.findById(id);
        res.status(200).json({vocabulary});
    } catch (error) {
        res.status(500).json({ error : error.message });
    }
}

const getVocabularyByTopicId = async (req, res) => {
    const topicId = req.params.topicId || req.query.topicId;
    try {
        const vocabularies = await Vocabulary.find({topicId});
        if(vocabularies.length === 0){
            res.status(404).json({error: "Topic does not have any vocabulary"});
            return;
        }
        res.status(200).json({vocabularies});
    } catch (error) {
        res.status(500).json({ error : error.message });
    }
}

module.exports = {
    getVocabularies,
    getVocabularyById,
    getVocabularyByTopicId
}