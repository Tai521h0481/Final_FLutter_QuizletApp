const express = require('express');
const vocabularyStatisticsRouter = express.Router();

const { Topic, Users, Vocabulary } = require('../models');
const { authentication } = require('../middlewares/authentication/authenticate');

const {create_updateVocabularyStatistic,
    getVocabularyStatisticByTopicId,
    getVocabularyStatisticByUserId,
    getVocabularyStatisticByVocabularyId} = require('../controllers/vocabularyStatistics.controller');

// create or update vocabulary statistic (tested)
vocabularyStatisticsRouter.post("/", authentication , create_updateVocabularyStatistic);
// get vocabulary statistic by topic id (tested)
vocabularyStatisticsRouter.get("/topics/:topicId", authentication, getVocabularyStatisticByTopicId);
// get vocabulary statistic by user id (tested)
vocabularyStatisticsRouter.get("/users", authentication, getVocabularyStatisticByUserId);
// get vocabulary statistic by vocabulary id (tested)
vocabularyStatisticsRouter.get("/vocabularies/:vocabularyId", authentication, getVocabularyStatisticByVocabularyId);

module.exports = vocabularyStatisticsRouter;