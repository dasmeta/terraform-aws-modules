console.log('Loading function');
const util = require('util');
const zlib = require('zlib');
const { S3 } = require('aws-sdk');

const gunzip = util.promisify(zlib.gunzip);
const s3 = new S3();


exports.handler = async (event, context) => {
    console.log('Received event:', JSON.stringify(event, null, 2));

    // Get the object from the event and show its content type
    const bucket = event.Records[0].s3.bucket.name;
    const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '));
    console.log('KEY: ', key)
    const params = {
        Bucket: bucket,
        Key: key,
    };
    try {
        const dataFromBucket = await s3.getObject(params).promise();
        const bufferedData = await gunzip(dataFromBucket.Body);
        return bufferedData.toString('utf-8');
    } catch (err) {
        console.log(err);
        const message = `Error getting object ${key} from bucket ${bucket}. Make sure they exist and your bucket is in the same region as this function.`;
        console.log(message);
        throw new Error(message);
    }
};
