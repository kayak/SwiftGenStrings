release:
	swift build -c release
	mkdir -p Products
	cp .build/release/SwiftGenStrings Products/SwiftGenStrings

install:
	swift build -c release
	install -v .build/release/SwiftGenStrings /usr/local/bin/SwiftGenStrings
