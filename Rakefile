##################################################
# Require gems.
##################################################
require "yaml"
require "fileutils"
require "tmpdir"
require "rubygems"
require "bundler/setup"
require "highline/import"
# require "httparty"

# Get and parse the date
DATE = Time.now.strftime("%Y-%m-%d")
YEAR = Time.now.strftime("%Y")
MONTH = Time.now.strftime("%m")

##################################################
# Write a new post draft.
##################################################

desc 'Create a new post draft.'
task :post do
  # Define post variables by prompting.
  title       = ask "Enter the title: "
  subtitle    = ask "Enter the subtitle:"
  abstract    = ask "Enter any initial text (like an idea or thought) here if you have it ready: "
  topics      = ask "Enter the entry's topics:"
  slug_var    = HighLine.agree("Do you want a custom slug for this post? (y/n)")
  if slug_var == true
    slug_text   = ask "Okay, what should the slug be?"
    slug        = "#{slug_text.downcase.gsub(/[^\w|']+/, '-')}"
    slug_dashed = "#{slug.gsub(/[^a-zA-Z0-9\-]/, "")}"
    slug_fixed  = "#{slug_dashed.gsub(/\-$/, '')}"
  else
    slug        = "#{title.downcase.gsub(/[^\w|']+/, '-')}"
    slug_dashed = "#{slug.gsub(/[^a-zA-Z0-9\-]/, "")}"
    slug_fixed  = "#{slug_dashed.gsub(/\-$/, '')}"
  end

  # Define the draft's filename.
  file = File.join(
    File.dirname(__FILE__),
    'source/entries',
    "#{DATE}-#{slug_fixed}.html.md.erb"
  )

  # Create the draft file in the location defined above
  # and insert the content defined in the post variables.
  File.open(file, "w") do |f|
    f << <<-EOS.gsub(/^    /, '')
    ---
    title: \"#{title}\"
    subtitle: \"#{subtitle}\"
    abstract: \"#{title}\"
    topics: \"#{topics.split(" ").join(", ")}\"
    published: \"false\"
    ---

    EOS
  end
end

##################################################
# Notify the internet about new content
##################################################

desc 'Notify pingomatic about new posts'
task :pingomatic do
  begin
    require 'xmlrpc/client'
    puts '* Pinging ping-o-matic'
    XMLRPC::Client.new('rpc.pingomatic.com', '/').call('weblogUpdates.extendedPing', 'devinhalladay.com' , 'http://devinhalladay.com', 'http://devinhalladay.com/sitemap.xml')
  rescue LoadError
    puts '! Could not ping ping-o-matic, because XMLRPC::Client could not be found.'
  end
end

desc 'Notify Google of the new sitemap'
task :sitemapgoogle do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Google about our sitemap'
    Net::HTTP.get('www.google.com', '/webmasters/tools/ping?sitemap=' + URI.escape('http://devinhalladay.com/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Google about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc 'Notify Bing of the new sitemap'
task :sitemapbing do
  begin
    require 'net/http'
    require 'uri'
    puts '* Pinging Bing about our sitemap'
    Net::HTTP.get('www.bing.com', '/webmaster/ping.aspx?siteMap=' + URI.escape('http://devinhalladay.com/sitemap.xml'))
  rescue LoadError
    puts '! Could not ping Bing about our sitemap, because Net::HTTP or URI could not be found.'
  end
end

desc "Notify various services about new content"
  task :ping => [:pingomatic, :sitemapgoogle, :sitemapbing] do
end
