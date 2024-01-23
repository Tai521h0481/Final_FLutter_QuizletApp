const express = require('express');
const achievementRouter = express.Router();

const {createAchievement,
    getAllAchievement} = require('../controllers/achievement.controller');

achievementRouter.post('/', createAchievement);
achievementRouter.get('/', getAllAchievement);

module.exports = achievementRouter;