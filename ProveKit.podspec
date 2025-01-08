Pod::Spec.new do |spec|
spec.name         = "ProveKit"
spec.version      = "1.0.0"
spec.summary      = "Accelerate customer onboarding with the Mono Prove Widget"
spec.description  = <<-DESC
The Mono Prove SDK is a quick and secure way to onboard your users from within your iOS app. Mono Prove is a customer onboarding product that offers businesses faster customer onboarding and prevents fraudulent sign-ups, powered by the MDN and facial recognition technology.
DESC
spec.homepage     = "https://mono.co"
spec.license      = { :type => "MIT", :file => "LICENSE" }
spec.author             = { "Mono" => "victor.o@mono.co" }
spec.documentation_url = "https://github.com/withmono/prove-ios"
spec.platforms = { :ios => "12.0" }
spec.swift_version = "5.4"
spec.source       = { :git => "https://github.com/withmono/prove-ios.git", :tag => "#{spec.version}" }
spec.source_files  = "Sources/ProveKit/**/*.swift"
spec.xcconfig = { "SWIFT_VERSION" => "5.4" }
end
