///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.ReSharperReports

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
var isLocalBuild        = !AppVeyor.IsRunningOnAppVeyor;
var isPullRequest       = AppVeyor.Environment.PullRequest.IsPullRequest;
var isDevelopBranch     = AppVeyor.Environment.Repository.Branch == "develop";
var isTag               = AppVeyor.Environment.Repository.Tag.IsTag;
GitVersion assertedVersions = null;

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

Task("Show-Info")
    .Does(() =>
{
    // Output arguments.
    Information("Target: {0}", target);
    Information("Configuration: {0}", configuration);

    // Output directories.
    Information("Solution File: {0}", MakeAbsolute((FilePath)solution));
    Information("Solution Path: {0}", MakeAbsolute((DirectoryPath)solutionPath));
    Information("Source Path: {0}", MakeAbsolute((DirectoryPath)sourcePath));
    Information("Build Artifacts Path: {0}", MakeAbsolute((DirectoryPath)buildArtifacts));
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
        UpdateAssemblyInfoFilePath = sourcePath + "/SolutionInfo.cs",
        UpdateAssemblyInfo = true,
        OutputType = GitVersionOutput.BuildServer
    });
    
    semVersion = EnvironmentVariable("GitVersion_LegacySemVerPadded");
    
    string.IsNullOrEmpty(semVersion)
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
        OutputFile = buildArtifacts + "/_ReSharperReports/dupfinder.xml",
        ThrowExceptionOnFindingDuplicates = true
    });
})
.ReportError(exception =>
{
    Information("Duplicates were found in your codebase, creating HTML report...");
    ReSharperReports.Transform(
        buildArtifacts + "/_ReSharperReports/dupfinder.xml", 
        buildArtifacts + "/_ReSharperReports/dupfinder.html");
});

Task("InspectCode")
    .IsDependentOn("Create-Build-Directories")
    .Does(() =>
{
    // Run ReSharper's InspectCode
    InspectCode(solution, new InspectCodeSettings() {
        SolutionWideAnalysis = true,
        Profile = sourcePath + "/ReSharperReports.sln.DotSettings",
        OutputFile = buildArtifacts + "/_ReSharperReports/inspectcode.xml",
        ThrowExceptionOnFindingViolations = true
    });
})
.ReportError(exception =>
{
    Information("Violations were found in your codebase, creating HTML report...");
    ReSharperReports.Transform(
        buildArtifacts + "/_ReSharperReports/inspectcode.xml", 
        buildArtifacts + "/_ReSharperReports/inspectcode.html");
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
                                BasePath                = binDir,
                                OutputDirectory         = buildArtifacts
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
