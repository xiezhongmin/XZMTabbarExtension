Pod::Spec.new do |s|
    s.name         = 'XZMTabbarExtension'
    s.version      = '1.0.3'
    s.summary      = '史上最简单的定制tabBar个性化按钮 配置只需要一个方法'
    s.homepage     = 'https://github.com/xiezhongmin/XZMTabbarExtension'
    s.license      = 'MIT'
    s.authors      = {'xie1988' => '364101515@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/xiezhongmin/XZMTabbarExtension.git', :tag => s.version}
    s.source_files = 'XZMTabbarExtension/**/*.{h,m}'
    s.requires_arc = true
end
