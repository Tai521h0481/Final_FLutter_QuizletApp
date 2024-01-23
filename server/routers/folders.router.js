const express = require('express');
const foldersRouter = express.Router();

const { Folder, Topic } = require('../models');
const { authentication } = require('../middlewares/authentication/authenticate');
const {isExistId, validateInput, checkId} = require('../middlewares/validation/validation');
const {getFolderById,
    getAllFolders,
    createFolder,
    updateFolder,
    deleteFolder,
    addTopicToFolder,
    deleteTopicInFolder,
    getFodersByUserId} = require('../controllers/folders.controller');

// get all folders (tested)
foldersRouter.get("/", getAllFolders);
// get folder by id (tested)
foldersRouter.get("/:id", isExistId(Folder), getFolderById);
// get folder by user id
foldersRouter.get("/users/:id", authentication, getFodersByUserId);
// create topic 
foldersRouter.post("/", authentication, validateInput(["folderNameEnglish", "folderNameVietnamese"]), createFolder);
// add topic to folder (tested)
foldersRouter.post("/:id/topics/:topicId", authentication, isExistId(Folder), checkId(Topic, "topicId"), addTopicToFolder);
// edit folder (tested)
foldersRouter.put("/:id", authentication, isExistId(Folder), updateFolder);
// delete folder (tested)
foldersRouter.delete("/:id", authentication, isExistId(Folder), deleteFolder);
// delete topic in folder (tested)
foldersRouter.delete("/:id/topics/:topicId", authentication, isExistId(Folder), checkId(Topic, "topicId"), deleteTopicInFolder);


module.exports = foldersRouter;