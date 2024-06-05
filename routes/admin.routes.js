const adminRouter = require("express").Router();
const AdminController = require('../controller/admin.controller');

adminRouter.post("/login", AdminController.login);


module.exports = adminRouter;