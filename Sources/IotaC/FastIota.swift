//
//  fastiota.swift
//  IotaCPackageDescription
//
//  Created by Pasquale Ambrosini on 10/03/2018.
//

import Foundation
import fastiota

class FastIota {
	static func newAddress(seed: String, index: Int, checksum: Bool, security: Int = 2) -> String {
		
		let address = UnsafeMutablePointer<UInt8>.allocate(capacity: 81)
		let seedBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: 48)
		let result = UnsafeMutablePointer<Int8>.allocate(capacity: 81)
		
		defer {
			address.deallocate(capacity: 81)
			seedBytes.deallocate(capacity: 48)
			result.deallocate(capacity: 81)
		}
		
		chars_to_bytes(seed, seedBytes, 81)
		get_public_addr(seedBytes, UInt32(index), UInt8(security), address)
		bytes_to_chars(address, result, 48);
		let str = String(cString: result)
		
		if checksum {
			let addressChecksum = UnsafeMutablePointer<UInt8>.allocate(capacity: 48)
			let addressChecksumResult = UnsafeMutablePointer<Int8>.allocate(capacity: 81)
			defer {
				addressChecksum.deallocate(capacity: 48)
				addressChecksumResult.deallocate(capacity: 81)
			}
			add_checksum(address, addressChecksum)
			bytes_to_chars(addressChecksum, addressChecksumResult, 48)
			
			let checksumResult = String(cString: addressChecksumResult).suffix(9)
			return String(str+checksumResult)
		}
		return str
	}
}
