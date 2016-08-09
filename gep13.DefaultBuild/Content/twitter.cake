///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////

#addin Cake.Twitter

///////////////////////////////////////////////////////////////////////////////
// ENVIRONMENT VARIABLES
///////////////////////////////////////////////////////////////////////////////

var oAuthConsumerKey        = EnvironmentVariable("TWITTER_CONSUMER_KEY");
var oAuthConsumerSecret     = EnvironmentVariable("TWITTER_CONSUMER_SECRET");
var accessToken             = EnvironmentVariable("TWITTER_ACCESS_TOKEN");
var accessTokenSecret       = EnvironmentVariable("TWITTER_ACCESS_TOKEN_SECRET");

///////////////////////////////////////////////////////////////////////////////
// HELPER METHODS
///////////////////////////////////////////////////////////////////////////////

public void SendMessageToTwitter(string message)
{
    try
    {
        Information("Sending message to Twitter...");

        TwitterSendTweet(oAuthConsumerKey, oAuthConsumerSecret, accessToken, accessTokenSecret, message);

        Information("Message succcessfully sent.");
    }
    catch(Exception ex)
    {
        Error("{0}", ex);
    }
}