Pod::Spec.new do |s|
  s.name = 'SwiftRequests'
  s.version = '0.1'
  s.summary = 'Simple network requester in Swift'
  s.homepage = 'https://github.com/justAnotherDev/SwiftRequests'
  s.source = { :git => 'https://github.com/justAnotherDev/SwiftRequests.git', :tag => s.version }

  s.ios.deployment_target = '7.0'
  s.source_files = 'SwiftRequests/*.swift'
  s.requires_arc = true
end