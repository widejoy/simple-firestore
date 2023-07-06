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
exports.newfunction = functions.firestore
  .document("data/{messageId}").onDelete((snapshot, context) => {
    return admin.messaging().sendToTopic("item", {
      notification: {
        title: 'An item has been removed',
        body: snapshot.data()["name"],
        clickAction: "page_2",
      },
    });
  });




