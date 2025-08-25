// MahallaMarket functions (disabled for Spark/free plan).
// You can keep this file in the repo; it will NOT be deployed because firebase.json
// does not include "functions". When you upgrade to Blaze, uncomment the sections below,
// run `npm i algoliasearch sharp`, and `npm run deploy`.

// import * as functions from 'firebase-functions';
// import * as admin from 'firebase-admin';
// import algoliasearch from 'algoliasearch';
// import sharp from 'sharp';

// admin.initializeApp();
// const db = admin.firestore();

// // Optional Algolia (enable after upgrading to Blaze):
// const ALGOLIA_APP_ID = process.env.ALGOLIA_APP_ID;
// const ALGOLIA_API_KEY = process.env.ALGOLIA_API_KEY;
// const ALGOLIA_INDEX = process.env.ALGOLIA_INDEX || 'items';
// const algolia = (ALGOLIA_APP_ID && ALGOLIA_API_KEY)
//   ? algoliasearch(ALGOLIA_APP_ID, ALGOLIA_API_KEY).initIndex(ALGOLIA_INDEX)
//   : null;

// // Firestore trigger: index items to Algolia
// export const onItemWrite = functions.firestore
//   .document('items/{itemId}')
//   .onWrite(async (change, context) => {
//     if (!algolia) return;
//     const id = context.params.itemId as string;
//     const data = change.after.exists ? change.after.data() : null;
//     if (!data) {
//       await algolia.deleteObject(id);
//       return;
//     }
//     await algolia.saveObject({
//       objectID: id,
//       title: data.title,
//       price: data.price,
//       geohash: data.position?.geohash,
//       _geoloc: data.position?.geopoint ? { lat: data.position.geopoint._latitude, lng: data.position.geopoint._longitude } : undefined,
//       createdAt: (data.createdAt && data.createdAt.toMillis) ? data.createdAt.toMillis() : Date.now(),
//     });
//   });

// // Storage trigger: generate thumbnails
// export const onImageUpload = functions.storage.object().onFinalize(async (object) => {
//   const filePath = object.name || '';
//   if (!filePath.startsWith('images/')) return;
//   const bucket = admin.storage().bucket(object.bucket);
//   const [tmpFile] = await bucket.file(filePath).download();
//   const thumb = await sharp(tmpFile).resize(400).jpeg({ quality: 80 }).toBuffer();
//   const thumbPath = filePath.replace('images/', 'thumbs/');
//   await bucket.file(thumbPath).save(thumb, { contentType: 'image/jpeg' });
// });

// For Spark plan: Nothing to export. Keep app logic in client & Firestore rules.
export {};
