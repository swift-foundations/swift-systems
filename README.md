# swift-systems

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Cross-platform system introspection for Swift — one `System.topology()` call discovers processor count and NUMA layout on macOS, Linux, and Windows.

## Quick Start

Discovering NUMA topology normally means parsing `/sys/devices/system/node/` on Linux, calling `GetNumaHighestNodeNumber` / `GetNumaNodeProcessorMask` on Windows, and knowing that Darwin exposes no NUMA information at all. `System.topology()` folds all three into a single call with one typed result:

```swift
import Systems

let topology = System.topology()
print("CPUs: \(topology.cpuCount)")

switch topology.numa {
case .unavailable:
    print("NUMA discovery not supported on this platform")
case .uniformAccess:
    print("Single memory domain (UMA)")
case .nonUniform(let nodes):
    for node in nodes {
        print("Node \(node.id): \(node.cpus.count) CPUs")
    }
}
```

The result is `Sendable` and `Equatable`, so it can be captured once at startup and passed across concurrency domains — for example, to size a thread pool per NUMA node.

## Installation

Add swift-systems to your `Package.swift` (pre-release; no tags published yet):

```swift
dependencies: [
    .package(url: "https://github.com/swift-foundations/swift-systems.git", branch: "main")
]
```

Add the product to your target:

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "Systems", package: "swift-systems")
    ]
)
```

### Requirements

- Swift 6.3+
- macOS 26.0+, iOS 26.0+, tvOS 26.0+, watchOS 26.0+, visionOS 26.0+
- Linux and Windows via the platform-conditional modules below

## Architecture

`Systems` is an umbrella module: importing it re-exports the portable `System` namespace plus exactly one platform-specific system module, selected at compile time.

| Re-exported module | When you get it | What it contributes |
|--------------------|-----------------|---------------------|
| `System_Primitives` | Always | The `System` namespace: `System.Topology`, `System.Topology.NUMA.State` / `.Node`, typed quantities (`System.Processor.Count`, `System.Memory.Capacity`, `System.Page.Size`), `System.Name` |
| `Darwin_System` | macOS, iOS, tvOS, watchOS, visionOS | `System.Memory.total`, physical core count; NUMA reports `.unavailable` (Darwin does not expose NUMA) |
| `Linux_System` | Linux | NUMA discovery via `/sys/devices/system/node/` |
| `Windows_32_Kernel_System` | Windows | NUMA discovery via the Win32 NUMA API |

On top of the re-exports, this package defines `System.topology()`, which combines the processor count with platform NUMA discovery into one `System.Topology` value.

Quantities in the `System` namespace are typed, not raw integers: `System.Processor.Count`, `System.Memory.Capacity`, and `System.Page.Size` are distinct types, so a page size cannot be passed where a processor count is expected.

## Platform Support

| Platform | CI | Status |
|----------|-----|--------|
| macOS | Yes | Full support |
| Linux | Yes | Full support |
| Windows | — | Supported |
| iOS/tvOS/watchOS/visionOS | — | Supported |

## Community

<!-- BEGIN: discussion -->
*Discussion thread will be created at first public flip.*
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE](LICENSE.md).
