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


describe("user collectionのread対するテスト", () => {
    it("自分のデータを読み取ることができる", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        await firebase.assertSucceeds(myDoc.get());
    });

    it("認証していれば，他人のデータを読み取ることができる", async () => {
        const db = getFirestore(myAuth);
        const otherDoc = db.collection("todo/v1/users").doc(otherId);
        await firebase.assertSucceeds(otherDoc.get());
    });

    it("認証していなければ，どのデータも読み取ることはできない", async () => {
        const db = getFirestore(null);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        const otherDoc = db.collection("todo/v1/users").doc(otherId);
        await firebase.assertFails(myDoc.get());
        await firebase.assertFails(otherDoc.get());
    });
});

describe("user collectionのwrite対するテスト", () => {
    it("認証していればそのIDに対してcreateできる", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        await firebase.assertSucceeds(myDoc.set({
            name: "hoge",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
    });

    it("他人のドキュメントに対してcreateできない", async () => {
        const db = getFirestore(myAuth);
        const otherDoc = db.collection("todo/v1/users").doc(otherId);
        await firebase.assertFails(otherDoc.set({
            name: "hoge",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
    });

    it("名前が0文字ならcreateできない", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        await firebase.assertFails(myDoc.set({
            name: "",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
    });

    it("名前が20文字を超えるならcreateできない", async () => {
        const db = getFirestore(myAuth);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        await firebase.assertFails(myDoc.set({
            name: "12345678901234567890_out",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
    });

    it("認証していなければ，データは作れない", async () => {
        const db = getFirestore(null);
        const myDoc = db.collection("todo/v1/users").doc(myId);
        const otherDoc = db.collection("todo/v1/users").doc(otherId);
        await firebase.assertFails(myDoc.set({
            name: "hoge",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
        await firebase.assertFails(otherDoc.set({
            name: "hoge",
            profileImageURL: "fuga",
            fcmToken: "ex"
        }));
    });
});