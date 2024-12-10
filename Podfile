#source 'https://cdn.cocoapods.org/'
source 'https://github.com/CocoaPods/Specs.git'
source 'https://gitlab.com/ahmedcs1/my-cocoapod.git'
source 'https://gitlab.com/ahmedcs1/helpers.git'

# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

use_frameworks!

def mocutsPods
  pod 'IQKeyboardManagerSwift', '~> 6.5.16' 
  pod 'CommonComponents'
  pod 'Helpers'
  pod 'SDWebImage', '~> 4.0'
  pod 'Helpers'
  pod 'DropDown', '2.3.12'
  pod 'ReachabilitySwift' , '4.3.1'
  pod 'Shimmer'
  pod 'FirebaseStorage'
  pod 'GooglePlaces'
  pod 'MonthYearPicker', '~> 4.0.2'
  pod 'Cosmos', '~> 23.0'
  pod 'RangeSeekSlider'
  pod 'CVCalendar', '~> 1.7.0'
  pod 'FacebookCore'
  pod 'FBSDKLoginKit'
  pod 'GoogleSignIn'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  
  pod 'SwiftyJSON'
  pod 'Alamofire', '~> 4.9.1'
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Messaging'
  pod 'PlacesPicker'
  pod 'GoogleMaps'
  pod 'Lightbox'
  pod 'ObjectMapper'
  pod 'OpalImagePicker'
  pod 'UIImageCropper'
  pod 'Stripe'
  pod 'Braintree'
  pod 'BraintreeDropIn'
  pod 'Braintree/ApplePay'
  pod 'lottie-ios'
  pod 'PayPal/CardPayments'
  pod 'PayPal/PayPalWebPayments'
  pod 'MaterialComponents/TextControls+FilledTextFields'
end

target 'MoCuts' do
  mocutsPods
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    end
   end
  end

end
