Task("Create-NuGet-Packages")
    .IsDependentOn("Analyze")
    .IsDependentOn("Build")
    .IsDependentOn("Test")
    .WithCriteria(() => DirectoryExists(parameters.Paths.Directories.NugetNuspecDirectory))
    .Does(() =>
{
    var nuspecFiles = GetFiles(parameters.Paths.Directories.NugetNuspecDirectory + "/**/*.nuspec");

    foreach(var nuspecFile in nuspecFiles)
    {
        // TODO: Addin the release notes
        // ReleaseNotes = parameters.ReleaseNotes.Notes.ToArray(),

        // Create packages.
        NuGetPack(nuspecFile, new NuGetPackSettings {
            Version = parameters.Version.SemVersion,
            BasePath = parameters.Paths.Directories.PublishedLibraries.Combine(nuspecFile.GetFilenameWithoutExtension().ToString()),
            OutputDirectory = parameters.Paths.Directories.Packages,
            Symbols = false,
            NoPackageAnalysis = true
        });
    }
});