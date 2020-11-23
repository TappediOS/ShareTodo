const assert = require('assert');
const firebase = require('@firebase/rules-unit-testing');
const MY_PROJECT_ID = "sharetodo-a91ef";

const myId = "user_me";
const otherId = "user_other";

const myAuth = { uid: myId, };

function getFirestore(auth) {
    return firebase.initializeTestApp({projectId: MY_PROJECT_ID, auth: auth}).firestore();
}

function getAdminFirestore() {
    return firebase.initializeAdminApp({projectId: MY_PROJECT_ID}).firestore();
}

beforeEach(async () => {
    //await firebase.clearFirestoreData({projectId: MY_PROJECT_ID});
});


describe("user collectionのreadに対するテスト", () => {
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

describe("groupCollectionのreadに対するテスト", () => {
    it("GroupMembersに自分が含まれていたらlistとしてReadできること", async () => {
        const db = getFirestore(myAuth);
        const testQuery = db.collection("todo/v1/groups").where("members", "array-contains", myId);
        await firebase.assertSucceeds(testQuery.get());
    });

    it("GroupMembersに自分が含まれていても認証してなければReadできないこと", async () => {
        const db = getFirestore(null);
        const testQuery = db.collection("todo/v1/groups").where("members", "array-contains", myId);
        await firebase.assertFails(testQuery.get());
    });

    it("GroupMembersに自分が含まれているドキュメントはReadできること", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testRead = db.collection("todo/v1/groups").doc(groupID);
        await firebase.assertSucceeds(testRead.get());
    });

    it("GroupMembersに自分が含まれていないドキュメントはReadできないこと", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsNotContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", "huga"], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testRead = db.collection("todo/v1/groups").doc(groupID);
        await firebase.assertFails(testRead.get());
    });
});