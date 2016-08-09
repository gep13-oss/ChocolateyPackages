Task("Publish-Nuget-Packages")
    .IsDependentOn("Create-NuGet-Packages")
    .WithCriteria(() => !parameters.IsLocalBuild)
    .WithCriteria(() => !parameters.IsPullRequest)
    .Does(() =>
{
    // Resolve the API key.
	var apiKey = EnvironmentVariable("MYGET_DEVELOP_API_KEY");
	if(parameters.IsMasterBranch)
	{
        apiKey = EnvironmentVariable("MYGET_MASTER_API_KEY");
	}

	if(parameters.IsTagged)
    {
        apiKey = EnvironmentVariable("NUGET_API_KEY");
	}

    if(string.IsNullOrEmpty(apiKey))
    {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget API key.");
    }

    var source = EnvironmentVariable("MYGET_DEVELOP_SOURCE");
    if(parameters.IsMasterBranch)
    {
        source = EnvironmentVariable("MYGET_MASTER_SOURCE");
    }

    if(parameters.IsTagged)
    {
        source = EnvironmentVariable("NUGET_SOURCE");
    }

    if(string.IsNullOrEmpty(source))
    {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget source.");
    }

    // Get the path to the package.
    // var package = parameters.Paths.Directories.Build.CombineWithFilePath(product + "." + parameters.Version.SemVersion + ".nupkg");

    // Push the package.
    //NuGetPush(package, new NuGetPushSettings {
    //   Source = source,
    //   ApiKey = apiKey
    //});
});

Task("Publish-Chocolatey-Packages")
    .IsDependentOn("Create-Chocolatey-Packages")
    .WithCriteria(() => !parameters.IsLocalBuild)
    .WithCriteria(() => !parameters.IsPullRequest)
    .Does(() =>
{
});