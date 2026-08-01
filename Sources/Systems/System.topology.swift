// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-system open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-system project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

internal import Kernel
public import System_Primitives

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    import Darwin_System
#elseif os(Linux) || os(Android)
    import Linux_System
#elseif os(Windows)
    import Windows_32_Kernel_System
#endif

extension System {
    /// Discovers system topology.
    ///
    /// Delegates to platform-specific discovery for NUMA topology:
    /// - Linux: Parses /sys/devices/system/node/
    /// - Windows: Uses GetNumaHighestNodeNumber + GetNumaNodeProcessorMask
    /// - Darwin: Returns `.unavailable` (macOS/iOS don't expose NUMA)
    ///
    /// ## Usage
    /// ```swift
    /// let topology = System.topology()
    /// print("CPUs: \(topology.cpuCount)")
    ///
    /// switch topology.numa {
    /// case .unavailable:
    ///     print("NUMA discovery not supported")
    /// case .uniformAccess:
    ///     print("Single memory domain (UMA)")
    /// case .nonUniform(let nodes):
    ///     print("NUMA: \(nodes.count) nodes")
    /// }
    /// ```
    public static func topology() -> Topology {
        let cpuCount = Int(Self.Processor.count)

        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS) || os(Linux) || os(Android) || os(Windows)
            let numa = Self.Topology.NUMA.discover()
        #else
            let numa = Topology.NUMA.State.unavailable
        #endif

        return Topology(cpuCount: cpuCount, numa: numa)
    }
}
