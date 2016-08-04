///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.Slack

///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Environment Variables
///////////////////////////////////////////////////////////////////////////////
var slackToken = EnvironmentVariable("SLACK_TOKEN");
var slackChannel = EnvironmentVariable("SLACK_CHANNEL");
var slackWebHookUrl = EnvironmentVariable("SLACK_WEBHOOK_URL");

Task("Slack-Room-Notification")
    .WithCriteria(!string.IsNullOrWhiteSpace(slackToken) && !string.IsNullOrWhiteSpace(slackChannel))
    .WithCriteria(() => !isLocalBuild)
    .Does(() =>
{
    
});

Task("Slack-WebHook-Notification")
    .WithCriteria(!string.IsNullOrWhiteSpace(slackWebHookUrl))
    .WithCriteria(() => !isLocalBuild)
    .Does(() =>
{
    
});