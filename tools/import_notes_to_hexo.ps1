param(
  [string]$SourceRoot = 'D:\1400note\1410CS学习笔记\cs学习笔记\CTF学习笔记\2.比赛WP',
  [string]$NotebookRoot = 'D:\1400note\1410CS学习笔记\cs学习笔记',
  [string]$BlogRoot = 'D:\1400note\1490blog\blog',
  [int]$Limit = 10,
  [string]$OutputSubdir = 'imported/wp-pilot',
  [switch]$ClearOutput
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Sanitize-ImageName {
  param([Parameter(Mandatory = $true)][string]$Name)
  $base = [System.IO.Path]::GetFileNameWithoutExtension($Name)
  $ext = [System.IO.Path]::GetExtension($Name)
  $safeBase = ($base -replace '\s+', '-' -replace '[^0-9A-Za-z\-_]', '-').Trim('-')
  if ([string]::IsNullOrWhiteSpace($safeBase)) {
    $safeBase = 'image'
  }
  if ([string]::IsNullOrWhiteSpace($ext)) {
    $ext = '.png'
  }
  return ("{0}{1}" -f $safeBase, $ext.ToLowerInvariant())
}

function Resolve-ImageSource {
  param(
    [Parameter(Mandatory = $true)][string]$ImageRef,
    [Parameter(Mandatory = $true)][string]$NoteDir,
    [Parameter(Mandatory = $true)][string]$NotebookRoot,
    [Parameter(Mandatory = $true)][string]$SourceRoot
  )

  $clean = $ImageRef -replace '/', '\'
  $fileName = [System.IO.Path]::GetFileName($clean)
  $candidates = @(
    (Join-Path $NoteDir $clean),
    (Join-Path (Join-Path $NotebookRoot '图片') $fileName),
    (Join-Path (Join-Path $NotebookRoot 'CTF学习笔记\6.图片') $fileName),
    (Join-Path (Join-Path $NotebookRoot 'CTF学习笔记\图片') $fileName),
    (Join-Path (Join-Path $SourceRoot '图片') $fileName)
  )

  foreach ($candidate in $candidates) {
    if (Test-Path -LiteralPath $candidate) {
      return (Resolve-Path -LiteralPath $candidate).Path
    }
  }
  return $null
}

function Add-Unique {
  param(
    [System.Collections.Generic.List[string]]$List,
    [AllowEmptyString()][string]$Value
  )
  if (-not [string]::IsNullOrWhiteSpace($Value) -and -not $List.Contains($Value)) {
    $List.Add($Value)
  }
}

function Convert-ObsidianContent {
  param(
    [AllowEmptyString()][string]$Content,
    [Parameter(Mandatory = $true)][string]$NoteDir,
    [Parameter(Mandatory = $true)][hashtable]$ImageMap,
    [Parameter(Mandatory = $true)][string]$ImageOutDir,
    [Parameter(Mandatory = $true)][string]$NotebookRoot,
    [Parameter(Mandatory = $true)][string]$SourceRoot,
    [Parameter(Mandatory = $true)][ref]$CopiedImageCount,
    [Parameter(Mandatory = $true)][ref]$MissingImages
  )

  $imagePattern = '!\[\[([^\]|]+)(?:\|[^\]]+)?\]\]'
  $contentWithImages = [System.Text.RegularExpressions.Regex]::Replace($Content, $imagePattern, {
      param($match)
      $imageRef = $match.Groups[1].Value.Trim()
      $ext = [System.IO.Path]::GetExtension($imageRef).ToLowerInvariant()
      if ($ext -notin @('.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.svg')) {
        return $match.Value
      }

      if (-not $ImageMap.ContainsKey($imageRef)) {
        $sourcePath = Resolve-ImageSource -ImageRef $imageRef -NoteDir $NoteDir -NotebookRoot $NotebookRoot -SourceRoot $SourceRoot
        if ([string]::IsNullOrWhiteSpace($sourcePath)) {
          $MissingImages.Value += $imageRef
          $ImageMap[$imageRef] = $null
        } else {
          $destName = Sanitize-ImageName -Name ([System.IO.Path]::GetFileName($imageRef))
          $destPath = Join-Path $ImageOutDir $destName

          if (Test-Path -LiteralPath $destPath) {
            $srcLen = (Get-Item -LiteralPath $sourcePath).Length
            $dstLen = (Get-Item -LiteralPath $destPath).Length
            if ($srcLen -ne $dstLen) {
              $stamp = [Math]::Abs($sourcePath.GetHashCode())
              $base = [System.IO.Path]::GetFileNameWithoutExtension($destName)
              $suffix = [System.IO.Path]::GetExtension($destName)
              $destName = '{0}-{1}{2}' -f $base, $stamp, $suffix
              $destPath = Join-Path $ImageOutDir $destName
            }
          }

          if (-not (Test-Path -LiteralPath $destPath)) {
            Copy-Item -LiteralPath $sourcePath -Destination $destPath -Force
            $CopiedImageCount.Value++
          }
          $ImageMap[$imageRef] = $destName
        }
      }

      $mappedName = $ImageMap[$imageRef]
      if ([string]::IsNullOrWhiteSpace($mappedName)) {
        return "**[图片缺失: $imageRef]**"
      }
      return "![](/img/notes/$mappedName)"
    })

  $linkPattern = '(?<!!)\[\[([^\]]+)\]\]'
  $finalContent = [System.Text.RegularExpressions.Regex]::Replace($contentWithImages, $linkPattern, {
      param($match)
      $inner = $match.Groups[1].Value.Trim()
      $parts = $inner -split '\|', 2
      if ($parts.Count -gt 1) {
        return $parts[1].Trim()
      }
      return $parts[0].Trim()
    })

  return $finalContent
}

$postsRoot = Join-Path $BlogRoot 'source\_posts'
$postOutDir = Join-Path $postsRoot $OutputSubdir
$imageOutDir = Join-Path $BlogRoot 'source\img\notes'
$reportSuffix = ($OutputSubdir -replace '[\\/]+', '-') -replace '[^0-9A-Za-z\-_]', '-'
if ([string]::IsNullOrWhiteSpace($reportSuffix)) {
  $reportSuffix = 'default'
}
$reportPath = Join-Path $BlogRoot ("tmp\import-report-{0}.json" -f $reportSuffix)

Ensure-Directory -Path $postOutDir
Ensure-Directory -Path $imageOutDir
Ensure-Directory -Path (Split-Path -Path $reportPath -Parent)

if ($ClearOutput -and (Test-Path -LiteralPath $postOutDir)) {
  Remove-Item -LiteralPath $postOutDir -Recurse -Force
  Ensure-Directory -Path $postOutDir
}

$files = Get-ChildItem -LiteralPath $SourceRoot -Recurse -File -Filter *.md |
  Sort-Object LastWriteTime -Descending |
  Select-Object -First $Limit

if ($null -eq $files -or $files.Count -eq 0) {
  throw "No markdown files were found in $SourceRoot."
}

$imageMap = @{}
$copiedImageCount = 0
$missingImages = @()
$writtenPosts = @()
$sourceRootName = Split-Path -Path $SourceRoot -Leaf

foreach ($file in $files) {
  $raw = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  if ([string]::IsNullOrWhiteSpace($raw)) {
    continue
  }
  $noteDir = Split-Path -Path $file.FullName -Parent
  $converted = Convert-ObsidianContent `
    -Content $raw `
    -NoteDir $noteDir `
    -ImageMap $imageMap `
    -ImageOutDir $imageOutDir `
    -NotebookRoot $NotebookRoot `
    -SourceRoot $SourceRoot `
    -CopiedImageCount ([ref]$copiedImageCount) `
    -MissingImages ([ref]$missingImages)

  $relative = $file.FullName.Substring($SourceRoot.Length + 1)
  $destPath = Join-Path $postOutDir $relative
  Ensure-Directory -Path (Split-Path -Path $destPath -Parent)

  $tags = New-Object 'System.Collections.Generic.List[string]'
  Add-Unique -List $tags -Value 'CTF'
  if ($sourceRootName -like '*比赛WP*') {
    Add-Unique -List $tags -Value 'WP'
  }
  if ($sourceRootName -like '*脚本*') {
    Add-Unique -List $tags -Value 'Script'
  }
  if ([System.Text.RegularExpressions.Regex]::IsMatch($file.FullName, '\\(Crypto|CRYPTO)\\') -or $file.BaseName -match 'RSA|AES|ECC|LCG|XOR|xor|base64') {
    Add-Unique -List $tags -Value 'Crypto'
  }
  if ([System.Text.RegularExpressions.Regex]::IsMatch($file.FullName, '\\Misc\\')) {
    Add-Unique -List $tags -Value 'Misc'
  }
  if ([System.Text.RegularExpressions.Regex]::IsMatch($file.FullName, '\\(Pwn|PWn|PWN)\\')) {
    Add-Unique -List $tags -Value 'Pwn'
  }
  if ([System.Text.RegularExpressions.Regex]::IsMatch($file.FullName, '\\(Reverse|Re)\\')) {
    Add-Unique -List $tags -Value 'Reverse'
  }

  $relativeDir = Split-Path -Path $relative -Parent
  $dirParts = @()
  if (-not [string]::IsNullOrWhiteSpace($relativeDir) -and $relativeDir -ne '.') {
    $dirParts = $relativeDir -split '\\'
  }
  $categories = New-Object 'System.Collections.Generic.List[string]'
  Add-Unique -List $categories -Value 'CTF学习笔记'
  Add-Unique -List $categories -Value $sourceRootName
  if ($dirParts.Count -ge 1) { Add-Unique -List $categories -Value $dirParts[0] }
  if ($dirParts.Count -ge 2) { Add-Unique -List $categories -Value $dirParts[1] }
  if ($dirParts.Count -ge 3) { Add-Unique -List $categories -Value $dirParts[2] }

  $title = $file.BaseName.Replace('"', '\"')
  $date = $file.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss')
  $sourceNote = $file.FullName.Replace('\', '/').Replace('"', '\"')

  $frontMatterLines = @('---')
  $frontMatterLines += "title: ""$title"""
  $frontMatterLines += "date: $date"
  $frontMatterLines += 'tags:'
  foreach ($tag in $tags) {
    $frontMatterLines += "  - $tag"
  }
  $frontMatterLines += 'categories:'
  foreach ($cat in $categories) {
    $frontMatterLines += "  - $cat"
  }
  $frontMatterLines += "source_note: ""$sourceNote"""
  $frontMatterLines += '---'
  $frontMatterLines += ''

  $output = ($frontMatterLines -join "`r`n") + $converted
  Set-Content -LiteralPath $destPath -Value $output -Encoding UTF8

  $writtenPosts += [PSCustomObject]@{
    source = $file.FullName
    output = $destPath
    date = $date
  }
}

$reportObject = [PSCustomObject]@{
  generated_at = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  source_root = $SourceRoot
  blog_root = $BlogRoot
  output_posts_dir = $postOutDir
  output_images_dir = $imageOutDir
  imported_count = $writtenPosts.Count
  copied_image_count = $copiedImageCount
  missing_images = ($missingImages | Sort-Object -Unique)
  posts = $writtenPosts
}

$reportObject | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $reportPath -Encoding UTF8

Write-Output "Imported posts: $($writtenPosts.Count)"
Write-Output "Copied images: $copiedImageCount"
Write-Output "Report: $reportPath"
