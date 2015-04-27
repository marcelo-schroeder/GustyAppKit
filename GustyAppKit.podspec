Pod::Spec.new do |s|
    s.name                  = 'GustyAppKit'
    s.version           = '1.0.0'
    s.summary           = 'A Cocoa Touch development kit that helps you develop high quality iOS apps faster.'
    s.homepage          = 'https://github.com/marcelo-schroeder/GustyAppKit'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://github.com/marcelo-schroeder/GustyAppKit.git', :tag => 'v1.0.0' }
    s.default_subspec   = 'CoreApp'
    s.subspec 'CoreApp' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/CoreApp/classes/**/*.{h,m}'
        ss.resource      = 'GustyAppKit/GustyAppKit/CoreApp/resources/**/*.*'
        ss.dependency 'GustyKit'
    end
    s.subspec 'GoogleMobileAdsSupport' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/GoogleMobileAdsSupport/classes/**/*.{h,m}'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_GoogleMobileAdsSupport=1' }
        ss.dependency 'GustyAppKit/CoreApp'
        ss.dependency 'Google-Mobile-Ads-SDK', '~> 6'
    end
    s.subspec 'FlurrySupport' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/FlurrySupport/classes/**/*.{h,m}'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_FlurrySupport=1' }
        ss.dependency 'GustyAppKit/CoreApp'
        ss.dependency 'FlurrySDK'
    end
    s.subspec 'Html' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/Html/classes/**/*.{h,m}'
        ss.resource      = 'GustyAppKit/GustyAppKit/Html/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_Html=1' }
        ss.dependency 'GustyAppKit/CoreApp'
        ss.dependency 'DTFoundation', '1.7.2'
        ss.dependency 'MWFeedParser', '1.0.1'
    end
    s.subspec 'Help' do |ss|
        ss.source_files  = 'GustyAppKit/GustyAppKit/Help/classes/**/*.{h,m}'
        ss.resource      = 'GustyAppKit/GustyAppKit/Help/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_Help=1' }
        ss.dependency 'GustyAppKit/CoreApp'
    end
end