const gravatar = require("gravatar");
require("dotenv").config();
const jwt = require("jsonwebtoken");
const { Users } = require("../models");

const { TOKEN_TIME, TOKEN_SECRET_KEY } = process.env;
const avatarSize = process.env.avatarSize;
const userMail = process.env.userMail;
const passMail = process.env.passMail;
const nodemailer = require("nodemailer");

let transporter = nodemailer.createTransport({
  service: "hotmail",
  auth: {
    user: userMail,
    pass: passMail,
  },
});

const sendEmail = (email, password, res) => {
  const emailTemplate = `
        <html>
            <head>
                <style>
                    .email-container {
                        background-color: #f4f4f4;
                        padding: 20px;
                        max-width: 600px;
                        margin: auto;
                        border-radius: 8px;
                    }
                    .email-header {
                        text-align: center;
                        margin-bottom: 20px;
                    }
                    .email-content {
                        background-color: #ffffff;
                        padding: 20px;
                        border-radius: 5px;
                    }
                </style>
            </head>
            <body>
                <div class="email-container">
                    <div class="email-header">
                        <h2>Password Recovery</h2>
                    </div>
                    <div class="email-content">
                        <p>Hello, This is TNN App</p>
                        <p>Your password is: "<strong>${password}</strong>"</p>
                        <p>Please change your password after logging in.</p>
                    </div>
                </div>
            </body>
        </html>
    `;

  let mailOptions = {
    from: userMail,
    to: email,
    subject: "Password recovery",
    html: emailTemplate,
  };

  transporter.sendMail(mailOptions, (error, info) => {
    if (error) {
      res.status(500).json({ error: error.message });
    } else {
      res.status(200).json({ message: "Email sent" });
    }
  });
};

const createUser = async (req, res) => {
  let { email, password, profileImage } = req.body;
  try {
    email = email.toLowerCase();
    let username = email.split("@")[0];
    if (!profileImage) {
      profileImage = gravatar.url(email, {
        s: avatarSize,
        r: "x",
        d: "retro",
        protocol: "https",
      });
    }
    const user = await Users.create({
      email,
      password,
      profileImage,
      username,
    });
    user.password = undefined;
    res.status(200).json({ user, code: 200 });
  } catch (error) {
    res.status(500).json({ error: error.message, code: 500 });
  }
};

const login = async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await Users.findOne({ email, password }).select("-password");
    if (!user) {
      res.status(401).json({ error: "email or password is incorrect" });
      return;
    }
    const token = jwt.sign({ data: user }, TOKEN_SECRET_KEY, {
      expiresIn: TOKEN_TIME,
    });
    res.status(200).json({ user, token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updatePremium = async (req, res) => {
  const id = req.params.id || req.query.id;
  try {
    const user = await Users.findByIdAndUpdate(
      id,
      { isPremiumAccount: true },
      { new: true }
    ).select("-password");
    res.status(200).json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const changePassword = async (req, res) => {
  const id = req.params.id || req.query.id;
  const { password, newPassword } = req.body;
  try {
    const user = await Users.findOne({ _id: id, password });
    if (!user) {
      res.status(401).json({ error: "password is incorrect" });
      return;
    }
    user.password = newPassword;
    await user.save();
    user.password = undefined;
    res.status(200).json({ message: "Change password successfully", user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  const id = req.params.id || req.query.id;
  const { username } = req.body;
  try {
    const check = await Users.findById(id);
    if (check.username !== username) {
      const user = await Users.findOne({ username });
      if (user) {
        res.status(409).json({ error: `Username: ${username} already exists` });
        return;
      }
    }
    const user = await Users.findByIdAndUpdate(
      id,
      { username },
      { new: true }
    ).select("-password");
    res.status(200).json({ message: "Update user successfully", user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const uploadImage = async (req, res) => {
  const { file } = req;
  const urlImg = file?.path;
  const id = req.params.id || req.query.id;
  try {
    const user = await Users.findByIdAndUpdate(
      id,
      { profileImage: urlImg },
      { new: true }
    ).select("-password");
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }
    res
      .status(200)
      .json({ message: "Change profile image successfully", user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const passwordRecovery = async (req, res) => {
  const { email } = req.body;
  try {
    const user = await Users.findOne({ email });
    sendEmail(email, user.password, res);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getAllUsers = async (req, res) => {
  try {
    const users = await Users.find().select("-password");
    if (users.length === 0) {
      res.status(404).send({ error: "list users are empty" });
      return;
    }
    res.status(200).json({ users });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getUserById = async (req, res) => {
  const id = req.params.id || req.query.id;
  try {
    const user = await Users.findById(id).select("-password");
    res.status(200).json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const getTopicByUser = async (req, res) => {
  const userId = req.user.data._id;
  try {
    const user = await Users.findById(userId).populate("topicId");
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }
    res.status(200).json({ user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const addAchieveToUser = async (req, res) => {
  const achieveId = req.query.achieveId || req.params.achieveId;
  const userId = req.user._id;
  try {
    const user = await Users.findById(userId);
    if (!user) {
      res.status(404).json({ error: "User not found" });
      return;
    }
    user.achievementId.push(achieveId);
    await user.save();
    res
      .status(200)
      .json({ message: "Add achievement to user successfully", user });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

module.exports = {
  createUser,
  login,
  updatePremium,
  changePassword,
  updateUser,
  uploadImage,
  passwordRecovery,
  getAllUsers,
  getUserById,
  addAchieveToUser,
  getTopicByUser,
};
