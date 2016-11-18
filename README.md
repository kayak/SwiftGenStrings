# SwiftGenStrings

SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard `genstrings` command for Swift sources. The latter only supports the short form of the `NSLocalizedString` function but breaks as soon as you use any parameters other than `key` and `comment` as in

```
NSLocalizedString("DATE_RANGE", value: "%@ – %@", comment: "A range of dates")
```

The upstream issue is tracked [here](https://openradar.appspot.com/22133811).

## Usage

```
SwiftGenStrings [-s <routine>] [-o <outputDir>] files

OPTIONS
-s routine
    (Optional) Substitute routine for NSLocalizedString, useful when different macro is used.
-o outputDir
    (Optional) Specifies what directory Localizable.strings table is created in.
    Not specifying output directory will print script output content to standard output (console).
files
    List of files, that are used as source of Localizable.strings generation.
```

## Exporting a Binary

Project supplies a `Makefile`, to export a binary, run:
```
$ make
```
Exported binary can be found at `Products/SwiftGenStrings`

## Requirements

- Xcode 8
- Swift 3.0.1

## Limitations

- SwiftGenStrings currently doesn't support multiple tables, only the default one - `Localizable.strings`.
- It is not possible to use `NSLocalizedString` in string interpolation e.g.: `let hello = "--- \(NSLocalizedString("Hello world!", comment: ""))"` will not pickup the localized string.
