const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const AchievementSchema = new Schema({
    name: { type: String, required: true },
    description: { type: String, required: true },
    image: { type: String, required: true },
    related: {type: String, required: true},
    threshHold: {type: Number, required: true}
});

const Achievement = mongoose.model('Achievement', AchievementSchema);
module.exports = Achievement;