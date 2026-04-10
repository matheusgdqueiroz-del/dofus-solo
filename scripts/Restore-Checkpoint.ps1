[CmdletBinding()]
param(
    [string]$Tag,
    [string]$NewBranch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Assert-GitRepo {
    git rev-parse --is-inside-work-tree *> $null
    if ($LASTEXITCODE -ne 0) {
        throw "This folder is not a Git repository."
    }
}

function Assert-CleanWorkingTree {
    $status = git status --porcelain
    if ($status) {
        throw "Working tree is not clean. Save or stash your changes before restoring a checkpoint."
    }
}

Assert-GitRepo

git fetch --tags origin
if ($LASTEXITCODE -ne 0) {
    throw "Failed to fetch tags from origin."
}

if (-not $Tag) {
    Write-Output "Available checkpoints:"
    git tag --list "cp-*"
    Write-Output ""
    Write-Output "Use: .\\scripts\\Restore-Checkpoint.ps1 -Tag <checkpoint-tag>"
    exit 0
}

Assert-CleanWorkingTree

$resolvedBranch = if ($NewBranch) {
    $NewBranch
}
else {
    "restore/$Tag"
}

$exists = git show-ref --verify --quiet "refs/heads/$resolvedBranch"
if ($LASTEXITCODE -eq 0) {
    throw "Branch '$resolvedBranch' already exists. Choose a different -NewBranch name."
}

git checkout -b $resolvedBranch $Tag
if ($LASTEXITCODE -ne 0) {
    throw "Failed to create restore branch '$resolvedBranch' from tag '$Tag'."
}

Write-Output "Restore branch created: $resolvedBranch"
