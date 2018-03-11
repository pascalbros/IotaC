//
//  Kerl.swift
//  IotaC
//
//  Created by Pasquale Ambrosini on 11/03/2018.
//

import Foundation
import fastiota

protocol CurlSource {
	func absorb(trits: [Int], offset: Int, length: Int) -> CurlSource
	func absorb(trits: [Int]) -> CurlSource
	func squeeze(trits: inout [Int], offset: Int, length: Int) -> [Int]
	func squeeze(trits: inout [Int]) -> [Int]
	func reset()
	func clone() -> CurlSource
}

typealias Pointer = UnsafeMutablePointer

class Kerl: CurlSource {
	
	var context: Pointer<SHA3_CTX>! = Pointer<SHA3_CTX>.allocate(capacity: 1)
	
	init() {
		kerl_initialize(self.context)
	}
	
	deinit {
		self.close()
	}
	
	fileprivate func close() {
		if self.context != nil {
			self.context.deallocate(capacity: 1)
			self.context = nil
		}
	}
	
	func absorb(trits t: [Int], offset: Int, length: Int) -> CurlSource {
		
		var off = offset
		var l = length
		if l % 243 != 0 {
			fatalError("Invalid length")
		}
		
		let trits = Pointer<trit_t>.allocate(capacity: 243)
		let bytes = Pointer<UInt8>.allocate(capacity: 48)
		defer {
			trits.deallocate(capacity: 243)
			bytes.deallocate(capacity: 48)
		}
		repeat {
			for i in off..<off+243 {
				trits[i] = trit_t(t[i])
			}
			trits[242] = 0
			trits_to_bytes(trits, bytes)
			
			kerl_absorb_chunk(self.context, bytes)
			off += 243
			l  -= 243
		} while l > 0
		
		return self
	}
	
	func absorb(trits: [Int]) -> CurlSource {
		return self.absorb(trits: trits, offset: 0, length: trits.count)
	}
	
	func squeeze(trits t: inout [Int], offset: Int, length: Int) -> [Int] {
		
		var off = offset
		var l = length
		if l % 243 != 0 {
			fatalError("Invalid length")
		}
		let trits = Pointer<trit_t>.allocate(capacity: 243)
		let bytes = Pointer<UInt8>.allocate(capacity: 48)
		let chars = Pointer<Int8>.allocate(capacity: 81)
		defer {
			trits.deallocate(capacity: 243)
			bytes.deallocate(capacity: 48)
			chars.deallocate(capacity: 81)
		}
		repeat {
			l -= 243
			for i in off..<off+243 {
				trits[i] = trit_t(t[i])
			}
			trits[242] = 0
			trits_to_bytes(trits, bytes)
			
			if l != 0 {
				kerl_squeeze_chunk(self.context, bytes)
			}else {
				kerl_squeeze_final_chunk(self.context, bytes)
				bytes_to_chars(bytes, chars, 48)
				chars_to_trits(chars, trits, 81)
			}
		} while l > 0
		
		for i in 0..<243 {
			t[i] = Int(trits[i])
		}
		return t
	}
	
	func squeeze(trits: inout [Int]) -> [Int] {
		return squeeze(trits: &trits, offset: 0, length: trits.count)
	}
	
	func reset() {
		kerl_initialize(self.context)
	}
	
	func clone() -> CurlSource {
		return Kerl()
	}
	
	
}
