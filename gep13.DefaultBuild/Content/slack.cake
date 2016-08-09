///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.Slack

///////////////////////////////////////////////////////////////////////////////
// ENVIRONMENT VARIABLES
///////////////////////////////////////////////////////////////////////////////

var slackToken = EnvironmentVariable("SLACK_TOKEN");
var slackChannel = EnvironmentVariable("SLACK_CHANNEL");

///////////////////////////////////////////////////////////////////////////////
// HELPER METHODS
///////////////////////////////////////////////////////////////////////////////

public void SendMessageToSlackChannel(string message)
{
    try
    {
        Information("Sending message to Slack...");

        var postMessageResult = Slack.Chat.PostMessage(
                    token: slackToken,
                    channel: slackChannel,
                    text: message
            );

        if (postMessageResult.Ok)
        {
            Information("Message {0} successfully sent", postMessageResult.TimeStamp);
        }
        else
        {
            Error("Failed to send message: {0}", postMessageResult.Error);
        }
    }
    catch(Exception ex)
    {
        Error("{0}", ex);
    }
}