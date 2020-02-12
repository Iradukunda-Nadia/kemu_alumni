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
