# SwiftGenStrings

SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard `genstrings` command for Swift sources. The latter only supports the short form of the `NSLocalizedString` function but breaks as soon as you use any parameters other than `key` and `comment` as in

```
NSLocalizedString("DATE_RANGE", value: "%@ – %@", comment: "A range of dates")
```

The upstream issue is tracked [here](https://openradar.appspot.com/22133811).
