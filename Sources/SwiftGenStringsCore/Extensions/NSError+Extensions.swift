import Foundation

public extension NSError {

	convenience init(domain: String = "com.kayak.travel.SwiftGenStrings", code: Int = 1, description: String) {
		let userInfo = [NSLocalizedDescriptionKey: description]
		self.init(domain: domain, code: code, userInfo: userInfo)
	}

}
