const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().functions);

var newData;

exports.messageTrigger = functions.firestore.document('mensagens/{messageId}').onCreate(async (snapshot, context) => {

	if (snapshot.empty) {
		console.log('No Devices');
		return;
	}

	var tokens = [];

	newData = snapshot.data();

	const deviceIdTokens = await admin
		.firestore()
		.collection('DeviceTokens')
		.get();

	for (var token of deviceIdTokens.docs) {
		tokens.push(token.data().device_token);
	}

	var payload = {
		notification: {
			title: 'Confira seu monitoramento...',
			body: 'Parece que houve uma alteração no nosso sistema!',
			sound: 'default',
		},
		data: {
			click_action: 'FLUTTER_NOTIFICATION_CLICK',
			message: newData.message,
		},
	};

	try {
		const response = await admin.messaging().sendToDevice(tokens, payload);
		console.log('Notification sent successfully');
	} catch (err) {
		console.log(err);
	}

	await admin.firestore()
	    .collection('mensagens').doc([]).delete();


});