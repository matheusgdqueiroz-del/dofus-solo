using System.Text;
using System.Text.Json;

var repoRoot = ResolveRepoRoot();
var artifactRelativePath = Path.Combine(
    "docs",
    "evidence",
    "s02-minimum-executable-surface",
    "health.json");
var artifactPath = Path.Combine(repoRoot, artifactRelativePath);

Directory.CreateDirectory(Path.GetDirectoryName(artifactPath)!);

var artifact = new HealthArtifact(
    Surface: "minimum-executable-surface",
    Status: "ok",
    Scope: "support-only",
    BuildCommand: "dotnet build src/MinimumExecutableSurface/MinimumExecutableSurface.csproj",
    RunCommand: "dotnet run --project src/MinimumExecutableSurface/MinimumExecutableSurface.csproj --no-build",
    ArtifactRelativePath: artifactRelativePath.Replace('\\', '/'));

var json = JsonSerializer.Serialize(artifact, new JsonSerializerOptions
{
    WriteIndented = true
});

File.WriteAllText(artifactPath, json + Environment.NewLine, new UTF8Encoding(encoderShouldEmitUTF8Identifier: false));

Console.WriteLine("Minimum executable surface ran successfully.");
Console.WriteLine($"Artifact: {artifactPath}");

static string ResolveRepoRoot()
{
    var current = new DirectoryInfo(AppContext.BaseDirectory);

    while (current is not null)
    {
        var agentsPath = Path.Combine(current.FullName, "AGENTS.md");
        var gitPath = Path.Combine(current.FullName, ".git");

        if (File.Exists(agentsPath) && Directory.Exists(gitPath))
        {
            return current.FullName;
        }

        current = current.Parent;
    }

    throw new InvalidOperationException("Could not resolve the repository root from the executable base directory.");
}

internal sealed record HealthArtifact(
    string Surface,
    string Status,
    string Scope,
    string BuildCommand,
    string RunCommand,
    string ArtifactRelativePath);
