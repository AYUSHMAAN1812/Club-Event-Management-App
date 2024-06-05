const firebase = require("firebase");
const  firebaseConfig = {
  apiKey: "AIzaSyD2S2hIoiu_8XyMzJ3WbPVRKIByx8sYAGQ",
  authDomain: "project1-1dcf0.firebaseapp.com",
  projectId: "project1-1dcf0",
  storageBucket: "project1-1dcf0.appspot.com",
  messagingSenderId: "929831393635",
  appId: "1:929831393635:web:06cd5c6a7c14977d109b56",
  measurementId: "G-TWMQKW3SCF"
};
firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();
const User = db.collection("Users");
module.exports = User;