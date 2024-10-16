/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

//const {onRequest} = require("firebase-functions/v2/https");
//const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const formatWeeks = ["日", "月", "火", "水", "木", "金", "土"];

const functions = require('firebase-functions')
const admin = require('firebase-admin')
const nodemailer = require('nodemailer')
admin.initializeApp()
const firestore = admin.firestore()

exports.sendRequestInterview = functions.region('asia-northeast1').firestore.document('/requestInterview/{documentId}')
    .onCreate(async (snap, context) => {
        const requestInterviewData = snap.data();
        const from = 'admin@hirome.co.jp';
        const to = requestInterviewData.companyUserEmail;
        const subject = 'メールのタイトルです。';
        const message = 'メールの内容です。';
        try {
            const transporter = nodemailer.createTransport({
                pool: true,
                host: 'sv215.xbiz.ne.jp',
                port: 465,
                secure: true,
                auth: {
                    user: from,
                    pass: 'Admin_1111'
                }
            });
            const mailOptions = {
                from: from,
                to: to,
                subject: subject,
                text: message
            };
            const info = await transporter.sendMail(mailOptions);
            console.log('メールが送信されました:', info.response);
        } catch (error) {
            console.error('メールの送信中にエラーが発生しました:', error);
        };
    });

exports.planAlertMessages = functions.region('asia-northeast1')
    .runWith({memory: '512MB'})
    .pubsub.schedule('every 1 minutes')
    .timeZone('Asia/Tokyo')
    .onRun(async (context) => {

    //現在時刻
    const now = (() => {
        let s = admin.firestore.Timestamp.now().seconds
        s = s - s % 60
        return new admin.firestore.Timestamp(s, 0)
    })()

    //DB取得
    const planRef = firestore.collection('plan')
    const userRef = firestore.collection('user')
    const planSnapshot = await planRef.where('alertMinute', '!=', 0)
        .where('alertedAt', '==', now)
        .get()
    if (!planSnapshot.empty) {
        planSnapshot.forEach(async planDoc => {
            const category = planDoc.data()['category']
            const subject = planDoc.data()['subject']
            const userIds = planDoc.data()['userIds']
            if (!userIds.empty) {
                for (i = 0; i < userIds.length; i++) {
                    const userId = userIds[i]
                    const userSnapshot = await userRef.where('id', '==', userId).get()
                    if (!userSnapshot.empty) {
                        userSnapshot.forEach(async userDoc => {
                            const token = userDoc.data()['token']
                            admin.messaging().send(pushMessage(
                                token,
                                '[' + category + ']' + subject,
                                'もうすぐ予定時刻になります。',
                            ))
                        })
                    }
                }
            }
        })
    }
})

exports.planShiftAlertMessages = functions.region('asia-northeast1')
    .runWith({memory: '512MB'})
    .pubsub.schedule('every 1 minutes')
    .timeZone('Asia/Tokyo')
    .onRun(async (context) => {

    //現在時刻
    const now = (() => {
        let s = admin.firestore.Timestamp.now().seconds
        s = s - s % 60
        return new admin.firestore.Timestamp(s, 0)
    })()

    //DB取得
    const planShiftRef = firestore.collection('planShift')
    const userRef = firestore.collection('user')
    const planShiftSnapshot = await planShiftRef.where('alertMinute', '!=', 0)
        .where('alertedAt', '==', now)
        .where('repeat', '==', false)
        .get()
    if (!planShiftSnapshot.empty) {
        planShiftSnapshot.forEach(async planShiftDoc => {
            const userIds = planShiftDoc.data()['userIds']
            if (!userIds.empty) {
                for (i = 0; i < userIds.length; i++) {
                    const userId = userIds[i]
                    const userSnapshot = await userRef.where('id', '==', userId).get()
                    if (!userSnapshot.empty) {
                        userSnapshot.forEach(async userDoc => {
                            const token = userDoc.data()['token']
                            admin.messaging().send(pushMessage(
                                token,
                                '勤務予定のお知らせ',
                                'もうすぐ勤務予定時刻になります。',
                            ))
                        })
                    }
                }
            }
        })
    }
    const planShiftRepeatSnapshot = await planShiftRef.where('alertMinute', '!=', 0)
        .where('repeat', '==', true)
        .get()
    if (!planShiftRepeatSnapshot.empty) {
        planShiftRepeatSnapshot.forEach(async planShiftRepeatDoc => {
            const repeatInterval = planShiftRepeatDoc.data()['repeatInterval']
            const repeatEvery = planShiftRepeatDoc.data()['repeatEvery']
            const alertedAt = planShiftRepeatDoc.data()['alertedAt'].toDate()
            var repeatUntil = planShiftRepeatDoc.data()['repeatEvery'];
            let repeatUntilAt
            if (repeatUntil != null) {
                repeatUntilAt = repeatUntil.toDate()
            }
            var success = false
            if (repeatUntilAt == null || repeatUntilAt > now.toDate()) {
                switch (repeatInterval) {
                    case '毎日':
                        var alertedHours = alertedAt.getHours()
                        var alertedMinutes = alertedAt.getMinutes()
                        if (now.toDate().getHours() == alertedHours && now.toDate().getMinutes() == alertedMinutes) {
                            success = true
                        }
                        break
                    case '毎週':
                        const repeatWeeks = planShiftRepeatDoc.data()['repeatWeeks']
                        if (!repeatWeeks) {
                            for (i = 0; i < repeatWeeks.length; i++) {
                                const week = repeatWeeks[i]
                                if (week == formatWeeks[now.toDate().getDay()]) {
                                    success = true
                                }
                            }
                        }
                        break
                    case '毎月':
                        var alertedDate = alertedAt.getDate()
                        var alertedHours = alertedAt.getHours()
                        var alertedMinutes = alertedAt.getMinutes()
                        if (now.toDate().getDate() == alertedDate && now.toDate().getHours() == alertedHours && now.toDate().getMinutes() == alertedMinutes) {
                            success = true
                        }
                        break
                    case '毎年':
                        var alertedMonth = alertedAt.getMonth()
                        var alertedDate = alertedAt.getDate()
                        var alertedHours = alertedAt.getHours()
                        var alertedMinutes = alertedAt.getMinutes()
                        if (now.toDate().getMonth() == alertedMonth && now.toDate().getDate() == alertedDate && now.toDate().getHours() == alertedHours && now.toDate().getMinutes() == alertedMinutes) {
                            success = true
                        }
                        break
                    default:
                        break
                }
            }
            if (success) {
                const userIds = planShiftRepeatDoc.data()['userIds']
                if (!userIds.empty) {
                    for (i = 0; i < userIds.length; i++) {
                        const userId = userIds[i]
                        const userSnapshot = await userRef.where('id', '==', userId).get()
                        if (!userSnapshot.empty) {
                            userSnapshot.forEach(async userDoc => {
                                const token = userDoc.data()['token']
                                admin.messaging().send(pushMessage(
                                    token,
                                    '勤務予定のお知らせ',
                                    'もうすぐ勤務予定時刻になります。',
                                ))
                            })
                        }
                    }
                }
            }
        })
    }
})

const pushMessage = (token, title, body) => ({
    notification: {
        title: title,
        body: body,
    },
    apns: {
        headers: {'apns-priority': '10'},
        payload: {
            aps: {
                badge: 1,
                sound: 'default',
            },
        },
    },
    token: token,
})