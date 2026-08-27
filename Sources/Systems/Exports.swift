@_exported import System

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    @_exported import Darwin_System
#elseif os(Linux) || os(Android)
    @_exported import Linux_System
#elseif os(Windows)
    @_exported import Windows_32_Kernel_System
#endif
