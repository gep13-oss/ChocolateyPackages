///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////

#tool "nuget:?package=gitreleasemanager&version=0.5.0"

///////////////////////////////////////////////////////////////////////////////
// TASK DEFINITIONS
///////////////////////////////////////////////////////////////////////////////

Task("Create-Release-Notes")
    .Does(() =>
{
    GitReleaseManagerCreate(parameters.GitHub.UserName, parameters.GitHub.Password, repositoryOwner, repositoryName, new GitReleaseManagerCreateSettings {
        Milestone         = parameters.Version.Milestone,
        Name              = parameters.Version.Milestone,
        Prerelease        = true,
        TargetCommitish   = "main"
    });
});

Task("Publish-GitHub-Release")
    .IsDependentOn("Package")
    .WithCriteria(() => !parameters.IsLocalBuild)
    .WithCriteria(() => !parameters.IsPullRequest)
    .WithCriteria(() => parameters.IsMainRepository)
    .WithCriteria(() => parameters.IsMasterBranch)
    .WithCriteria(() => parameters.IsTagged)
    .Does(() =>
{
    GitReleaseManagerClose(parameters.GitHub.UserName, parameters.GitHub.Password, repositoryOwner, repositoryName, parameters.Version.Milestone);
})
.OnError(exception =>
{
    Information("Publish-GitHub-Release Task failed, but continuing with next Task...");
    publishingError = true;
});