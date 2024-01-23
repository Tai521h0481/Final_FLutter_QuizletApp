const express = require('express');
const app = express();
require('dotenv').config();
const mongoose = require('mongoose');
const rootRouter = require('./routers');
const PORT = process.env.PORT || 3000;
app.use(express.json()); 
app.use("/android", rootRouter);
const {MONGO_URL} = process.env;

mongoose.connect(MONGO_URL)
  .then(() => console.log('Connect to mongoDB successfully'))
  .catch(err => console.error('Could not connect to MongoDB', err));

app.listen(PORT,async () => {
    console.log(`Server is running at http://localhost:${PORT}`);
});