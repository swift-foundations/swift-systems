internal import Kernel
public import System

#if os(macOS) || os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
    import Darwin_System
#elseif os(Linux) || os(Android)
    import Linux_System
#elseif os(Windows)
    import Windows_32_Kernel_System
#endif

extension System {

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
