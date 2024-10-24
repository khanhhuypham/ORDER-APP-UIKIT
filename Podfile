# Uncomment the next line to define a global platform for your project
 platform :ios, '12.0'

target 'TECHRES-ORDER' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!


    pod 'RxSwift'
    pod 'RxCocoa'
    pod "RxGesture"
    pod 'SnapKit'
    pod 'Kingfisher'
    pod 'SocketRocket'
    pod 'Socket.IO-Client-Swift'
    pod 'Moya/RxSwift', '~> 15.0'
    pod 'Alamofire'

    pod 'ObjectMapper'
    pod 'SNCollectionViewLayout'
    pod 'OTPFieldView'
    pod 'RxBinding'
    pod 'RxDataSources'
    pod 'MSPeekCollectionViewDelegateImplementation'
    pod 'Charts'
    pod 'ZLPhotoBrowser'
    pod 'BmoViewPager'
    pod 'TagListView'
    pod 'JonAlert', :git => 'https://github.com/jonSurrey/JonAlert.git', :branch => 'master'
    pod 'RxSwiftExt'
#    pod 'lottie-ios'
    pod 'RealmSwift'
    # Pods for Example
    pod 'Wormholy'
    pod 'HXPhotoPicker', :git => 'https://github.com/SilenceLove/HXPhotoPicker.git'
    
    
    
    
    
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.1'
    end
  end
end



#arch -x86_64 pod install
#rvm reinstall ruby-3.2.2
#/usr/local/bin
#sudo gem install cocoapods
  
