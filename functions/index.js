const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
  .document("data/{messageId}")
  .onCreate((snapshot, context) => {
    return admin.messaging().sendToTopic("item", {
      notification: {
        title: snapshot.data()["name"],
        body: snapshot.data()["age"],
        clickAction: "page_1",
      },
    });
  });

  exports.newFunction = functions.firestore
  .document("data/{messageId}")
  .onDelete((snapshot, context) => {
    return admin.messaging().sendToTopic("item", {
      notification: {
        title: "an item has been deleted",
        body: snapshot.data()["name"],
        clickAction: "page_2",
      },
    });
  });