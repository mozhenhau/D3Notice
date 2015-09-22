Pod::Spec.new do |s|
  s.name             = 'D3Notice'
  s.version          = '1.1.0'
  s.license          = { :type => "MIT", :file => 'LICENSE' }
  s.homepage         = 'https://github.com/mozhenhau/D3Notice'
  s.authors          = {"mozhenhau" => "493842062@qq.com"}
  s.summary          = 'D3Notice, swift alertview'
  s.source           =  {:git => 'https://github.com/mozhenhau/D3Notice.git', :tag => '1.1.0' }
  s.source_files     = 'D3Notice.swift'
  s.requires_arc     = true
  s.ios.deployment_target = '7.0'
end


