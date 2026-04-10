[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [int]$SprintNumber,

    [Parameter(Mandatory = $true)]
    [string]$Slug,

    [string]$BaseBranch = "main",

    [switch]$Push
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
        throw "Working tree is not clean. Save or stash your changes before starting a new sprint branch."
    }
}

function Convert-ToSlug([string]$Value) {
    $clean = $Value.ToLowerInvariant()
    $clean = $clean -replace "[^a-z0-9]+", "-"
    $clean = $clean.Trim("-")
    if ([string]::IsNullOrWhiteSpace($clean)) {
        throw "Slug cannot be empty after sanitization."
    }
    return $clean
}

Assert-GitRepo
Assert-CleanWorkingTree

$safeSlug = Convert-ToSlug $Slug
$sprint = "s{0:d2}" -f $SprintNumber
$branch = "work/$sprint-$safeSlug"

git checkout $BaseBranch
if ($LASTEXITCODE -ne 0) {
    throw "Failed to checkout base branch '$BaseBranch'."
}

git pull --ff-only origin $BaseBranch
if ($LASTEXITCODE -ne 0) {
    throw "Failed to fast-forward '$BaseBranch' from origin."
}

git checkout -b $branch
if ($LASTEXITCODE -ne 0) {
    throw "Failed to create sprint branch '$branch'."
}

if ($Push) {
    git push -u origin $branch
    if ($LASTEXITCODE -ne 0) {
        throw "Branch '$branch' was created locally, but push failed."
    }
}

Write-Output "Created sprint branch: $branch"
