[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Summary,

    [string]$Sprint,

    [switch]$SkipPush
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-GitRepo {
    git rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "This folder is not a Git repository."
    }
}

function Convert-ToSlug([string]$Value) {
    $clean = $Value.ToLowerInvariant()
    $clean = $clean -replace "[^a-z0-9]+", "-"
    $clean = $clean.Trim("-")
    if ([string]::IsNullOrWhiteSpace($clean)) {
        throw "Summary cannot be empty after sanitization."
    }
    return $clean
}

function Get-CurrentBranch {
    $branch = git branch --show-current
    if (-not $branch) {
        throw "Could not determine current branch."
    }
    return $branch.Trim()
}

function Get-SprintFromBranch([string]$Branch) {
    if ($Branch -match "work/(s\d{2})-") {
        return $Matches[1]
    }
    return "s00"
}

Assert-GitRepo

$branch = Get-CurrentBranch
$resolvedSprint = if ($Sprint) { $Sprint.ToLowerInvariant() } else { Get-SprintFromBranch $branch }
$slug = Convert-ToSlug $Summary
$timestamp = Get-Date -Format "yyyyMMdd-HHmm"
$tag = "cp-$timestamp-$resolvedSprint-$slug"
$commitMessage = "checkpoint($resolvedSprint): $Summary"

$changes = git status --porcelain
if (-not $changes) {
    throw "There are no changes to checkpoint."
}

git add -A
if ($LASTEXITCODE -ne 0) {
    throw "Failed to stage changes."
}

git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
    throw "Failed to create checkpoint commit."
}

git tag -a $tag -m "Checkpoint $tag"
if ($LASTEXITCODE -ne 0) {
    throw "Commit succeeded but tag creation failed."
}

if (-not $SkipPush) {
    git push -u origin $branch
    if ($LASTEXITCODE -ne 0) {
        throw "Checkpoint exists locally, but branch push failed."
    }

    git push origin $tag
    if ($LASTEXITCODE -ne 0) {
        throw "Checkpoint exists locally, but tag push failed."
    }
}

Write-Output "Checkpoint saved: $tag"
