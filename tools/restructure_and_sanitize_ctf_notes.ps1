param(
  [string]$SourceRoot = 'D:\1400note\1410CS学习笔记\CTF学习笔记.md',
  [string]$OutputRoot = 'D:\1400note\1410CS学习笔记\CTF学习笔记_发布整理版',
  [switch]$Overwrite
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Ensure-Directory {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path -Force | Out-Null
  }
}

function Sanitize-FileName {
  param([Parameter(Mandatory = $true)][string]$Name)
  $safe = $Name -replace '[<>:"/\\|?*]', '-'
  $safe = $safe.Trim()
  if ([string]::IsNullOrWhiteSpace($safe)) {
    return 'untitled'
  }
  return $safe
}

function Is-ImagePath {
  param([Parameter(Mandatory = $true)][string]$PathText)
  $p = $PathText.Trim()
  return $p -match '\.(png|jpg|jpeg|gif|webp|bmp|svg)$'
}

function Is-PlaceholderNote {
  param(
    [Parameter(Mandatory = $true)][string]$RelativePath,
    [Parameter(Mandatory = $true)][string]$BaseName,
    [Parameter(Mandatory = $true)][string]$Content
  )

  $trimmed = $Content.Trim()
  if ($trimmed.Length -le 20) {
    return $true
  }

  $maybeIndexName = @(
    '模板', '刷题笔记', '原理学习笔记', '比赛WP', '日常刷题WP', 'Crypto', 'PWN',
    'Reverse', 'Misc', '电子取证', 'ISCC', '山河CTF', '西电新生赛', '山东信院CTF',
    '山东网络安全大赛', '2024技能兴鲁', '2025 SWPU-NSSCTF 秋季招新入门训练赛',
    'moe2025', '铸网决赛', '鹏云杯', '蓝桥杯wp', '技能兴鲁', '金砖', '密码学',
    '逆向', '原理', '一些工具', '古典加密', 'Crypto趣题-剪枝'
  )
  if ($maybeIndexName -contains $BaseName -and $trimmed.Length -lt 120) {
    return $true
  }

  if ($BaseName -match '^未命名$|^\(\)$') {
    return $true
  }

  return $false
}

function Get-CategoryPath {
  param([Parameter(Mandatory = $true)][string]$RelativePath)
  $parts = $RelativePath -split '\\'

  if ($RelativePath -match '^模板\\') {
    return '99-模板'
  }

  if ($RelativePath -match '^刷题笔记\\比赛WP\\') {
    $rest = $RelativePath.Substring(('刷题笔记\比赛WP\').Length)
    $restParts = $rest -split '\\'
    if ($restParts.Count -eq 1) {
      return '01-刷题笔记\比赛WP'
    }
    $event = [System.IO.Path]::GetFileNameWithoutExtension($restParts[0])
    if ($restParts.Count -gt 2) {
      $mid = $restParts[1..($restParts.Count - 2)] -join '\'
      return "01-刷题笔记\比赛WP\$event\$mid"
    }
    return "01-刷题笔记\比赛WP\$event"
  }

  if ($RelativePath -match '^刷题笔记\\日常刷题WP\\') {
    $rest = $RelativePath.Substring(('刷题笔记\日常刷题WP\').Length)
    $restParts = $rest -split '\\'
    if ($restParts.Count -eq 1) {
      return '01-刷题笔记\日常题单'
    }
    $topic = [System.IO.Path]::GetFileNameWithoutExtension($restParts[0])
    if ($restParts.Count -gt 2) {
      $mid = $restParts[1..($restParts.Count - 2)] -join '\'
      return "01-刷题笔记\日常题单\$topic\$mid"
    }
    return "01-刷题笔记\日常题单\$topic"
  }

  if ($RelativePath -match '^原理学习笔记\\密码学\\') {
    $rest = $RelativePath.Substring(('原理学习笔记\密码学\').Length)
    $restParts = $rest -split '\\'
    if ($restParts.Count -gt 1) {
      $mid = $restParts[0..($restParts.Count - 2)] -join '\'
      return "02-原理学习\密码学\$mid"
    }
    return '02-原理学习\密码学'
  }

  if ($RelativePath -match '^原理学习笔记\\逆向\\') {
    $rest = $RelativePath.Substring(('原理学习笔记\逆向\').Length)
    $restParts = $rest -split '\\'
    if ($restParts.Count -gt 1) {
      $mid = $restParts[0..($restParts.Count - 2)] -join '\'
      return "02-原理学习\逆向\$mid"
    }
    return '02-原理学习\逆向'
  }

  if ($RelativePath -match '^原理学习笔记\\') {
    return '02-原理学习\专题'
  }

  return '03-待归类'
}

function Resolve-ImageSource {
  param(
    [Parameter(Mandatory = $true)][string]$ImageRef,
    [Parameter(Mandatory = $true)][string]$SourceNoteDir,
    [Parameter(Mandatory = $true)][hashtable]$ImageIndex
  )
  $clean = ($ImageRef -split '\?')[0] -replace '/', '\'
  $clean = [System.Uri]::UnescapeDataString($clean)
  $clean = $clean.TrimStart('.\')
  if ([string]::IsNullOrWhiteSpace($clean)) { return $null }

  $direct = Join-Path $SourceNoteDir $clean
  if (Test-Path -LiteralPath $direct) {
    return (Resolve-Path -LiteralPath $direct).Path
  }

  $baseName = [System.IO.Path]::GetFileName($clean)
  if ($ImageIndex.ContainsKey($baseName) -and $ImageIndex[$baseName].Count -gt 0) {
    return $ImageIndex[$baseName][0]
  }

  # 兼容 Obsidian 常见“Pasted image xxx.png”与实际落盘“Pasted image xxx-时间戳.png”的差异
  $stem = [System.IO.Path]::GetFileNameWithoutExtension($baseName)
  $ext = [System.IO.Path]::GetExtension($baseName)
  if (-not [string]::IsNullOrWhiteSpace($stem) -and -not [string]::IsNullOrWhiteSpace($ext)) {
    $prefix = "$stem-"
    foreach ($key in $ImageIndex.Keys) {
      if ($key.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase) -and
        $key.EndsWith($ext, [System.StringComparison]::OrdinalIgnoreCase)) {
        if ($ImageIndex[$key].Count -gt 0) {
          return $ImageIndex[$key][0]
        }
      }
    }
  }

  return $null
}

function Redact-Privacy {
  param([Parameter(Mandatory = $true)][string]$Content)

  $result = $Content
  # 仅脱敏高置信度的个人信息字段，避免误伤题解里的“地址/数字”等技术内容
  $result = [regex]::Replace($result, '(?im)^([>\-\*\s]*姓名\s*[:：]\s*)([^\r\n]+)$', '$1[已脱敏]')
  $result = [regex]::Replace($result, '(?im)^([>\-\*\s]*学号\s*[:：]\s*)([^\r\n]+)$', '$1[已脱敏]')
  $result = [regex]::Replace($result, '(?im)^([>\-\*\s]*(?:学校|学院|所在地)\s*[:：]\s*)([^\r\n]+)$', '$1[已脱敏]')
  # 常见比赛 WP 署名行：WK-姓名-邮箱
  $result = [regex]::Replace($result, '(?im)^([\u200B\s]*WK-)[^-\r\n]{1,30}(-)[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\s*$', '$1[已脱敏]$2[email已脱敏]')

  return $result
}

function Build-HexoPostContent {
  param(
    [Parameter(Mandatory = $true)][string]$Title,
    [Parameter(Mandatory = $true)][datetime]$Date,
    [Parameter(Mandatory = $true)][string]$Body
  )

  $safeTitle = $Title.Replace('\', '\\').Replace('"', '\"')
  $dateText = $Date.ToString('yyyy-MM-dd HH:mm:ss')

  $fm = @(
    '---',
    "title: ""$safeTitle""",
    "date: $dateText",
    'disableNunjucks: true',
    '---',
    ''
  ) -join "`n"

  return $fm + $Body
}

if (-not (Test-Path -LiteralPath $SourceRoot)) {
  throw "Source root does not exist: $SourceRoot"
}

if ((Test-Path -LiteralPath $OutputRoot) -and $Overwrite) {
  Remove-Item -LiteralPath $OutputRoot -Recurse -Force
}

if ((Test-Path -LiteralPath $OutputRoot) -and -not $Overwrite) {
  throw "Output root already exists: $OutputRoot (use -Overwrite)"
}

Ensure-Directory -Path $OutputRoot

$reportsDir = Join-Path $OutputRoot '_reports'
Ensure-Directory -Path $reportsDir

$allImages = Get-ChildItem -LiteralPath $SourceRoot -Recurse -File | Where-Object { $_.Extension -in '.png', '.jpg', '.jpeg', '.gif', '.webp', '.bmp', '.svg' }
$imageIndex = @{}
foreach ($img in $allImages) {
  if (-not $imageIndex.ContainsKey($img.Name)) {
    $imageIndex[$img.Name] = New-Object 'System.Collections.Generic.List[string]'
  }
  $imageIndex[$img.Name].Add($img.FullName)
}

$mdFiles = Get-ChildItem -LiteralPath $SourceRoot -Recurse -File -Filter *.md

$stats = [PSCustomObject]@{
  generated_at = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
  source_root = $SourceRoot
  output_root = $OutputRoot
  total_md = $mdFiles.Count
  copied_notes = 0
  placeholder_notes = 0
  redacted_notes = 0
  copied_images = 0
  unresolved_image_refs = 0
}

$placeholderList = New-Object 'System.Collections.Generic.List[object]'
$privacyFindings = New-Object 'System.Collections.Generic.List[object]'
$unresolvedImages = New-Object 'System.Collections.Generic.List[object]'
$pathMappings = New-Object 'System.Collections.Generic.List[object]'
$copiedImageMap = @{}

foreach ($file in $mdFiles) {
  $raw = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
  $rel = $file.FullName.Substring($SourceRoot.Length + 1)
  $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
  $sourceDir = Split-Path -Path $file.FullName -Parent

  $isPlaceholder = Is-PlaceholderNote -RelativePath $rel -BaseName $baseName -Content $raw
  if ($isPlaceholder) {
    $stats.placeholder_notes++
    $placeholderList.Add([PSCustomObject]@{
        file = $rel
        chars = $raw.Length
      })
    continue
  }

  $categoryPath = Get-CategoryPath -RelativePath $rel
  $destDir = Join-Path $OutputRoot $categoryPath
  Ensure-Directory -Path $destDir

  $safeBaseName = Sanitize-FileName -Name $baseName
  $destFile = Join-Path $destDir ($safeBaseName + '.md')
  $n = 2
  while (Test-Path -LiteralPath $destFile) {
    $destFile = Join-Path $destDir ("{0}__{1}.md" -f $safeBaseName, $n)
    $n++
  }

  $privacyHit = $false
  $privacyPattern = '(?im)(^([>\-\*\s]*(?:姓名|学号|学校|学院|所在地)\s*[:：]\s*[^\r\n]+)$|^([\u200B\s]*WK-)[^-\r\n]{1,30}(-)[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\s*$)'
  $matches = [regex]::Matches($raw, $privacyPattern)
  if ($matches.Count -gt 0) {
    $privacyHit = $true
    $sample = ($matches | Select-Object -First 3 | ForEach-Object { $_.Value }) -join ' | '
    $privacyFindings.Add([PSCustomObject]@{
        file = $rel
        hit_count = $matches.Count
        sample = $sample
      })
  }

  $sanitized = Redact-Privacy -Content $raw

  if ($privacyHit) {
    $stats.redacted_notes++
  }

  $assetDestDir = Join-Path $destDir 'assets'
  Ensure-Directory -Path $assetDestDir

  $sanitized = [regex]::Replace($sanitized, '!\[([^\]]*)\]\(([^)]+)\)', {
      param($m)
      $alt = $m.Groups[1].Value
      $srcRef = $m.Groups[2].Value.Trim()
      if ($srcRef -match '^(https?:|data:|#)') { return $m.Value }
      if (-not (Is-ImagePath -PathText ($srcRef -split '\?')[0])) { return $m.Value }

      $resolved = Resolve-ImageSource -ImageRef $srcRef -SourceNoteDir $sourceDir -ImageIndex $imageIndex
      if ([string]::IsNullOrWhiteSpace($resolved)) {
        $stats.unresolved_image_refs++
        $unresolvedImages.Add([PSCustomObject]@{ file = $rel; image_ref = $srcRef }) | Out-Null
        return $m.Value
      }

      if (-not $copiedImageMap.ContainsKey($resolved)) {
        $imgName = Sanitize-FileName -Name ([System.IO.Path]::GetFileName($resolved))
        $destImg = Join-Path $assetDestDir $imgName
        $k = 2
        while (Test-Path -LiteralPath $destImg) {
          $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($imgName)
          $ext = [System.IO.Path]::GetExtension($imgName)
          $destImg = Join-Path $assetDestDir ("{0}__{1}{2}" -f $nameNoExt, $k, $ext)
          $k++
        }
        Copy-Item -LiteralPath $resolved -Destination $destImg -Force
        $copiedImageMap[$resolved] = $destImg
        $stats.copied_images++
      }

      $newName = [System.IO.Path]::GetFileName($copiedImageMap[$resolved])
      return "![${alt}](assets/$newName)"
    })

  $sanitized = [regex]::Replace($sanitized, '!\[\[([^\]]+)\]\]', {
      param($m)
      $inner = $m.Groups[1].Value.Trim()
      $imgRef = ($inner -split '\|')[0].Trim()
      if (-not (Is-ImagePath -PathText ($imgRef -split '\?')[0])) { return $m.Value }

      $resolved = Resolve-ImageSource -ImageRef $imgRef -SourceNoteDir $sourceDir -ImageIndex $imageIndex
      if ([string]::IsNullOrWhiteSpace($resolved)) {
        $stats.unresolved_image_refs++
        $unresolvedImages.Add([PSCustomObject]@{ file = $rel; image_ref = $imgRef }) | Out-Null
        return $m.Value
      }

      if (-not $copiedImageMap.ContainsKey($resolved)) {
        $imgName = Sanitize-FileName -Name ([System.IO.Path]::GetFileName($resolved))
        $destImg = Join-Path $assetDestDir $imgName
        $k = 2
        while (Test-Path -LiteralPath $destImg) {
          $nameNoExt = [System.IO.Path]::GetFileNameWithoutExtension($imgName)
          $ext = [System.IO.Path]::GetExtension($imgName)
          $destImg = Join-Path $assetDestDir ("{0}__{1}{2}" -f $nameNoExt, $k, $ext)
          $k++
        }
        Copy-Item -LiteralPath $resolved -Destination $destImg -Force
        $copiedImageMap[$resolved] = $destImg
        $stats.copied_images++
      }

      $newName = [System.IO.Path]::GetFileName($copiedImageMap[$resolved])
      return "![](assets/$newName)"
    })

  $finalContent = Build-HexoPostContent -Title $baseName -Date $file.LastWriteTime -Body $sanitized
  Set-Content -LiteralPath $destFile -Value $finalContent -Encoding UTF8
  $destRel = $destFile.Substring($OutputRoot.Length + 1)
  $pathMappings.Add([PSCustomObject]@{
      source_file = $rel
      output_file = $destRel
      category = $categoryPath
      privacy_redacted = $privacyHit
    }) | Out-Null
  $stats.copied_notes++
}

$stats | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $reportsDir 'summary.json') -Encoding UTF8
$placeholderList | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $reportsDir 'placeholder_notes.json') -Encoding UTF8
$privacyFindings | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $reportsDir 'privacy_findings.json') -Encoding UTF8
$unresolvedImages | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath (Join-Path $reportsDir 'unresolved_images.json') -Encoding UTF8
$pathMappings | Export-Csv -NoTypeInformation -Encoding UTF8 -LiteralPath (Join-Path $reportsDir 'path_mapping.csv')

Write-Output "Output root: $OutputRoot"
Write-Output "Copied notes: $($stats.copied_notes)"
Write-Output "Placeholders skipped: $($stats.placeholder_notes)"
Write-Output "Notes redacted: $($stats.redacted_notes)"
Write-Output "Copied images: $($stats.copied_images)"
Write-Output "Unresolved image refs: $($stats.unresolved_image_refs)"
