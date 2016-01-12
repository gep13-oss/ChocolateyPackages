///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.ReSharperReports
#addin Cake.Gitter
#addin Cake.Slack

///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////
#tool GitVersion.CommandLine
#tool gitreleasemanager
#tool JetBrains.ReSharper.CommandLineTools
#tool ReSharperReports

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

Task("Print-AppVeyor-Environment-Variables")
    .WithCriteria(AppVeyor.IsRunningOnAppVeyor)
    .Does(() =>
{
    Information("CI: {0}", EnvironmentVariable("CI"));
    Information("APPVEYOR_API_URL: {0}", EnvironmentVariable("APPVEYOR_API_URL"));
    Information("APPVEYOR_PROJECT_ID: {0}", EnvironmentVariable("APPVEYOR_PROJECT_ID"));
    Information("APPVEYOR_PROJECT_NAME: {0}", EnvironmentVariable("APPVEYOR_PROJECT_NAME"));
    Information("APPVEYOR_PROJECT_SLUG: {0}", EnvironmentVariable("APPVEYOR_PROJECT_SLUG"));
    Information("APPVEYOR_BUILD_FOLDER: {0}", EnvironmentVariable("APPVEYOR_BUILD_FOLDER"));
    Information("APPVEYOR_BUILD_ID: {0}", EnvironmentVariable("APPVEYOR_BUILD_ID"));
    Information("APPVEYOR_BUILD_NUMBER: {0}", EnvironmentVariable("APPVEYOR_BUILD_NUMBER"));
    Information("APPVEYOR_BUILD_VERSION: {0}", EnvironmentVariable("APPVEYOR_BUILD_VERSION"));
    Information("APPVEYOR_PULL_REQUEST_NUMBER: {0}", EnvironmentVariable("APPVEYOR_PULL_REQUEST_NUMBER"));
    Information("APPVEYOR_PULL_REQUEST_TITLE: {0}", EnvironmentVariable("APPVEYOR_PULL_REQUEST_TITLE"));
    Information("APPVEYOR_JOB_ID: {0}", EnvironmentVariable("APPVEYOR_JOB_ID"));
    Information("APPVEYOR_REPO_PROVIDER: {0}", EnvironmentVariable("APPVEYOR_REPO_PROVIDER"));
    Information("APPVEYOR_REPO_SCM: {0}", EnvironmentVariable("APPVEYOR_REPO_SCM"));
    Information("APPVEYOR_REPO_NAME: {0}", EnvironmentVariable("APPVEYOR_REPO_NAME"));
    Information("APPVEYOR_REPO_BRANCH: {0}", EnvironmentVariable("APPVEYOR_REPO_BRANCH"));
    Information("APPVEYOR_REPO_TAG: {0}", EnvironmentVariable("APPVEYOR_REPO_TAG"));
    Information("APPVEYOR_REPO_TAG_NAME: {0}", EnvironmentVariable("APPVEYOR_REPO_TAG_NAME"));
    Information("APPVEYOR_REPO_COMMIT: {0}", EnvironmentVariable("APPVEYOR_REPO_COMMIT"));
    Information("APPVEYOR_REPO_COMMIT_AUTHOR: {0}", EnvironmentVariable("APPVEYOR_REPO_COMMIT_AUTHOR"));
    Information("APPVEYOR_REPO_COMMIT_TIMESTAMP: {0}", EnvironmentVariable("APPVEYOR_REPO_COMMIT_TIMESTAMP"));
    Information("APPVEYOR_SCHEDULED_BUILD: {0}", EnvironmentVariable("APPVEYOR_SCHEDULED_BUILD"));
    Information("APPVEYOR_FORCED_BUILD: {0}", EnvironmentVariable("APPVEYOR_FORCED_BUILD"));
    Information("APPVEYOR_RE_BUILD: {0}", EnvironmentVariable("APPVEYOR_RE_BUILD"));
    Information("PLATFORM: {0}", EnvironmentVariable("PLATFORM"));
    Information("CONFIGURATION: {0}", EnvironmentVariable("CONFIGURATION"));
});

Task("Run-GitVersion-AppVeyor")
    .WithCriteria(AppVeyor.IsRunningOnAppVeyor)
    .Does(() =>
{
    GitVersion(new GitVersionSettings {
        UpdateAssemblyInfoFilePath = sourceDirectoryPath + "/SolutionInfo.cs",
        UpdateAssemblyInfo = true,
        OutputType = GitVersionOutput.BuildServer
    });
    
    semVersion = EnvironmentVariable("GitVersion_LegacySemVerPadded");
    
    if(string.IsNullOrEmpty(semVersion))
    {
        assertedVersions = GitVersion(new GitVersionSettings {
            OutputType = GitVersionOutput.Json,
        });
        
        semVersion = assertedVersions.LegacySemVerPadded;
    }
    
    Information("Calculated Semantic Version: {0}", semVersion);
});

Task("Run-GitVersion-Local")
    .WithCriteria(!AppVeyor.IsRunningOnAppVeyor)
    .Does(() =>
{
    assertedVersions = GitVersion(new GitVersionSettings {
        OutputType = GitVersionOutput.Json,
    });
    
    semVersion = assertedVersions.LegacySemVerPadded;
    
    Information("Calculated Semantic Version: {0}", semVersion);
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
    
    NuGetRestore(solutionFilePath);
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
    .Does(() =>
{
    Information("Building {0}", solutionFilePath);
    
    MSBuild(solutionFilePath, settings =>
        settings.SetPlatformTarget(PlatformTarget.MSIL)
            .WithProperty("TreatWarningsAsErrors","true")
            .WithTarget("Build")
            .SetConfiguration(configuration));
});

Task("DupFinder")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    DupFinder(solutionFilePath, new DupFinderSettings() {
        ShowStats = true,
        ShowText = true,
        OutputFile = resharperReportsDirectoryPath + "/dupfinder.xml",
        ThrowExceptionOnFindingDuplicates = true
    });
})
.ReportError(exception =>
{
    Information("Duplicates were found in your codebase, creating HTML report...");
    ReSharperReports.Transform(
        resharperReportsDirectoryPath + "/dupfinder.xml", 
        resharperReportsDirectoryPath + "/dupfinder.html");
});

Task("InspectCode")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    InspectCode(solutionFilePath, new InspectCodeSettings() {
        SolutionWideAnalysis = true,
        Profile = sourceDirectoryPath + resharperSettingsFileName,
        OutputFile = resharperReportsDirectoryPath + "/inspectcode.xml",
        ThrowExceptionOnFindingViolations = true
    });
})
.ReportError(exception =>
{
    Information("Violations were found in your codebase, creating HTML report...");
    ReSharperReports.Transform(
        resharperReportsDirectoryPath + "/inspectcode.xml", 
        resharperReportsDirectoryPath + "/inspectcode.html");
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