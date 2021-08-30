#
# Be sure to run `pod lib lint HalfModalView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HalfModalView'
  s.version          = '1.0.2'
  s.summary          = 'A short description of HalfModalView.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/710csm/HalfModalView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ChoiSeungMyeong' => '710csm@naver.com' }
  s.source           = { :git => 'https://github.com/710csm/HalfModalView.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'
  s.ios.deployment_target = '9'
  s.source_files = 'HalfModalView/Classes/**/*'
end
