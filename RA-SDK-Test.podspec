
Pod::Spec.new do |s|
  s.name             = 'RA-SDK-Test'
  s.version          = '1.6.0'
  s.summary          = '修改seelView中的文案'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
  s.homepage         = 'https://github.com/kover-ai/assurance-sdk-oc-sls-ra.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'winter' => 'winter@seel.com' }
  s.source           = { :git => 'https://github.com/kover-ai/assurance-sdk-oc-sls-ra.git', :tag => '1.6.0' }
  s.ios.deployment_target = '8.0'
  s.platform    = :ios, '9.0'
  s.vendored_frameworks = 'SeelKit.framework'
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }

end


