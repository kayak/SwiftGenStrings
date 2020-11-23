# SwiftGenStrings

SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard `genstrings` command for Swift sources. The latter only supports the short form of the `NSLocalizedString` function but breaks as soon as you use any parameters other than `key` and `comment` as in

```
NSLocalizedString("DATE_RANGE", value: "%@ – %@", comment: "A range of dates")
```

The upstream issue is tracked [here](https://openradar.appspot.com/22133811).

## Usage

```
SwiftGenStrings files
SwiftGenStrings [-s <routine>] [-o <outputDir>] files
SwiftGenStrings [-h|--help]

OPTIONS
-h|--help
    (Optional) Print help.
-s routine
    (Optional) Substitute routine for NSLocalizedString, useful when different macro is used.
-o outputDir
    (Optional) Specifies what directory Localizable.strings table is created in.
    Not specifying output directory will print script output content to standard output (console).
files
    List of files, that are used as source of Localizable.strings generation.
```

To gather strings in current directory, run:
```
$ find . -name "*.swift" | xargs SwiftGenStrings
```

If you have any 3rd party code like CocoaPods or Carthage in your project directory, you might want to exclude it from localization. To do that, run the following:
```
$ find . \( -name "*.swift" ! -path "./Carthage/*" ! -path "./Pods/*" \) | xargs SwiftGenStrings
```

## Installation

### [Mint](https://github.com/yonaskolb/mint)

The quickest and easiest way to install SwiftGenStrings is via Mint
```
$ mint install kayak/SwiftGenStrings
```

### Prebuilt Binaries

We tag releases and upload prebuilt binaries to GitHub. Checkout the [releases](https://github.com/kayak/SwiftGenStrings/releases) tab or go straight to the [latest](https://github.com/kayak/SwiftGenStrings/releases/latest) release.

### From Git

The project provides a `Makefile`. To export a binary run:

```
$ make release
```

The exported binary can be found under `Products/SwiftGenStrings`. Alternatively you can use `make install` to install the compiled library directly into `/usr/local/bin/SwiftGenStrings`

### CocoaPods

A podspec file for the project was released (see [here](https://cocoapods.org/pods/SwiftGenStrings)). To consume the project, simply add the following to your `Podfile`:

```
pod 'SwiftGenStrings'
```

After running `pod install` or `pod update`, you will then find the binary under `Pods/SwiftGenStrings/SwiftGenStrings`

## Testing

Since SwiftGenStrings is a SPM package, running tests is easy:
```
$ swift test
```

## Requirements

- Xcode 12
- Swift 5.3

## Limitations

- SwiftGenStrings currently doesn't support multiple tables, only the default one - `Localizable.strings`.
- It is not possible to use `NSLocalizedString` in string interpolation e.g.: `let hello = "--- \(NSLocalizedString("Hello world!", comment: ""))"` will not pickup the localized string.
