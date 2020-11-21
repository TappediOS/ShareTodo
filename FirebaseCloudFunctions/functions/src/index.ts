import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp(functions.config().firebase);
const firestore = admin.firestore();



//@ts-ignore TS6133: 'req' is declared but its value is never read.
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

export const onUpdateTodayTodo = functions.firestore.document('/todo/v1/groups/{groupID}/todo/{todoID}').onUpdate(async (change, context) => {
    const afterData = change.after.data();

    console.log('onUpdated!');
    
    if (afterData) {
        const groupID = afterData.groupID as string;
        const isFinished = afterData.isFinished as boolean;

        if (isFinished == false) { return; }

        let groupName = "";
        let groupTask = "";
        let isFinishedUserName = "";
        //@ts-ignore TS6133: 'req' is declared but its value is never read.
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