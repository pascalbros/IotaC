Pod::Spec.new do |s|

  s.swift_version = '4.0'
  s.name         = "IotaC"
  s.version      = "0.0.3"
  s.summary      = "A Swift wrapper for Iota C implementation"

  s.description  = <<-DESC
  A Swift wrapper for Iota C implementation.
                   DESC

  s.homepage     = "https://github.com/pascalbros/IotaC"

  s.license      = "MIT (Copyright (c) 2018 Pasquale Ambrosini)"
  s.source       = { :git => "https://github.com/pascalbros/IotaC.git", :tag => "v#{s.version}" }
  s.author             = { "Pasquale Ambrosini" => "pasquale.ambrosini@gmail.com" }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.requires_arc = true

  s.module_map = 'IotaC.modulemap'
  s.source_files = 'Sources/**/*.{swift,c,h}'
  s.pod_target_xcconfig = {'SWIFT_INCLUDE_PATHS' => '$(PODS_TARGET_SRCROOT)/Sources/fastiota/**','LIBRARY_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/Sources/', 'SWIFT_VERSION' => '4.0'}
  s.preserve_paths  = 'Sources/fastiota/include/module.modulemap'
end
