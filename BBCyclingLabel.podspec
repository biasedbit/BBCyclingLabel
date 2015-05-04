Pod::Spec.new do |s|
  s.name         = 'BBCyclingLabel'
  s.version      = '1.0.1'
  s.summary      = 'BBCyclingLabel is just like a UILabel but allows you to perform custom animations when changing text.'
  s.homepage     = 'http://biasedbit.com'
  s.author       = { 'Bruno de Carvalho' => 'bruno@biasedbit.com' }
  s.license      = { :type => 'Apache' }
  s.source       = { :git => 'https://github.com/brunodecarvalho/BBCyclingLabel.git', :tag => s.version }
  s.platform     = :ios, '5.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true
  s.source_files = 'BBCyclingLabel/*.{h,m}'
end
