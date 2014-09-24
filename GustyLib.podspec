Pod::Spec.new do |s|
    s.name                  = 'GustyLib'
    s.version           = '0.1.14'
    s.summary           = 'A Cocoa Touch static library to help you develop high quality iOS apps faster.'
    s.homepage          = 'https://bitbucket.org/marcelo_schroeder/gustylib'
    s.license           = 'Apache-2.0'
    s.author            = { 'Marcelo Schroeder' => 'marcelo.schroeder@infoaccent.com' }
    s.platform          = :ios, '8.0'
    s.requires_arc      = true
    s.source            = { :git => 'https://bitbucket.org/marcelo_schroeder/gustylib.git', :tag => '0.1.14' }
    s.default_subspec   = 'Core'
    s.subspec 'Core' do |ss|
        ss.source_files  = 'GustyLib/GustyLib/Core/classes/**/*.{h,m}'
        ss.resource      = 'GustyLib/GustyLib/Core/resources/**/*.*'
        ss.dependency 'ODRefreshControl', '1.1.0'
    end
    s.subspec 'GoogleMobileAdsSupport' do |ss|
        ss.source_files  = 'GustyLib/GustyLib/GoogleMobileAdsSupport/classes/**/*.{h,m}'
        ss.resource      = 'GustyLib/GustyLib/GoogleMobileAdsSupport/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_GoogleMobileAdsSupport=1' }
        ss.dependency 'GustyLib/Core'
        ss.dependency 'Google-Mobile-Ads-SDK'
    end
    s.subspec 'FlurrySupport' do |ss|
        ss.source_files  = 'GustyLib/GustyLib/FlurrySupport/classes/**/*.{h,m}'
        ss.resource      = 'GustyLib/GustyLib/FlurrySupport/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_FlurrySupport=1' }
        ss.dependency 'GustyLib/Core'
        ss.dependency 'FlurrySDK'
    end
    s.subspec 'Html' do |ss|
        ss.source_files  = 'GustyLib/GustyLib/Html/classes/**/*.{h,m}'
        ss.resource      = 'GustyLib/GustyLib/Html/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_Html=1' }
        ss.dependency 'GustyLib/Core'
        ss.dependency 'DTFoundation', '1.7.2'
        ss.dependency 'MWFeedParser', '1.0.1'
    end
    s.subspec 'Help' do |ss|
        ss.source_files  = 'GustyLib/GustyLib/Help/classes/**/*.{h,m}'
        ss.resource      = 'GustyLib/GustyLib/Help/resources/**/*.*'
        ss.xcconfig      = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'IFA_AVAILABLE_Help=1' }
        ss.dependency 'GustyLib/Core'
        ss.dependency 'GustyLib/Html'
        ss.dependency 'WYPopoverController', '0.3.0'
    end
end
