Pod::Spec.new do |s|
  s.name           = "SwiftGenStrings"
  s.version        = "0.0.2"
  s.summary        = "genstrings replacement for Swift that actually works"
  s.description    = <<-DESC
    SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard genstrings command for Swift sources. The latter only supports the short form of the NSLocalizedString function but breaks as soon as you use any parameters other than key and comment.
	DESC
  s.homepage       = "https://github.com/kayak/SwiftGenStrings"
  s.license        = "Apache License, Version 2.0"
  s.authors        = { "Juraj Blahunka" => "jblahunka@kayak.com", "Johannes Marbach" => "johannesmarbach@gmail.com", "Henrik Panhans" => "hpanhans@kayak.com" }
  s.source         = { :http => "#{s.homepage}/releases/download/#{s.version}/SwiftGenStrings.zip" }
  s.platforms      = { "ios": "7.0", "tvos": "9.0", "osx": "10.9" }
  s.preserve_paths = "*"
  s.exclude_files  = "**/file.zip"
end
