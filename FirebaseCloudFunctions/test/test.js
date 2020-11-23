const assert = require('assert');
const firebase = require('@firebase/rules-unit-testing');
const MY_PROJECT_ID = "sharetodo-a91ef";
const serverTimestamp = () => firebase.firestore.FieldValue.serverTimestamp();

const myId = "user_me";
const otherId = "user_other";

const myAuth = { uid: myId, };

function getFirestore(auth) {
    return firebase.initializeTestApp( {projectId: MY_PROJECT_ID, auth: auth}).firestore();
}

beforeEach(async () => {
    await firebase.clearFirestoreData({projectId: MY_PROJECT_ID});
});


describe("user collectionに対するUnitTest", () => {
    it("自分のデータを読み取ることができる", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        await firebase.assertSucceeds(myDoc.get());
    });

    it("他人のデータを読み取ることができない", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(otherId);
        await firebase.assertFails(myDoc.get());
    });
});