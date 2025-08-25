import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import sharp from 'sharp';
import algoliasearch from 'algoliasearch';

admin.initializeApp();
const db = admin.firestore();

const ALGOLIA_APP_ID = process.env.ALGOLIA_APP_ID as string | undefined;
const ALGOLIA_API_KEY = process.env.ALGOLIA_API_KEY as string | undefined;
const ALGOLIA_INDEX = (process.env.ALGOLIA_INDEX as string | undefined) || 'items';
const algolia = ALGOLIA_APP_ID && ALGOLIA_API_KEY ? algoliasearch(ALGOLIA_APP_ID, ALGOLIA_API_KEY).initIndex(ALGOLIA_INDEX) : null;

export const onItemWrite = functions.firestore
  .document('items/{itemId}')
  .onWrite(async (change, context) => {
    if (!algolia) return;
    const id = context.params.itemId as string;
    const data = change.after.exists ? change.after.data() : null;
    if (!data) {
      await algolia.deleteObject(id);
      return;
    }
    await algolia.saveObject({
      objectID: id,
      title: data.title,
      price: data.price,
      geohash: data.position?.geohash,
      _geoloc: data.position?.geopoint ? { lat: data.position.geopoint._latitude, lng: data.position.geopoint._longitude } : undefined,
      createdAt: (data.createdAt && data.createdAt.toMillis) ? data.createdAt.toMillis() : Date.now(),
    });
  });

export const onImageUpload = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name || '';
  if (!filePath.startsWith('images/')) return;

  const bucket = admin.storage().bucket(object.bucket);
  const [tmpFile] = await bucket.file(filePath).download();
  const thumb = await sharp(tmpFile).resize(400).jpeg({ quality: 80 }).toBuffer();

  const thumbPath = filePath.replace('images/', 'thumbs/');
  const file = bucket.file(thumbPath);
  await file.save(thumb, { contentType: 'image/jpeg' });
});
