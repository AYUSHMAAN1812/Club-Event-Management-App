const AdminServices = require('../services/admin.service');


exports.login = async (req, res, next) => {
    try {

        const { email, password } = req.body;

        if (!email || !password) {
            throw new Error('Parameter are not correct');
        }
        let admin = await AdminServices.checkAdmin(email);
        if (!admin) {
            throw new Error('User does not exist');
        }

        const isPasswordCorrect = await admin.comparePassword(password);

        if (isPasswordCorrect === false) {
            throw new Error(`Username or Password does not match`);
        }

        // Creating Token

        let tokenData;
        tokenData = { _id: admin._id, email: admin.email };
    

        const token = await AdminServices.generateAccessToken(tokenData,"secret","1h")

        res.status(200).json({ status: true, success: "sendData", token: token });
    } catch (error) {
        console.log(error, 'err---->');
        next(error);
    }
}