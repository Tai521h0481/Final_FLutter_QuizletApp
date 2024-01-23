const mongoose = require('mongoose');

const validateInput = (requiredFields) => (req, res, next) => {
    for (const field of requiredFields) {
        if (!req.body[field]) {
            res.status(400).json({ error: `Missing field ${field}` });
            return;
        }
        if (typeof req.body[field] === 'string') {
            const value = req.body[field].trim();
            if (value.length === 0) {
                res.status(400).json({ error: `The field ${field} cannot be empty` });
                return;
            }
        }
    }
    next();
};

const isExistId = (Model) => async (req, res, next) => {
    const id = req.params.id || req.body.id || req.query.id;
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({ error: `${Model.name} does not exist with id: ${id}` });
    }
    try {
        const model = await Model.findById(id);
        if (!model) {
            return res.status(404).json({ error: `${Model.name} does not exist with id: ${id}` });
        } else {
            next();
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const checkId = (Model, nameId) => async (req, res, next) => {
    const id = req.params[nameId] || req.body[nameId] || req.query[nameId];
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(400).json({ error: `${Model.name} does not exist with id: ${id}` });
    }
    try {
        const model = await Model.findById(id);
        if (!model) {
            return res.status(404).json({ error: `${Model.name} does not exist with id: ${id}` });
        } else {
            next();
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

const isCreated = (Model) => async (req, res, next) => {
    const email = req.body.email || req.query.email || req.params.email;
    try {
        const user = await Model.findOne({ email });
        if (user) {
            res.status(409).json({ error: `Email: ${email} already exists`, code: 409});
        } else {
            next();
        }
    } catch (error) {
        res.status(500).json({ error: error.message, code: 500 });
    }
};

const isExistEmail = (Model) => async (req, res, next) => {
    const email = req.body.email || req.query.email || req.params.email;
    try {
        const user = await Model.findOne({ email });
        if (!user) {
            res.status(404).json({ error: `Email: ${email} does not exists` });
        } else {
            next();
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

const isCreatedUsername = (Model) => async (req, res, next) => {
    const username = req.body.username || req.query.username || req.params.username;
    try {
        const user = await Model.findOne({ username });
        if(user){
            res.status(409).json({ error: `Username: ${username} already exists` });
        }
        else{
            next();
        }
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
}

module.exports = {
    validateInput,
    isExistId,
    isCreated,
    isExistEmail,
    isCreatedUsername,
    checkId
};