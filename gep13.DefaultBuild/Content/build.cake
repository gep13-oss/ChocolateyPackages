///////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////////////////////////////////////////////
var isLocalBuild        = !AppVeyor.IsRunningOnAppVeyor;
var isPullRequest       = AppVeyor.Environment.PullRequest.IsPullRequest;
var isDevelopBranch     = AppVeyor.Environment.Repository.Branch == "develop";
var isTag               = AppVeyor.Environment.Repository.Tag.IsTag;

///////////////////////////////////////////////////////////////////////////////
// SETUP / TEARDOWN
///////////////////////////////////////////////////////////////////////////////

Setup(() =>
{
    // Executed BEFORE the first task.
    Information("Running tasks...");
});

Teardown(() =>
{
    // Executed AFTER the last task.
    Information("Finished running tasks.");
});

///////////////////////////////////////////////////////////////////////////////
// TASK DEFINITIONS
///////////////////////////////////////////////////////////////////////////////

Task("Clean")
    .Does(() =>
{
    Information("Cleaning {0}", solutionPath);
    CleanDirectories(solutionPath + "/**/bin/" + configuration);
    CleanDirectories(solutionPath + "/**/obj/" + configuration);

    Information("Cleaning BuildArtifacts");
    CleanDirectories(buildArtifacts);
});

Task("Restore")
    .Does(() =>
{
    // Restore all NuGet packages.
    Information("Restoring {0}...", solution);
    NuGetRestore(solution);
});

Task("SolutionInfo")
    .IsDependentOn("Clean")
    .IsDependentOn("Restore")
    .Does(() =>
{
    var file = sourcePath + "/SolutionInfo.cs";
    CreateAssemblyInfo(file, assemblyInfo);
});

Task("Build")
    .IsDependentOn("Clean")
    .IsDependentOn("Restore")
    .IsDependentOn("SolutionInfo")
    .IsDependentOn("DupFinder")
    .IsDependentOn("InspectCode")
    .Does(() =>
{
    Information("Building {0}", solution);
    MSBuild(solution, settings =>
        settings.SetPlatformTarget(PlatformTarget.MSIL)
            .WithProperty("TreatWarningsAsErrors","true")
            .WithTarget("Build")
            .SetConfiguration(configuration));
});

Task("DupFinder")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    // Run ReSharper's DupFinder
    DupFinder(solution, new DupFinderSettings() {
        ShowStats = true,
        ShowText = true,
        OutputFile = buildArtifacts + "/_ReSharperReports/dupfinder.xml"
    });
});

Task("InspectCode")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    // Run ReSharper's InspectCode
    InspectCode(solution, new InspectCodeSettings() {
        SolutionWideAnalysis = true,
        Profile = sourcePath + "/ReSharperReports.sln.DotSettings",
        OutputFile = buildArtifacts + "/_ReSharperReports/inspectcode.xml"
    });
});

Task("Create-Build-Directories")
    .Does(() =>
{
    if (!DirectoryExists(buildArtifacts))
    {
        CreateDirectory(buildArtifacts);
    }
    
    if (!DirectoryExists(buildArtifacts + "/_ReSharperReports"))
    {
        CreateDirectory(buildArtifacts + "/_ReSharperReports");
    }
});

Task("Create-NuGet-Package")
    .IsDependentOn("Build")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    NuGetPack(nuGetPackSettings);
});

Task("Publish-Nuget-Package")
    .IsDependentOn("Create-NuGet-Package")
    .WithCriteria(() => !isLocalBuild)
    .WithCriteria(() => !isPullRequest)
    .Does(() =>
{
    // Resolve the API key.
	var apiKey = EnvironmentVariable("MYGET_DEVELOP_API_KEY");
	if(!isDevelopBranch)
	{
        apiKey = EnvironmentVariable("MYGET_MASTER_API_KEY");
	}

	if(isTag) {
        apiKey = EnvironmentVariable("NUGET_API_KEY");
	}

    if(string.IsNullOrEmpty(apiKey)) {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget API key.");
    }

    var source = EnvironmentVariable("MYGET_DEVELOP_SOURCE");
    if(!isDevelopBranch)
    {
        source = EnvironmentVariable("MYGET_MASTER_SOURCE");
    }

    if(isTag) {
        source = EnvironmentVariable("NUGET_SOURCE");
    }

    if(string.IsNullOrEmpty(source)) {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget source.");
    }

    // Get the path to the package.
    var package = buildArtifacts + "/" + product + "." + semVersion + ".nupkg";

    // Push the package.
    NuGetPush(package, new NuGetPushSettings {
        Source = source,
        ApiKey = apiKey
    });
});

Task("Default")
    .IsDependentOn("Create-NuGet-Package");

Task("AppVeyor")
    .IsDependentOn("Publish-Nuget-Package");

///////////////////////////////////////////////////////////////////////////////
// EXECUTION
///////////////////////////////////////////////////////////////////////////////

RunTarget(target);
