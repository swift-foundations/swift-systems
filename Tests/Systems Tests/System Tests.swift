import Kernel_System
import Testing

@testable import Systems

extension System {
    @Suite
    struct Test {

        @Test
        func `topology returns valid data`() {
            let topology = System.topology()

            #expect(topology.cpuCount >= 1)

            switch topology.numa {
            case .unavailable:

                break

            case .uniformAccess:

                break

            case .nonUniform(let nodes):

                #expect(!nodes.isEmpty)
                for node in nodes {
                    #expect(!node.cpus.isEmpty)
                }
            }
        }

        @Test
        func `Processor.count matches topology cpuCount`() {
            let topology = System.topology()
            #expect(topology.cpuCount == Int(System.Processor.count))
        }
    }
}
