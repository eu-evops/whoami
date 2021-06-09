$ErrorActionPreference = 'Stop';
$files = ""
Write-Host Starting build

if ($isWindows) {
  docker build --pull -t whoami -f Dockerfile.windows .
} else {
  docker pull golang
  docker build --platform "linux/$env:ARCH" -t whoami --build-arg "arch=$env:ARCH" .
}

docker images
