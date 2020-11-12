test:
	swift test

release:
	swift build -c release
	mkdir -p Products
	cp .build/release/SwiftGenStrings Products/SwiftGenStrings
