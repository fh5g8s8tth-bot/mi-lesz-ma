# Egyszerű helyi szerver teszteléshez (nem kell hozzá Python/Node).
# Használat:  powershell -ExecutionPolicy Bypass -File tools\serve.ps1 [-Port 8770]
param([int]$Port = 8770)
$root = Split-Path -Parent $PSScriptRoot
$types = @{ ".html"="text/html; charset=utf-8"; ".js"="text/javascript; charset=utf-8"; ".webmanifest"="application/manifest+json";
  ".png"="image/png"; ".jpg"="image/jpeg"; ".json"="application/json"; ".xlsx"="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"; ".ics"="text/calendar" }
$l = New-Object System.Net.HttpListener
$l.Prefixes.Add("http://localhost:$Port/")
$l.Start()
Write-Host "Mi lesz ma?: http://localhost:$Port/  (gyoker: $root)"
while ($l.IsListening) {
  $c = $l.GetContext()
  try {
    $p = [Uri]::UnescapeDataString($c.Request.Url.AbsolutePath.TrimStart("/"))
    if ($p -eq "") { $p = "index.html" }
    $f = [IO.Path]::GetFullPath((Join-Path $root $p))
    if ($f.StartsWith($root) -and (Test-Path $f -PathType Leaf)) {
      $b = [IO.File]::ReadAllBytes($f)
      $t = $types[[IO.Path]::GetExtension($f).ToLower()]; if (-not $t) { $t = "application/octet-stream" }
      $c.Response.ContentType = $t
      $c.Response.Headers.Add("Cache-Control", "no-store")
      $c.Response.OutputStream.Write($b, 0, $b.Length)
    } else { $c.Response.StatusCode = 404 }
  } catch { $c.Response.StatusCode = 500 }
  $c.Response.Close()
}
