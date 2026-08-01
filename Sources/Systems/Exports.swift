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

@_exported import System_Primitives

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    @_exported import Darwin_System
#elseif os(Linux) || os(Android)
    @_exported import Linux_System
#elseif os(Windows)
    @_exported import Windows_32_Kernel_System
#endif
