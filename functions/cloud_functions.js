const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotificationToUsers = functions.https.onCall(async (data, context) => {
  const tokens = data.tokens;
  const payload = {
    notification: {
      title: data.title,
      body: data.body,
    },
  };

  try {
    const response = await admin.messaging().sendToDevice(tokens, payload);
    return { success: true, response };
  } catch (error) {
    throw new functions.https.HttpsError('unknown', error.message, error);
  }
});
