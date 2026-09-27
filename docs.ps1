New-Item -ItemType Directory -Path .\docbuild -Force | Out-Null

@'
name = "docbuild"
reservoir = false
version = "0.1.0"
packagesDir = "../.lake/packages"

[[require]]
scope = "leanprover"
name = "doc-gen4"
rev = "v4.32.1"

[[require]]
name = "se-theory-structural-assurability"
path = "../"
'@ | Set-Content -Path .\docbuild\lakefile.toml -Encoding utf8

Copy-Item .\lean-toolchain .\docbuild\lean-toolchain

Push-Location .\docbuild

# WHY: This repo depends on Mathlib; avoid Mathlib cache activity during update.
$env:MATHLIB_NO_CACHE_ON_UPDATE = "1"
lake update doc-gen4
Remove-Item Env:MATHLIB_NO_CACHE_ON_UPDATE

# WHY: Resolve the parent Structural Assurability project and its dependencies.
lake update se-theory-structural-assurability

Pop-Location

Write-Output "Done. Verify docbuild/ has 3 files:"
Write-Output "- lake-manifest.json"
Write-Output "- lakefile.toml"
Write-Output "- lean-toolchain"
