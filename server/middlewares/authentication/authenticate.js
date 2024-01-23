const jwt = require("jsonwebtoken");
require('dotenv').config();
const SECRET_key = process.env.TOKEN_SECRET_KEY;

const authentication = (req, res, next) => {
    const token = req.cookies?.token || req.headers.token || req.body.token || req.query.token; 
    if(token){
        try {
            const decoded = jwt.verify(token, SECRET_key);
            if(decoded){
                req.user = decoded;
                next();
            }
            else{
                res.status(401).json({error: "token is invalid"});
            }
        } catch (error) {
            res.status(401).send({error: "token is invalid"});
        }
    }else{
        res.status(401).json({error: "token is required"});
    }
}

module.exports = {authentication};