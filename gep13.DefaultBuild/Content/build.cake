///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES
///////////////////////////////////////////////////////////////////////////////
var isLocalBuild                   = !AppVeyor.IsRunningOnAppVeyor;
var isPullRequest                  = AppVeyor.Environment.PullRequest.IsPullRequest;
var isDevelopBranch                = AppVeyor.Environment.Repository.Branch == "develop";
var isTag                          = AppVeyor.Environment.Repository.Tag.IsTag;
GitVersion assertedVersions        = null;
var resharperReportsDirectoryPath  = buildDirectoryPath + "/_ReSharperReports";
var tempBuildDirectoryPath         = buildDirectoryPath + "/temp";
var publishedNUnitTestsDirectory   = tempBuildDirectoryPath + "/_PublishedNUnitTests";
var publishedxUnitTestsDirectory   = tempBuildDirectoryPath + "/_PublishedxUnitTests";
var publishedMSTestTestsDirectory  = tempBuildDirectoryPath + "/_PublishedMSTestTests";
var publishedWebsitesDirectory     = tempBuildDirectoryPath + "/_PublishedWebsites";
var publishedApplicationsDirectory = tempBuildDirectoryPath + "/_PublishedApplications";
var publishedLibrariesDirectory    = tempBuildDirectoryPath + "/_PublishedLibraries";

var testResultsDirectory = buildDirectoryPath + "/TestResults";
var NUnitTestResultsDirectory = testResultsDirectory + "/NUnit";
var xUnitTestResultsDirectory = testResultsDirectory + "/xUnit";
var MSTestTestResultsDirectory = testResultsDirectory + "/MSTest";

var testCoverageDirectory = buildDirectoryPath + "/TestCoverage";
var testCoverageReportPath = testCoverageDirectory + "/OpenCover.xml";

var testCoverageFilter = "+[*]* -[xunit.*]* -[*.NUnitTests]* -[*.Tests]* -[*.xUnitTests]*";
var testCoverageExcludeByAttribute = "*.ExcludeFromCodeCoverage*";
var testCoverageExcludeByFile = "*/*Designer.cs;*/*.g.cs;*/*.g.i.cs";

var packagesOutputDirectory = buildDirectoryPath + "/Packages";
var librariesOutputDirectory = packagesOutputDirectory + "/Libraries";
var applicationsOutputDirectory = packagesOutputDirectory + "/Applications";

///////////////////////////////////////////////////////////////////////////////
// Environment Variables
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// SETUP / TEARDOWN
///////////////////////////////////////////////////////////////////////////////
Setup(() =>
{
    Information("Running tasks...");
});

Teardown(() =>
{
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
    Information("Source DirectoryPath: {0}", MakeAbsolute((DirectoryPath)sourceDirectoryPath));
    Information("Build DirectoryPath: {0}", MakeAbsolute((DirectoryPath)buildDirectoryPath));
});

Task("Clean")
    .Does(() =>
{
    Information("Cleaning {0}...", solutionDirectoryPath);

    CleanDirectories(solutionDirectoryPath + "/**/bin/" + configuration);
    CleanDirectories(solutionDirectoryPath + "/**/obj/" + configuration);

    Information("Cleaning {0}...", buildDirectoryPath);

    CleanDirectories(buildDirectoryPath);
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
    .IsDependentOn("Run-GitVersion-Local")
    .IsDependentOn("Run-GitVersion-AppVeyor")
    .IsDependentOn("DupFinder")
    .IsDependentOn("InspectCode")
    .WithCriteria(Tasks.Any(x => x.Name == "Print-AppVeyor-Environment-Variables"))
    .Does(() =>
{
    Information("Building {0}", solutionFilePath);

    MSBuild(solutionFilePath, settings =>
        settings.SetPlatformTarget(PlatformTarget.MSIL)
            .WithProperty("TreatWarningsAsErrors","true")
            .WithProperty("OutDir", MakeAbsolute((FilePath)buildDirectoryPath).FullPath)
            .WithTarget("Build")
            .SetConfiguration(configuration));
});

Task("Create-Build-Directories")
    .Does(() =>
{
    if (!DirectoryExists(buildDirectoryPath))
    {
        CreateDirectory(buildDirectoryPath);
    }

    if (!DirectoryExists(resharperReportsDirectoryPath))
    {
        CreateDirectory(resharperReportsDirectoryPath);
    }

    if (!DirectoryExists(tempBuildDirectoryPath))
    {
        CreateDirectory(tempBuildDirectoryPath);
    }
});

Task("Create-NuGet-Package")
    .IsDependentOn("Test")
    .IsDependentOn("Build")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    var nuGetPackSettings   = new NuGetPackSettings {
                                Id                      = product,
                                Version                 = semVersion,
                                Title                   = title,
                                Authors                 = new[] {company},
                                Owners                  = new[] {company},
                                Description             = description,
                                Summary                 = description,
                                ProjectUrl              = projectUrl,
                                LicenseUrl              = licenseUrl,
                                Copyright               = copyright,
                                ReleaseNotes            = releaseNotes,
                                Tags                    = tags,
                                RequireLicenseAcceptance= false,
                                Symbols                 = false,
                                NoPackageAnalysis       = true,
                                Files                   = nugetFiles,
                                BasePath                = binDirectoryPath,
                                OutputDirectory         = buildDirectoryPath
                            };

    // NuGetPack(nuGetPackSettings);
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

	if(isTag)
    {
        apiKey = EnvironmentVariable("NUGET_API_KEY");
	}

    if(string.IsNullOrEmpty(apiKey))
    {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget API key.");
    }

    var source = EnvironmentVariable("MYGET_DEVELOP_SOURCE");
    if(!isDevelopBranch)
    {
        source = EnvironmentVariable("MYGET_MASTER_SOURCE");
    }

    if(isTag)
    {
        source = EnvironmentVariable("NUGET_SOURCE");
    }

    if(string.IsNullOrEmpty(source))
    {
        throw new InvalidOperationException("Could not resolve MyGet/Nuget source.");
    }

    // Get the path to the package.
    var package = buildDirectoryPath + "/" + product + "." + semVersion + ".nupkg";

    // Push the package.
    NuGetPush(package, new NuGetPushSettings {
        Source = source,
        ApiKey = apiKey
    });
});

Task("Test-NUnit")
    .WithCriteria(DirectoryExists(NUnitTestResultsDirectory))
    .Does(() =>
{
});

Task("Test-xUnit")
    .WithCriteria(DirectoryExists(xUnitTestResultsDirectory))
    .Does(() =>
{
});

Task("Test-MSTest")
    .WithCriteria(DirectoryExists(MSTestTestResultsDirectory))
    .Does(() =>
{
});

Task("Test")
    .IsDependentOn("Test-NUnit")
    .IsDependentOn("Test-xUnit")
    .IsDependentOn("Test-MSTest")
    .Does(() =>
{
});

Task("Default")
    .IsDependentOn("Create-NuGet-Package");

Task("AppVeyor")
    .IsDependentOn("Publish-Nuget-Package");

///////////////////////////////////////////////////////////////////////////////
// EXECUTION
///////////////////////////////////////////////////////////////////////////////
RunTarget(target);