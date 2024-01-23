const express = require('express');
const vocabulariesRouter = express.Router();

const {Topic} = require('../models');
const { authentication } = require('../middlewares/authentication/authenticate');
const {isExistId, validateInput, checkId} = require('../middlewares/validation/validation');
const {getVocabularies, getVocabularyById, getVocabularyByTopicId} = require('../controllers/vocabularies.controller');

// get all
vocabulariesRouter.get("/", getVocabularies);
// get by id
vocabulariesRouter.get("/:id", getVocabularyById);
// get by topic id
vocabulariesRouter.get("/topics/:topicId", authentication, checkId(Topic, "topicId"), getVocabularyByTopicId);


module.exports = vocabulariesRouter;