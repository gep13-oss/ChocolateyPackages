///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.Gitter

///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////
#tool GitVersion.CommandLine

///////////////////////////////////////////////////////////////////////////////
// Environment Variables
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// TASK DEFINITIONS
///////////////////////////////////////////////////////////////////////////////
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
    
    // Due to the way that GitVersion is executed on AppVeyor, the Environment Variables although populated
    // are not accessible yet, so have to run GitVersion again, using OutputType of JSON
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