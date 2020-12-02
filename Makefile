release:
	swift build -c release -v
	mkdir -p Products
	cp .build/release/SwiftGenStrings Products/SwiftGenStrings

install: release
	install -v Products/SwiftGenStrings /usr/local/bin/SwiftGenStrings

test:
	swift test -v
