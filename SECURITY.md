# Security and binary provenance

G-REDscript Profiler is a portable Cyberpunk 2077 profiling tool. No installer service is used.

## Native component

`G-REDscript-Profiler.dll` is built directly from the public Rust source in this repository by GitHub Actions. RED4ext loads it through the normal RED4ext plugin mechanism from:

```text
Cyberpunk 2077\red4ext\plugins\G-REDscript-Profiler.dll
```

The release package does not rely on an unexplained precompiled profiler DLL. The workflow builds the native DLL from source for the release and records its SHA-256 in the release provenance file.

## Managed install behavior

When the user explicitly chooses **INSTALL PROFILER**, the manager deploys only the profiler DLL and its managed data folder. It does not silently replace an unrelated RED4ext plugin.

If a different `G-REDscript-Profiler.dll` is already present, installation is blocked rather than overwriting it. A legacy alpha profiler DLL is also detected and blocks installation so both profiler DLLs cannot load together.

## Results and restore

GRSP-owned live capture output is copied and verified into the portable package's `RESULTS` directory before the live source is removed.

External frame-time captures are copy-only. G-REDscript Profiler does not move, delete, or modify the source files owned by the external profiler.

**RESTORE ORIGINAL STATE** removes the manager-owned profiler DLL and managed data after Cyberpunk 2077 has been closed. Remaining live GRSP output is archived first when possible.

## Build transparency

The canonical GitHub release contains:

- normal multi-file self-contained .NET 8 application files under `app\`
- GitHub-built `G-REDscript-Profiler.dll`
- exact generated `Cargo.lock` used by that build
- `BUILD_PROVENANCE.txt` with the native DLL SHA-256 and build-tool versions
- public source/build documentation
- separate SHA-256 file for the canonical release ZIP

The project is not published as an obfuscated or packed single-file executable.
