require('dotenv').config();

const cloudinary = require('cloudinary').v2;
const multer = require('multer');
const { CloudinaryStorage } = require('multer-storage-cloudinary');

const cloud_name = process.env.CLOUD_NAME;
const api_key = process.env.API_KEY;
const api_secret = process.env.API_SECRET_KEY;
const fileSize = process.env.fileImageSize;
const folder = process.env.folderNameCloudinary;

cloudinary.config({
  cloud_name,
  api_key,
  api_secret
});

const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  allowedFormats: ['jpg', 'png', 'jpeg'],
  params: {
    folder,
  },
});

const uploadImg = multer({
  storage: storage,
  fileFilter: function (req, file, cb) {
    if (!file.mimetype.startsWith('image/')) {
      return cb(new Error('Not an image!'), false);
    }
    cb(null, true);
  },
  limits: {
    fileSize
  }
});

module.exports = {
  uploadImg,
};