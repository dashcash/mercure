require "mercure/version"
require 'thor'
require 'plist'

require 'mercure/deploy'

module Mercure

  class Mercure < Thor
    
    desc "check", "will check if everything necessary for building easily is present"
    def check
      puts "checking. Missing tools will be installed, if possible."
      
    end

    desc "build JOB", "will build the job"
    option :p, :type => :boolean
    option :pinailleur, :type => :boolean
    def build(plist)
      if options[:pinailleur] or options[:p]
        buildDeploymentsByAsking plist
      else
        buildDeployments plist
      end
    end
    
    desc "upload JOB", "will upload the job (must have been 'build' before)"
    option :p, :type => :boolean
    option :pinailleur, :type => :boolean
    def upload(plist)
      if options[:pinailleur] or options[:p]
        uploadDeploymentsByAsking plist
      else
        uploadDeployments plist
      end
    end
    
    desc "deploy JOB", "will deploy the job (must have been 'build' and 'upload' before)"
    option :p, :type => :boolean
    option :pinailleur, :type => :boolean
    def deploy(plist)      
      if options[:pinailleur] or options[:p]
        deployDeploymentsByAsking plist
      else
        deployDeployments plist
      end
    end
    
    desc "pan JOB", "will build, upload and deploy the job"
    option :p, :type => :boolean
    option :pinailleur, :type => :boolean
    def pan(plist)
      if options[:pinailleur] or options[:p]
        panDeploymentsByAsking plist
      else
        panDeployments plist
      end
    end
    
  end
  
end


 