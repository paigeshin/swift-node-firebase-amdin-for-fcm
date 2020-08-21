# swift-node-firebase-amdin-for-fcm

## Notion Link

[Node firebase-admin for fcm](https://www.notion.so/node-firebase-admin-for-fcm-3ea5722c571e42a787ede9278d7b5935)

## Other Reference

[https://github.com/paigeshin/ios_push_notification_super_example](https://github.com/paigeshin/ios_push_notification_super_example)

[https://medium.com/@jang.wangsu/ios-swift-fcm-firebase-cloud-messaging-push-메시지-설정해보기-852a9af23b96](https://medium.com/@jang.wangsu/ios-swift-fcm-firebase-cloud-messaging-push-%EB%A9%94%EC%8B%9C%EC%A7%80-%EC%84%A4%EC%A0%95%ED%95%B4%EB%B3%B4%EA%B8%B0-852a9af23b96)

[https://nicgoon.tistory.com/196](https://nicgoon.tistory.com/196) ⇒ for firebase-admin for fcm 

[https://firebase.google.com/docs/cloud-messaging/concept-options](https://firebase.google.com/docs/cloud-messaging/concept-options)

- npm 설치

```bash
npm i firebase-admin --save
```

- 비공개 key 발급

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/dcde8403-4fbe-4d4b-83a1-3fc6b6c404e9/Untitled.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/dcde8403-4fbe-4d4b-83a1-3fc6b6c404e9/Untitled.png)

- private key를 node server 위에다가 준다.

![https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b9a2f971-6525-4c72-a6a8-f67cbd952acb/Screen_Shot_2020-08-21_at_17.43.04.png](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/b9a2f971-6525-4c72-a6a8-f67cbd952acb/Screen_Shot_2020-08-21_at_17.43.04.png)

- code

```jsx
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
		title: 'hello',
		body: 'world'
	}
};

admin
	.messaging()
	.send(message)
	.then((response) => {
		console.log('response: ', response);
	})
	.catch((err) => console.log('error: ', err));
```

- completed code

```jsx
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
```