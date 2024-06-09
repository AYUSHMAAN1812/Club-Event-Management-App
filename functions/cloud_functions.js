const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotificationToUsers = functions.https.onCall(async (data, context) => {
  const { tokens, title, body } = data;

  const message = {
    notification: {
      title: title,
      body: body,
    },
    tokens: tokens,
  };

  try {
    const response = await admin.messaging().sendMulticast(message);
    return { success: true, response };
  } catch (error) {
    return { success: false, error: error.message };
  }
});
