const express = require("express");
const bodyParser = require("body-parser")
const UserRoute = require("./routes/user.routes");
const AdminRoute = require("./routes/admin.routes");

const app = express();

app.use(bodyParser.json())

app.use("/",UserRoute);
app.use("/",AdminRoute);

module.exports = app;