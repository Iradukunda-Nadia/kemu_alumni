import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('notifications/{Item}')
  .onCreate(async snapshot => {


    const order: any = snapshot.data();

    const tokens = order.token;

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Approved',
        body: "your registration has been approved"

      }
    };

    return fcm.sendToDevice(tokens, payload);
  });

export const newMessage = functions.firestore
  .document('messages/{Item}')
  .onCreate(async snapshot => {

    const message: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Message!',
        body: `A new message has been sent in E-lorry chat group`,
      }
    };

    return fcm.sendToTopic('student', message);
  });

  export const newEvent = functions.firestore
    .document('events/{Item}')
    .onCreate(async snapshot => {

      const message: admin.messaging.MessagingPayload = {
        notification: {
          title: 'New Message!',
          body: `A new message has been sent in E-lorry chat group`,
        }
      };

      return fcm.sendToTopic('student', message);
    });