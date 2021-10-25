const pts = require('posttoslack');

exports.handler = async (event, context) => {
    var message = event.Records[0].Sns.Message;

    return pts.posttoslack(
        'hooks.slack.com',
        process.env.hook_url,
        message
    );
};
