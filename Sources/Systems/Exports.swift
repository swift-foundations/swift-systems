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

#if canImport(Darwin_System)
@_exported import Darwin_System
#elseif canImport(Linux_System)
@_exported import Linux_System
#elseif canImport(Windows_System)
@_exported import Windows_System
#endif
