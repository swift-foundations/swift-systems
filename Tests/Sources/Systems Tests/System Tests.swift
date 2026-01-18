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

import Testing
@testable import System

@Suite("System")
struct SystemTests {

    @Test("topology returns valid data")
    func topologyReturnsValidData() {
        let topology = System.topology()

        #expect(topology.cpuCount >= 1)

        // NUMA state should be one of the valid cases
        switch topology.numa {
        case .unavailable:
            // Expected on Darwin
            break
        case .uniformAccess:
            // Expected on single-node systems
            break
        case .nonUniform(let nodes):
            // Multi-node NUMA system
            #expect(!nodes.isEmpty)
            for node in nodes {
                #expect(!node.cpus.isEmpty)
            }
        }
    }

    @Test("processorCount matches topology cpuCount")
    func processorCountMatchesTopologyCpuCount() {
        let topology = System.topology()
        #expect(topology.cpuCount == System.processorCount)
    }
}
