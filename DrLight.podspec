#
#  Be sure to run `pod spec lint DrLight.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #
  s.name         = "DrLight"
  s.version      = "0.4.0"
  s.summary      = "a very simple,light kit to avoid crash in some cases"
  s.description  = "fresh ui in nonmain thread.add/remove KVO unpaired.pushing viewcontrollers frequently within a short perid.for example,add push code in viewDidLoad,before viewDidAppear has called,it is dangerous.It may caused crash cannot addsubView:self.pushing the same viewcontroller into one stack.send unrecognized selector"
  s.homepage     = "https://github.com/zanyfly/Dr.Light"
  s.license      = "MIT"
  s.author       = { "ivan" => "zanyfly@126.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/zanyfly/Dr.Light.git", :tag => "#{s.version}" }

  s.source_files = "DrLight", "DrLight/**/*.{h,m}"
  s.framework  = "UIKit"


end
