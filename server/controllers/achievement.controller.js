const {Achievement} = require('../models');

const createAchievement = async (req, res) => {
    const {listAchievement} = req.body;
    try {
        const achievements = await Achievement.insertMany(listAchievement);
        res.status(200).json({ achievements });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const getAllAchievement = async (req, res) => {
    try {
        const achievements = await Achievement.find();
        res.status(200).json({ achievements });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};


module.exports = {
    createAchievement,
    getAllAchievement
};