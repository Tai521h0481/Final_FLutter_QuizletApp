const {LearningStatistics, Vocabulary, VocabularyStatistic} = require('../models');

const updateLearningStatistic = async (req, res) => {
    const { learningTime } = req.body;
    const { topicId } = req.params;
    const userId = req.user.data._id;
    try {
        const learningStatistic = await LearningStatistics.findOne({ userId, topicId });
        if (!learningStatistic) {
            const newLearningStatistic = new LearningStatistics({ userId, topicId, learningPercentage : 0, learningTime, learningCount : 1, vocabLearned: 0});
            await newLearningStatistic.save();
        }else{
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
            let learningPercentage = 0;
            let learnedVocabularies = 0;
            for(let statistics of vocabStats){
                if(statistics.statistic.learningCount <= 1){
                    learningPercentage += 0;
                }
                else if(statistics.statistic.learningCount <= 5){
                    learningPercentage += (1/vocabularies.length)/2;
                }
                else{
                    learningPercentage += 1/vocabularies.length;
                    learnedVocabularies += 1;
                }
            }
    
            learningStatistic.learningPercentage = learningPercentage;
            learningStatistic.learningTime += learningTime;
            learningStatistic.learningCount += 1;
            learningStatistic.vocabLearned = learnedVocabularies;
            await learningStatistic.save();
        }
        return res.status(200).json({ message: 'Update learning statistic successfully', learningStatistic });
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

const getProcessLearning = async (req, res) => {
    const { topicId } = req.params;
    const userId = req.user.data._id;
    try {
        const learningStatistic = await LearningStatistics.findOne({ userId, topicId });
        if (!learningStatistic) {
            return res.status(200).json({ message: 'Get learning statistic successfully', learningStatistic: {userId, topicId ,learningPercentage: 0, learningTime: 0, learningCount: 0, vocabLearned: 0 } });
        }
        return res.status(200).json({ message: 'Get learning statistic successfully', learningStatistic });
    } catch (error) {
        return res.status(500).json({ message: error.message });
    }
}

const getAllStatisticsForTopic = async (req, res) => {
    const {topicId} = req.params;
    try {
        const learningStatistic = await LearningStatistics.find({topicId}).populate("userId");
        return res.status(200).json({learningStatistic});
    }
    catch(error){
        return res.status(500).json({error: error.message})
    }
}

const getUserStatisticForTopic = async (req, res)=>{
    const {topicId, userId} = req.params;
    try{
        const learningStatistic = await LearningStatistics.findOne({topicId, userId}).populate("userId").exec();
        return res.status(200).json({learningStatistic});
    }catch(error){
        return res.status(500).json({error : error.message});
    }
}

module.exports = {
    updateLearningStatistic,
    getProcessLearning,
    getAllStatisticsForTopic,
    getUserStatisticForTopic
}