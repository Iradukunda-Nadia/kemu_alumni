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
        body: `A new message has been sent in KeMU chat group`,
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
          body: `There is a new Event for KEMU ALUMNI`,
        }
      };

      return fcm.sendToTopic('student', message);
    });

    export const newNews = functions.firestore
      .document('news/{Item}')
      .onCreate(async snapshot => {

        const message: admin.messaging.MessagingPayload = {
          notification: {
            title: 'News!',
            body: `A new article has been uploaded`,
          }
        };

        return fcm.sendToTopic('student', message);
      });

      export const newScholarship = functions.firestore
        .document('scholarships/{Item}')
        .onCreate(async snapshot => {

          const message: admin.messaging.MessagingPayload = {
            notification: {
              title: 'New Scholarship!',
              body: `Click to see new Scholarships`,
            }
          };

          return fcm.sendToTopic('student', message);
        });

        export const newJob = functions.firestore
                .document('jobs/{Item}')
                .onCreate(async snapshot => {

                  const message: admin.messaging.MessagingPayload = {
                    notification: {
                      title: 'JOB ALERT!',
                      body: `Click to see new job posting`,
                    }
                  };

                  return fcm.sendToTopic('student', message);
                });


        export const newUser = functions.firestore
                        .document('users/{Item}')
                        .onCreate(async snapshot => {

                          const message: admin.messaging.MessagingPayload = {
                            notification: {
                              title: 'NEW USER!',
                              body: `A new user has signed up`,
                            }
                          };

                          return fcm.sendToTopic('manager', message);
                        });
