const db = require('config');
const bcrypt = require("bcrypt");
const express = require('express');
const { Schema } = express;

const adminSchema = new Schema({
    email: {
        type: String,
        lowercase: true,
        required: [true, "userName can't be empty"],
        // @ts-ignore
        match: [
            /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
            "userName format is not correct",
        ],
        unique: true,
    },
    password: {
        type: String,
        required: [true, "password is required"],
    },
},{timestamps:true});


// used while encrypting admin entered password
adminSchema.pre("save",async function(){
    var admin = this;
    if(!admin.isModified("password")){
        return
    }
    try{
        const salt = await bcrypt.genSalt(10);
        const hash = await bcrypt.hash(admin.password,salt);

        admin.password = hash;
    }catch(err){
        throw err;
    }
});


//used while signIn decrypt
adminSchema.methods.comparePassword = async function (candidatePassword) {
    try {
        console.log('----------------no password',this.password);
        // @ts-ignore
        const isMatch = await bcrypt.compare(candidatePassword, this.password);
        return isMatch;
    } catch (error) {
        throw error;
    }
};

const AdminModel = db.model('admin',adminSchema);
module.exports = AdminModel;