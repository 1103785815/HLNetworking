Pod::Spec.new do |spec|
  spec.name             = 'HLNetworking'
  spec.version          = '1.1.5'
  spec.license          = { :type => "MIT", :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/QianKun-HanLin/HLNetworking'
  spec.authors          = {"wangshiyu13" => "wangshiyu13@163.com"}
  spec.summary          = '基于AFNetworking的多范式网络请求管理器'
  spec.source           =  {:git => 'https://github.com/QianKun-HanLin/HLNetworking.git', :tag => spec.version }
  spec.requires_arc     = true
  spec.ios.deployment_target = '8.0'

  spec.subspec 'Core' do |core|

    core.source_files = 'HLNetworking/Source/HLNetworking.h', 'HLNetworking/Source/Config/**/*.{h,m}', 'HLNetworking/Source/API/**/*.{h,m}', 'HLNetworking/Source/Task/**/*.{h,m}'
    
    core.dependency 'AFNetworking', '~> 3.1.0'

    end

  spec.subspec 'Center' do |center|

    center.source_files = 'HLNetworking/Source/Center/*.{h,m}'

    center.dependency 'HLNetworking/Core'

    center.dependency 'YYModel'
  end
end
