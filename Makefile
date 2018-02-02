test:
	xcodebuild test -project "SwiftGenStrings.xcodeproj" -scheme "SwiftGenStrings" -destination "platform=macOS"

release:
	xcodebuild -scheme "SwiftGenStrings" -configuration "Release" -destination "generic/platform=macOS" clean archive -archivePath "build/"
	mkdir -p Products
	cp build.xcarchive/Products/usr/local/bin/SwiftGenStrings Products/
