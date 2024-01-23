const express = require('express');
const bookmarkTopicRouter = express.Router();

const { BookmarkTopic } = require('../models');
const { authentication } = require('../middlewares/authentication/authenticate');
const { isExistId, validateInput, checkId } = require('../middlewares/validation/validation');
const { createBookmarkTopic,
    deleteBookmarkTopic, getAllBookmarkTopic } = require('../controllers/bookmarkTopic.controller');

bookmarkTopicRouter.post("/", authentication, createBookmarkTopic);
bookmarkTopicRouter.delete("/:id", authentication, isExistId(BookmarkTopic), deleteBookmarkTopic);
bookmarkTopicRouter.get("/", authentication, getAllBookmarkTopic);

module.exports = bookmarkTopicRouter;