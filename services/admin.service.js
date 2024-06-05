const AdminModel = require("../models/user.model");
const jwt = require("jsonwebtoken");

class AdminServices{

    static async getAdminByEmail(email){
        try{
            return await AdminModel.findOne({email});
        }catch(err){
            console.log(err);
        }
    }

    static async checkAdmin(email){
        try {
            return await AdminModel.findOne({email});
        } catch (error) {
            throw error;
        }
    }

    static async generateAccessToken(tokenData,JWTSecret_Key,JWT_EXPIRE){
        return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
    }
}

module.exports = AdminServices;