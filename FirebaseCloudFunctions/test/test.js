const assert = require('assert');
const firebase = require('@firebase/rules-unit-testing');
const { timeStamp } = require('console');
const { firestore } = require('firebase-admin');
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
    await firebase.clearFirestoreData({projectId: MY_PROJECT_ID});
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

describe("groupCollectionのcreateに対するテスト", () => {
    it("認証してて，membersに自分のIDがあればGroupを作れる", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertSucceeds(groupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"}));
    });

    it("membersが自分だけでもGroupを作れる", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertSucceeds(groupDoc.set({members: [myId], name: "Apple", task: "lock"}));
    })

    it("認証してなければどうあってもGroupを作れない", async() => {
        const db = getFirestore(null);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"}));
    });

    it("membersに自分のIDがなければGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"}));
    });

    it("membersが空ならGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertFails(groupDoc.set({members: [], name: "Apple", task: "lock"}));
    });

    it("名前が0文字ならGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "", task: "lock"}));
    });

    it("taskが0文字ならGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "print", task: ""}));
    });

    it("名前が45文字以上ならGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        const name = "123456789012345678901234567890123456789012345678890";
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: name, task: "lock"}));
    });

    it("taskが45文字以上ならGroupを作れない", async() => {
        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc("createdGroupID")
        const task = "123456789012345678901234567890123456789012345678890";
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "print", task: task}));
    });
})

describe("groupCollectionのupdateに対するテスト", () => {
    it("認証してて，membersに自分のIDがあればGroupをupdateできる", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertSucceeds(groupDoc.set({members: [otherId, "hoge", myId], name: "Banana", task: "Write"}), {merge: true});
    });

    it("membersが自分だけでもGroupをupdateできる", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertSucceeds(groupDoc.set({members: [myId], name: "Rips", task: "Run"}), {merge: true});
    })

    it("membersを空にする様なupadteができること", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertSucceeds(groupDoc.set({members: [], name: "Cat", task: "logout"}), {merge: true});
    });

    it("認証してなければどうあってもGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(null);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "japan", task: "eat"}), {merge: true});
    });

    it("元々のmembersに自分のIDがなければ勝手に自分を入れてGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "en", task: "be good"}), {merge: true});
    });

    it("元々のmembersに自分のIDがなければ勝手にMemberを改変してGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertFails(groupDoc.set({members: [otherId], name: "en", task: "be good"}), {merge: true});
    });

    it("名前が0文字ならGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "", task: "lock"}));
    });

    it("taskが0文字ならGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "print", task: ""}));
    });

    it("名前が45文字以上ならGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        const name = "123456789012345678901234567890123456789012345678890";
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: name, task: "lock"}));
    });

    it("taskが45文字以上ならGroupをupdateできない", async() => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID"
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const groupDoc = db.collection("todo/v1/groups").doc(groupID)
        const task = "123456789012345678901234567890123456789012345678890";
        await firebase.assertFails(groupDoc.set({members: [otherId, "hoge", myId], name: "print", task: task}));
    });

});

describe("groups/todoのreadに対するテスト", () => {
    it("GroupMembersに自分が含まれていたらlistとしてtodoをReadできること", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`)
        await firebase.assertSucceeds(testDoc.get());
    });

    it("GroupMembersに自分が含まれていなければlistとしてtodoをReadできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`)
        await firebase.assertFails(testDoc.get());
    });

    it("認証していなければlistとしてtodoをReadできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});

        const db = getFirestore(null);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`)
        await firebase.assertFails(testDoc.get());
    });

});

describe("groups/todoのcreateに対するテスト", () => {
    it("GroupMembersに自分が含まれていて，かつ，userIdが自分自身で，かつ，isFinishedがtrueならcreateできること", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertSucceeds(testDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));
    });

    it("GroupMembersに自分が含まれていないならcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));
    });

    it("groupIDが違うならcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: "otherGroupID", isFinished: true, userID: myAuth.uid}));
    });

    it("isFinishedがfalseならcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: false, userID: myAuth.uid}));
    });

    it("userIDが違うならcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: true, userID: otherId}));
    });

    it("他人が勝手にcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: ["hoge", myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(otherId);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: true, userID: otherId}));
    });

    it("自分さえ含まれていればcreateできること", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertSucceeds(testDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));
    });

    it("認証してないならcreateできないこと", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myAuth.uid], name: "Apple", task: "lock"});

        const db = getFirestore(null);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));
    });

 
});


describe("groups/todoのupdateに対するテスト", () => {
    it("GroupMembersに自分が含まれていて，かつ，自分のDocならupdateできる", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await firebase.assertSucceeds(todoDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertSucceeds(testDoc.set({groupID: groupID, isFinished: false, userID: myAuth.uid}));
    });

    it("GroupMembersに自分が含まれていて，かつ，自分のDocなら,isFinishedに関係なくupdateできる", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertSucceeds(testDoc.set({groupID: groupID, isFinished: true, userID: myAuth.uid}));
    });

    it("GroupMembersに自分が含まれていて，でも，自分のDocじゃないならupdateできない", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: otherId});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: false, userID: myAuth.uid}));
    });

    it("GroupMembersに自分が含まれていて，でも，groupIDが違うとupdateできない", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: otherId});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: "otherGroupID", isFinished: false, userID: myAuth.uid}));
    });

    it("GroupMembersに自分が含まれていて，でも，uesrIDが自分のIDと違うとupdateできない", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myId], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: otherId});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: "otherGroupID", isFinished: false, userID: otherId}));
    });

    it("GroupMembersに自分が含まれていていないとupdateできない(そもそも作れない)", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge"], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: otherId});

        const db = getFirestore(myAuth);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: false, userID: myAuth.uid}));
    });

    it("認証してないとupdateできない", async () => {
        const admin = getAdminFirestore();
        const groupID = "userIsContsintsGroupID";
        const setupDoc = admin.collection("todo/v1/groups").doc(groupID)
        await setupDoc.set({members: [otherId, "hoge", myAuth.uid], name: "Apple", task: "lock"});
        const todoDoc = admin.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID");
        await todoDoc.set({groupID: groupID, isFinished: true, userID: otherId});

        const db = getFirestore(null);
        const testDoc = db.collection(`todo/v1/groups/${groupID}/todo`).doc("someTodoID")
        await firebase.assertFails(testDoc.set({groupID: groupID, isFinished: false, userID: myAuth.uid}));
    });

});