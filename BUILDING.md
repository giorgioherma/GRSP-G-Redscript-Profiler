# Building G-REDscript Profiler

G-REDscript Profiler v1.0.0 is built from the public repository by the GitHub Actions workflow in `.github/workflows/build.yml`.

## Native profiler DLL

The native profiler is the Rust crate in this repository:

```text
src/lib.rs
Cargo.toml
```

The RED4ext Rust binding is pinned in `Cargo.toml` to:

```text
red4ext-rs revision c44146c
```

The release workflow resolves a `Cargo.lock`, builds with:

```powershell
cargo build --release --locked
```

and packages the resulting native binary as:

```text
G-REDscript-Profiler\payload\G-REDscript-Profiler.dll
```

The exact generated `Cargo.lock` used for the public build is included under `docs\Cargo.lock` in the release package.

## Managed application

The WinForms manager is published as a normal self-contained .NET 8 application:

```powershell
dotnet publish manager\GRedscriptProfiler.Manager.csproj -c Release -r win-x64 --self-contained true -p:PublishSingleFile=false -p:DebugType=None -p:DebugSymbols=false
```

The managed application and runtime are placed under `app\`.

## Root launcher

The small native root launcher is compiled on the Windows GitHub runner with the Visual Studio C++ toolchain. It contains normal Windows VERSIONINFO metadata and starts the managed application under `app\`.

## Release provenance

Every canonical release build records:

- Git source commit
- product version
- native profiler DLL SHA-256
- generated Cargo.lock SHA-256
- `rustc --version`
- `cargo --version`
- pinned `red4ext-rs` revision

The generated record is included as:

```text
G-REDscript-Profiler\docs\BUILD_PROVENANCE.txt
```

The release ZIP itself is hashed separately and its SHA-256 is published beside the GitHub Release asset.

## Install guide

`Install_Instructions.template.html` is the canonical self-contained install guide, including the full-resolution PNG screenshots. `tools/Build-InstallInstructions.ps1` copies and validates that guide as `Install_Instructions.html`, which is placed beside the profiler folder at the root of the release ZIP.

## Canonical release

GitHub Releases is the canonical public download location. The release workflow only refreshes the same-version v1.0.0 tag/asset when the workflow commit is still the current `main` HEAD.
