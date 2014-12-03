require 'rubygems'
require 'bundler/setup'

require 'plist'
require 'parse-ruby-client'

require_relative 'paths.rb'

def updateParse (settings)

  Parse.init  application_id: settings[:deploy]["parse"]["appId"],
              api_key:        settings[:deploy]["parse"]["apiKey"]
              
  parseInfos = settings[:deploy]["parse"]
  
  objectId = parseInfos["objectId"]
  
  if (objectId.nil? or objectId.length == 0)
    appVersion = Parse::Object.new("ApplicationVersion")
  else
    puts "On a déjà déployé cette version, on la met à jour"
    appVersionsQuery = Parse::Query.new("ApplicationVersion")
    appVersionsQuery.eq("objectId", objectId)
    appVersion = appVersionsQuery.get.first
  end

  appVersion["applicationId"]    = parseInfos["applicationId"]
  appVersion["versionNumber"]    = parseInfos["versionNumber"]
  appVersion["versionChangeLog"] = parseInfos["versionChangeLog"]
  appVersion["versionLevel"]     = parseInfos["versionLevel"].to_i
  appVersion["versionUrl"]       = publicPlistURL settings
  appVersion["changelogUrl"]     = publicChangelogURL settings

  result = appVersion.save
  
  if (objectId.nil? or objectId.length == 0)
    puts "le déploiement a été créée"
  else
    puts "le déploiement a bien été mis à jour"
  end  
  
  # on "met à jour" l'application
  
  appQuery = Parse::Query.new("Application")
  appQuery.eq("objectId", parseInfos["applicationId"])
  app = appQuery.get.first
  
  dontCare = app.save
  
  result["objectId"]
  
end

