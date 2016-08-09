///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////

#tool "nuget:?package=xunit.runner.console&version=2.1.0"
#tool "nuget:?package=OpenCover&version=4.6.519"
#tool "nuget:?package=ReportGenerator&version=2.4.5"
#tool "nuget:?package=ReportUnit&version=1.2.1"

///////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////////////////////////////////////////////

var testCoverageFilter = "+[*]* -[xunit.*]* -[*.Tests]* ";
var testCoverageExcludeByAttribute = "*.ExcludeFromCodeCoverage*";
var testCoverageExcludeByFile = "*/*Designer.cs;*/*.g.cs;*/*.g.i.cs";
var parameters = BuildParameters.GetParameters(Context, BuildSystem);
var publishingError = false;

///////////////////////////////////////////////////////////////////////////////
// SETUP / TEARDOWN
///////////////////////////////////////////////////////////////////////////////

Setup(context =>
{
    if(parameters.IsMasterBranch && (context.Log.Verbosity != Verbosity.Diagnostic)) {
        Information("Increasing verbosity to diagnostic.");
        context.Log.Verbosity = Verbosity.Diagnostic;
    }

    parameters.SetBuildVersion(
        BuildVersion.CalculatingSemanticVersion(
            context: Context,
            parameters: parameters
        )
    );

    parameters.SetBuildPaths(
        BuildPaths.GetPaths(
            context: Context,
            configuration: parameters.Configuration,
            semVersion: parameters.Version.SemVersion
        )
    );

    Information("Building version {0} of " + title + " ({1}, {2}) using version {3} of Cake. (IsTagged: {4})",
        parameters.Version.SemVersion,
        parameters.Configuration,
        parameters.Target,
        parameters.Version.CakeVersion,
        parameters.IsTagged);
});

Teardown(context =>
{
    if(context.Successful)
    {
        if(!parameters.IsLocalBuild && !parameters.IsPullRequest && parameters.IsMainRepository && parameters.IsMasterBranch && parameters.IsTagged)
        {
            if(sendMessageToTwitter)
            {
                SendMessageToTwitter("test");
            }

            if(sendMessageToGitterRoom)
            {
                SendMessageToGitterRoom("test");
            }
        }
    }
    else
    {
        if(sendMessageToSlackChannel)
        {
            SendMessageToSlackChannel("test");
        }
    }

    Information("Finished running tasks.");
});

///////////////////////////////////////////////////////////////////////////////
// TASK DEFINITIONS
///////////////////////////////////////////////////////////////////////////////

Task("Show-Info")
    .Does(() =>
{
    Information("Target: {0}", target);
    Information("Configuration: {0}", configuration);

    Information("Solution FilePath: {0}", MakeAbsolute((FilePath)solutionFilePath));
    Information("Solution DirectoryPath: {0}", MakeAbsolute((DirectoryPath)solutionDirectoryPath));
    Information("Source DirectoryPath: {0}", MakeAbsolute(parameters.Paths.Directories.Source));
    Information("Build DirectoryPath: {0}", MakeAbsolute(parameters.Paths.Directories.Build));
});

Task("Clean")
    .Does(() =>
{
    Information("Cleaning...");

    CleanDirectories(parameters.Paths.Directories.ToClean);
});

Task("Restore")
    .Does(() =>
{
    Information("Restoring {0}...", solutionFilePath);

    NuGetRestore(solutionFilePath, new NuGetRestoreSettings { Source = new List<string> { "https://www.nuget.org/api/v2", "https://www.myget.org/F/gep13/api/v2" }});
});

Task("Build")
    .IsDependentOn("Show-Info")
    .IsDependentOn("Print-AppVeyor-Environment-Variables")
    .IsDependentOn("Clean")
    .IsDependentOn("Restore")
    .Does(() =>
{
    Information("Building {0}", solutionFilePath);

    // TODO: Need to have an XBuild step here as well
    MSBuild(solutionFilePath, settings =>
        settings.SetPlatformTarget(PlatformTarget.MSIL)
            .WithProperty("TreatWarningsAsErrors","true")
            .WithProperty("OutDir", MakeAbsolute(parameters.Paths.Directories.TempBuild).FullPath)
            .WithTarget("Build")
            .SetConfiguration(configuration));
});

Task("Default")
    .IsDependentOn("Create-NuGet-Packages")
    .IsDependentOn("Create-Chocolatey-Packages");

Task("AppVeyor")
    .IsDependentOn("Publish-Chocolatey-Packages")
    .IsDependentOn("Publish-Nuget-Packages");

///////////////////////////////////////////////////////////////////////////////
// EXECUTION
///////////////////////////////////////////////////////////////////////////////
RunTarget(target);