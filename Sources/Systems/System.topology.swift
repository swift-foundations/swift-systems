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

public import System_Primitives

#if canImport(Darwin_System)
import Darwin_System
#elseif canImport(Linux_System)
import Linux_System
#elseif canImport(Windows_System)
import Windows_System
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
        let cpuCount = Int(System.Processor.count)

        #if canImport(Darwin_System) || canImport(Linux_System) || canImport(Windows_System)
        let numa = System.Topology.NUMA.discover()
        #else
        let numa = Topology.NUMA.State.unavailable
        #endif

        return Topology(cpuCount: cpuCount, numa: numa)
    }
}
