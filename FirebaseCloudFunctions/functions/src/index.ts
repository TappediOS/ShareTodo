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
                    //sound: {
                    //    name: "message_send_009.wav",
                    //},
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