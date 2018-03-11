import XCTest
@testable import IotaC

class IotaCTests: XCTestCase {
	
    func testAddress() {

		let address = IotaC.newAddress(seed: "SWIZCNVVDAZFVOQFCUTRTXLPEENBSVLSMEDXTDCTQOJSNIHODXQHQLPDCUZYOXDOIYXZASDYMJTKHCGMT", index: 0, checksum: true, security: 2)
		XCTAssertEqual(address, "PBAEWHDBQE9HIAAJBLDI9NQJMEBGDHPHD9XFBSZLDXLNSNFDUEKVQPAXDNS9IWXHJGAUNUNGZRRRGMCS9JMCK9YKCC")
    }
	
	func testKerl() {
		let string = "PBAEWHDBQE9HIAAJBLDI9NQJMEBGDHPHD9XFBSZLDXLNSNFDUEKVQPAXDNS9IWXHJGAUNUNGZRRRGMCS9JMCK9YKCC"
		var trits = IotaConverter.trits(trytes: string, length: 243)

		self.measure {
			let kerl = Kerl()
			_ = kerl.absorb(trits: trits)
			_ = kerl.squeeze(trits: &trits)
		}
		let result = IotaConverter.trytes(trits: trits)
		print(result)
	}


    static var allTests = [
        ("testExample", testAddress),
    ]
}
