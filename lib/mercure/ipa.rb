require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def generateIpa settings
    
  buildDirectory      = settings[:buildDirectory]
  buildConfiguration  = settings[:buildConfiguration]
  buildNumber         = settings[:buildNumber]
  applicationName     = settings[:applicationName]
  
  appPath       = appPath(settings)
  ipaPath       = ipaPath(settings)
  
  dsymPath        = dsymPath(settings)
  savedDsymPath   = savedDsymPath(settings)
  zippedDsymPath  = zippedDsymPath(settings)
  
  signingIdentity     = settings[:signingIdentity]
  provisioningProfile = settings[:provisioningProfile]
  
  system "mkdir -p \"#{buildDirectory}/logs/\""
    
  puts "Construction de l'IPA"
  
  # system("codesign -s \"#{signingIdentity}\" \"#{appPath}\"")
  
  signingCommand =  "/usr/bin/xcrun -sdk iphoneos PackageApplication"
  signingCommand +=  " -v \"#{appPath}\""
  signingCommand +=  " -o \"#{ipaPath}\""
  signingCommand +=  " --sign \"#{signingIdentity}\""
  signingCommand +=  " --embed \"#{provisioningProfile}\""
  signingCommand += " | tee \"#{buildDirectory}/logs/#{applicationName}_package.log\""
  
  system("echo \"#{signingCommand}\" | tee \"#{buildDirectory}/logs/#{applicationName}_package.log\" ")
  system signingCommand
  
  system("rm -R -f \"#{savedDsymPath}\"")
  system("cp -R \"#{dsymPath}\" \"#{savedDsymPath}\"")
  system("zip -r \"#{zippedDsymPath}\" \"#{savedDsymPath}\"")
  system("rm -R -f \"#{dsymPath}\"")
  
end
