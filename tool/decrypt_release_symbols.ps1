param(
  [Parameter(Mandatory = $true)]
  [string]$Archive,
  [string]$OutputDirectory = 'release-symbols'
)

$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Security.Cryptography.ProtectedData
Add-Type -AssemblyName System.Security.Cryptography.Pkcs
$privateKeyPath = Join-Path $env:APPDATA 'UniversityApp\release-symbols\release-symbols-private.dpapi'
$certificatePath = Join-Path $PSScriptRoot 'release_symbols_public.pem'
$resolvedArchive = (Resolve-Path -LiteralPath $Archive).Path
$resolvedOutput = [System.IO.Path]::GetFullPath($OutputDirectory)
$temporaryArchive = Join-Path ([System.IO.Path]::GetTempPath()) "$([System.Guid]::NewGuid()).tar.gz"
$privateKey = $null

if (-not (Test-Path -LiteralPath $privateKeyPath)) {
  throw "Release symbols private key is missing at $privateKeyPath"
}

try {
  $protectedKey = [System.IO.File]::ReadAllBytes($privateKeyPath)
  $privateKey = [System.Security.Cryptography.ProtectedData]::Unprotect(
    $protectedKey,
    $null,
    [System.Security.Cryptography.DataProtectionScope]::CurrentUser
  )
  $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromPem(
    [System.IO.File]::ReadAllText($certificatePath),
    [System.Text.Encoding]::UTF8.GetString($privateKey)
  )
  $envelope = [System.Security.Cryptography.Pkcs.EnvelopedCms]::new()
  $envelope.Decode([System.IO.File]::ReadAllBytes($resolvedArchive))
  $certificates = [System.Security.Cryptography.X509Certificates.X509Certificate2Collection]::new()
  [void]$certificates.Add($certificate)
  $envelope.Decrypt($certificates)
  [System.IO.File]::WriteAllBytes($temporaryArchive, $envelope.ContentInfo.Content)
  New-Item -ItemType Directory -Force -Path $resolvedOutput | Out-Null
  tar -xzf $temporaryArchive -C $resolvedOutput
  if ($LASTEXITCODE -ne 0) {
    throw 'Failed to extract release symbols'
  }
} finally {
  if ($null -ne $privateKey) {
    [System.Array]::Clear($privateKey, 0, $privateKey.Length)
  }
  Remove-Item -LiteralPath $temporaryArchive -Force -ErrorAction SilentlyContinue
}
