const express = require('express');
const learningStatisticsRouter = express.Router();

const {LearningStatistics} = require('../models');
const { authentication } = require('../middlewares/authentication/authenticate');
const { isExistId, validateInput, checkId } = require('../middlewares/validation/validation');
const { getProcessLearning, updateLearningStatistic, getAllStatisticsForTopic, getUserStatisticForTopic } = require('../controllers/learningStatistics.controller');
// get process learning
learningStatisticsRouter.get("/topic/:topicId/progress", authentication, getProcessLearning);
// update learning statistic
learningStatisticsRouter.put("/topic/:topicId/progress", authentication, updateLearningStatistic);
// get learning statistics of users in a topic
learningStatisticsRouter.get("/topic/:topicId", getAllStatisticsForTopic)
// get user learning statistics for topic
learningStatisticsRouter.get("/topic/:topicId/user/:userId",authentication, getUserStatisticForTopic);

module.exports = learningStatisticsRouter;