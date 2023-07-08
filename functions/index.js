const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("data/{messageId}")
  .onCreate((snapshot, context) => {
    const { name, age } = snapshot.data();

    return admin.messaging().sendToTopic("item", {
      notification: {
        title: name,
        body: age,
        android: {
          notification: {
            clickAction: "page_1",
          },
        },
      },
    });
  });

exports.newFunction = functions.firestore
  .document("data/{messageId}")
  .onDelete((snapshot, context) => {
    const { name } = snapshot.data();

    return admin.messaging().sendToTopic("item", {
      notification: {
        title: 'An item has been removed',
        body: name,
        android: {
          notification: {
            clickAction: "page_2",
          },
        },
      },
    });
  });
