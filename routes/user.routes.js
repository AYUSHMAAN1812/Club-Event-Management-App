const userRouter = require("express").Router();
const UserController = require('../controller/user.controller');

userRouter.post("/register_user",UserController.register);

userRouter.post("/login_user", UserController.login);

module.exports = userRouter;