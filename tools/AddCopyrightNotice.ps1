# Define the copyright notice
$notice = @"
// Copyright (c) 2025 MaintBoard.com. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.

"@

# Path to the lib folder
$libFolder = "lib"

# Get all .dart files in the lib folder and subfolders
Get-ChildItem -Path $libFolder -Recurse -Filter *.dart | ForEach-Object {
    $filePath = $_.FullName

    # Read the file content with correct encoding
    $content = Get-Content -Path $filePath -Raw

    # Check if the notice is already present
    if ($content -notmatch [regex]::Escape($notice.Trim())) {
        # Prepend the notice to the file with proper line endings
        $newContent = $notice + "`r`n" + $content
        Set-Content -Path $filePath -Value $newContent -NoNewline
    }
}