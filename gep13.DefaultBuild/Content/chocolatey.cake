Task("Create-Chocolatey-Packages")
    .IsDependentOn("Analyze")
    .IsDependentOn("Build")
    .IsDependentOn("Test")
    .WithCriteria(() => DirectoryExists(parameters.Paths.Directories.ChocolateyNuspecDirectory))
    .Does(() =>
{
    // NuGetPack(nuGetPackSettings);
});