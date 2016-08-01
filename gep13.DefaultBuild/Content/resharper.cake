///////////////////////////////////////////////////////////////////////////////
// ADDINS
///////////////////////////////////////////////////////////////////////////////
#addin Cake.ReSharperReports

///////////////////////////////////////////////////////////////////////////////
// TOOLS
///////////////////////////////////////////////////////////////////////////////
#tool JetBrains.ReSharper.CommandLineTools
#tool ReSharperReports

///////////////////////////////////////////////////////////////////////////////
// Environment Variables
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// TASK DEFINITIONS
///////////////////////////////////////////////////////////////////////////////
Task("DupFinder")
    .IsDependentOn("Clean")
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
    .IsDependentOn("Clean")
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