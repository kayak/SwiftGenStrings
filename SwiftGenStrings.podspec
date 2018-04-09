Pod::Spec.new do |s|
  s.name                  = "SwiftGenStrings"
  s.version               = "0.0.1"
  s.summary               = "genstrings replacement for Swift that actually works"
  s.description           = <<-DESC
    SwiftGenStrings is a command line application that can be used as a drop-in replacement for the standard genstrings command for Swift sources. The latter only supports the short form of the NSLocalizedString function but breaks as soon as you use any parameters other than key and comment.
	DESC
  s.homepage              = "https://github.com/kayak/SwiftGenStrings"
  s.license               = "Apache License, Version 2.0"
  s.authors               = { "Juraj Blahunka" => "jblahunka@kayak.com", "Johannes Marbach" => "johannesmarbach@gmail.com" }
  s.platform              = :osx
  s.osx.deployment_target = "10.9"
  s.source                = { :git => "https://github.com/kayak/SwiftGenStrings.git", :tag => "#{s.version}" }
  s.source_files          = "SwiftGenStrings"
end
