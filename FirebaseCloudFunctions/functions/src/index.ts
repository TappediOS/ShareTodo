import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();


async function isFinishedTaskNotification(groupName: string, task: string, finishedUserName: string, fcmToken: string) {
    const Message = {
        token: fcmToken,
        apns: {
            payload: {
                aps: {
                    badge: 0,
                    headers: {
                        "apns-priority": "10",
                    },
                    sound: {
                        name: "default",
                        //name: "message_send_009.wav",
					},
                    alert: {
                        titleLocKey: "GROUP_TASK_NOTIFICATION_TITLE",
                        titleLocArgs: [groupName, task],
                        
                        locKey: "FINISHEDUSER_NOTIFICATION_BODY",
                        locArgs: [finishedUserName],
                    }
                }
            },
        }
    };

    return admin.messaging().send(Message);
}

export const onCreateTodayTodo = functions.firestore.document('/todo/v1/groups/{groupID}/todo/{todoID}').onCreate(async (snap, context) => {
    const newData = snap.data()

    if (newData) {
        const groupID = newData.groupID as string;

        // 通知に必要なのはグループ名とタスク，終わらせたユーザの名前
        let groupName = "";
        let groupTask = "";
        let isFinishedUserName = "";
        const isFinishedUserID  = newData.userID as string;

        const documentRef = '/todo/v1/groups/' + groupID
        var groupMembersID: string[] = [];

        console.log('groupのユーザidの取得開始');
        await firestore.doc(documentRef).get()
            .then(doc => {
                if (!doc.exists) {
                    console.log('group無し');
                    console.log('documentRef: ', documentRef)
					return null;
                }
                const docData = doc.data();
                if (docData) { 
                    // [memberID]とグループ名，グループタスクを取得する
                    groupMembersID = docData.members as Array<string>; 
                    groupName = docData.name as string;
                    groupTask = docData.task as string;
                }
                return null;
            })
            .catch(error => {
                console.log(error);
            })
        
        console.log('groupのユーザidの取得完了');
        console.log('gropuのユーザIDs: ', groupMembersID);

        const membersFcmTokens: string[] = [];

        console.log('fcmTokenの取得開始');

        for (const userID of groupMembersID) {
            var userRef = 'todo/v1/users/' + userID
            await firestore.doc(userRef).get()
            .then(doc => {
                if (!doc.exists) {
                    console.log('user無し');
                    console.log('userRef: ', userRef)
					return null;
                }
                const docData = doc.data();
                if (docData) {
                    const usersFcmToken = docData.fcmToken
                    const name = docData.name
                    if (name != null && userID == isFinishedUserID) {
                        isFinishedUserName = name as string;
                    }
                    if (usersFcmToken != null && userID != isFinishedUserID) {
                        membersFcmTokens.push(usersFcmToken as string)
                    }
                }
                return null;

            })
            .catch(error => {
                console.log(error);
            })
        }

        console.log('fcmTokenの取得完了');
        console.log('fcmToken: ', membersFcmTokens);
        
        for (var fcmToken of membersFcmTokens) {
            isFinishedTaskNotification(groupName, groupTask, isFinishedUserName, fcmToken)
            .catch(() => 'catch')
        }
    }
});

export const onUpdateTodayTodo = functions.firestore.document('/todo/v1/groups/{groupID}/todo/{todoID}').onUpdate(async (change, context) => {
    const beforData = change.before.data();
    const afterData = change.after.data();
    
    // すでにisFinishedがtrueなら早期return
    // メッセージを送る場合はこの中に書く
    if (beforData) {
        const beforeFinished = beforData.isFinished as boolean;
        if (beforeFinished == true) { return; }
    }

    if (afterData) {
        const groupID = afterData.groupID as string;
        const isFinished = afterData.isFinished as boolean;

        // もしisFinishedがfalseなら早期return
        if (isFinished == false) { return; }

        // 通知に必要なのはグループ名とタスク，終わらせたユーザの名前
        let groupName = "";
        let groupTask = "";
        let isFinishedUserName = "";
        const isFinishedUserID  = afterData.userID as string;

        const documentRef = '/todo/v1/groups/' + groupID
        var groupMembersID: string[] = [];

        console.log('groupのユーザidの取得開始');
        await firestore.doc(documentRef).get()
            .then(doc => {
                if (!doc.exists) {
                    console.log('group無し');
                    console.log('documentRef: ', documentRef)
					return null;
                }
                const docData = doc.data();
                if (docData) { 
                    // [memberID]とグループ名，グループタスクを取得する
                    groupMembersID = docData.members as Array<string>; 
                    groupName = docData.name as string;
                    groupTask = docData.task as string;
                }
                return null;
            })
            .catch(error => {
                console.log(error);
            })
        
        console.log('groupのユーザidの取得完了');
        console.log('gropuのユーザIDs: ', groupMembersID);

        const membersFcmTokens: string[] = [];

        console.log('fcmTokenの取得開始');

        for (const userID of groupMembersID) {
            var userRef = 'todo/v1/users/' + userID
            await firestore.doc(userRef).get()
            .then(doc => {
                if (!doc.exists) {
                    console.log('user無し');
                    console.log('userRef: ', userRef)
					return null;
                }
                const docData = doc.data();
                if (docData) {
                    const usersFcmToken = docData.fcmToken
                    const name = docData.name
                    if (name != null && userID == isFinishedUserID) {
                        isFinishedUserName = name as string;
                    }
                    if (usersFcmToken != null && userID != isFinishedUserID) {
                        membersFcmTokens.push(usersFcmToken as string)
                    }
                }
                return null;

            })
            .catch(error => {
                console.log(error);
            })
        }

        console.log('fcmTokenの取得完了');
        console.log('fcmToken: ', membersFcmTokens);
        
        for (var fcmToken of membersFcmTokens) {
            isFinishedTaskNotification(groupName, groupTask, isFinishedUserName, fcmToken)
            .catch(() => 'catch')
        }
    }
});

//アカウント削除時のトリガー
export const deleteUsersAccount = functions.auth.user().onDelete(async (userRecord, context) => {
	let uid = userRecord.uid
	console.log(`user ${uid} deleted.`);

	// /todo/v1/users/uidを削除する。これだけではサブコレクションは削除されない。そういう仕様。今回はサブコレクション置いてないから大丈夫
	await firestore.collection('/todo/v1/users/').doc(uid).delete();

    // userが所属しているグループをすべて取り出す
	const userGroups = await firestore.collection('todo/v1/groups').where('members', 'array-contains', uid).get()
    const batch = firestore.batch()

    // グループのmembersを１つづつ自分のuidを取り除く様にして更新していく
    userGroups.forEach(async group => {
        batch.update(group.ref, {'members': admin.firestore.FieldValue.arrayRemove(uid)})
    })

    await batch.commit()
});

