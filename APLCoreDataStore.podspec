Pod::Spec.new do |s|

  s.name         = "APLCoreDataStore"
  s.version      = "0.0.1"
  s.summary      = "CoreData stack with synchronized NSManagedObjectContexts for main and private queue."

  s.description  = <<-DESC
                   Concept and code is from ['A Guide to Core Data Concurrency' by Theodore Calmes](http://robots.thoughtbot.com/core-data).
                   DESC

  s.homepage     = "https://github.com/apploft/APLCoreDataStore"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  
  s.author       = { "Michael Kamphausen" => "michael.kamphausen@apploft.de" }
  
  s.platform     = :ios

  s.source       = { :git => "https://github.com/apploft/APLCoreDataStore.git", :tag => s.version.to_s }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  
  s.framework  = 'CoreData'
  s.requires_arc = true

end
