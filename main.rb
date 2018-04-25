require 'slack-ruby-client'
require 'pry'
require 'json'
require 'open-uri'

DOWNLOAD_PATH = 'emoji'
download_path_abs = File.expand_path(DOWNLOAD_PATH, __dir__)
Dir.mkdir(download_path_abs) unless File.exist?(download_path_abs)

Slack.configure do |config|
  config.token = ENV['SLACK_API_TOKEN']
  raise 'Missing ENV[SLACK_API_TOKEN]!' unless config.token
end

client = Slack::Web::Client.new
client.auth_test

res = client.emoji_list

raise 'Failed getting emoji list!' unless res.ok

File.write(
  File.expand_path('emoji.json', download_path_abs),
  JSON.pretty_generate(res.emoji))

res.emoji.map { |name, url|
  [name, URI.parse(url)]
}.to_h.select { |name, uri|
  !uri.path.nil?
}.map { |name, uri|
  ext = uri.path.match(/\.\w+$/).to_s
  filename = "#{name}#{ext}"
  Thread.new {
    puts "Downloading... #{filename}"
    uri.open { |io|
      File.binwrite(
        File.expand_path(filename, download_path_abs),
        io.read)
    }
  }
}.each { |t|
  t.join
}

puts "Finished!"
