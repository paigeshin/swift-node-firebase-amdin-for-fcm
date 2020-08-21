const admin = require('firebase-admin');
const serviceAccount = require('./ServiceAccountKey.json');

admin.initializeApp({
	credential: admin.credential.cert(serviceAccount)
});

const fcmToken =
	'd9VBiMZsyEaqmjb6vh96fI:APA91bEavnd3_3cLnsn-g3HaM6yOgdHOz74xhdrwFmbkq1R4osT4oOCbtCItI2B0nEAbCjU9zLeJqHwD3CJRMK3E-QL0YRTF74X9sfk3S8f9RHyFNC-tWGMAn3HbSoHovzqTAcKCk9xV';

const message = {
	token: fcmToken,
	notification: {
		title: 'Match update',
		body: 'Arsenal goal in added time, score is now 3-0'
	},
	// android: {
	// 	ttl: '86400',
	// 	notification: {
	// 		click_action: 'OPEN_ACTIVITY_1'
	// 	}
	// },

	//Learning, configure Apple Message
	apns: {
		headers: {
			'apns-priority': '5'
		},
		payload: {
			aps: {
				alert: 'Testing.. (0)',
				badge: 1,
				sound: 'default',
				category: 'beautifulgirl',
				'mutable-content': 1,
				'attachment-url':
					'https://www.goodfreephotos.com/albums/people/beautiful-girl-with-long-hair-and-pretty-eyes.jpg'
			}
		}
	}
};

admin
	.messaging()
	.send(message)
	.then((response) => {
		console.log('response: ', response);
	})
	.catch((err) => console.log('error: ', err));
