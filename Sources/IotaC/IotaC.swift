import Foundation

public struct IotaC {
	public static func newAddress(seed: String, index: Int, checksum: Bool, security: Int = 2) -> String {
		return FastIota.newAddress(seed: seed, index: index, checksum: checksum, security: security)
	}
}
