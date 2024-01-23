const {VocabularyStatistic, Vocabulary} = require('../models');

const create_updateVocabularyStatistic = async (req, res) => {
    const userId = req.user.data._id;
    const {vocabStats} = req.body;

    try {
        for (let vocabStat of vocabStats) {
            const { vocabularyId, learningCount } = vocabStat;

            const vocab = await Vocabulary.findById(vocabularyId);
            if (!vocab) {
                return res.status(404).json({ error: 'Vocabulary does not exist' });
            }

            let stat = await VocabularyStatistic.findOne({ userId, vocabularyId });

            if (stat) {
                stat.learningCount += learningCount;
                if(stat.learningCount <= 1){
                    stat.learningStatus = 'started';
                }
                else if(stat.learningCount <= 5){
                    stat.learningStatus = 'learning';
                }
                else{
                    stat.learningStatus = 'memorized';
                }
                await stat.save();
            } else {
                stat = new VocabularyStatistic({
                    userId,
                    vocabularyId,
                    learningCount,
                    learningStatus: 'started',
                });
                await stat.save();
            }
        }

        res.status(200).json({ message: 'Vocabulary statistics updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}


const getVocabularyStatisticByTopicId = async (req, res) => {
    const userId = req.user.data._id;
    const topicId = req.params.topicId || req.query.topicId;
    try {
        const vocabularies = await Vocabulary.find({ topicId: topicId });
        const vocabStats = [];

        for (let vocab of vocabularies) {
            const stat = await VocabularyStatistic.findOne({ userId, vocabularyId: vocab._id });
            if(stat){
                vocabStats.push({
                    vocabulary: vocab,
                    statistic: stat
                });    
            }
        }

        res.status(200).json({ vocabStats });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const getVocabularyStatisticByUserId = async (req, res) => {
    const userId = req.user.data._id;
    try {
        const stats = await VocabularyStatistic.find({ userId: userId }).populate('vocabularyId');
        res.status(200).json({ stats });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const getVocabularyStatisticByVocabularyId = async (req, res) => {
    const userId = req.user.data._id;
    const vocabularyId = req.params.id || req.query.id;
    try {
        const stat = await VocabularyStatistic.findOne({ userId, vocabularyId }).populate('vocabularyId');
        if (!stat) {
            return res.status(404).json({ error: 'No statistic found for this vocabulary' });
        }
        res.status(200).json({ stat });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

module.exports = {
    create_updateVocabularyStatistic,
    getVocabularyStatisticByVocabularyId,
    getVocabularyStatisticByTopicId,
    getVocabularyStatisticByUserId
}