activate :livereload
activate :autoprefixer

set :markdown_engine, :redcarpet

activate :external_pipeline,
  name: :webpack,
  command: build? ?  "yarn run build" : "yarn run start",
  source: ".tmp/dist",
  latency: 1

# Set custom asset directories.
set :css_dir, "assets/css"
set :js_dir, "assets/js"
set :images_dir, "assets/images"
set :fonts_dir, "assets/fonts"

# Activate Blog
activate :blog do |b|
  b.sources = "posts/{year}-{month}-{day}-{title}.html"
  b.taglink = "concepts/{tag}.html"
  b.tag_template = "concept.html"
  b.permalink = "posts/{title}"
  b.name = @app.data.site.title
  b.layout = "post"
end

# Activate directory indexes for clean URLs
activate :directory_indexes

# Layouts
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/', layout: 'default_layout'
page '/posts/*', layout: 'post'

config[:sass_source_maps] = true

# Configure asset builds
configure :build do
  # "Ignore" JS so webpack has full control.
  ignore { |path| path =~ /\/(.*)\.js$/ && $1 != 'site' }

  activate :minify_css
  activate :minify_javascript
end

helpers do
  def nav_link(link, path, opts={})
    if current_page.url == path
      opts[:class] = "menu-link active"
    else
      opts[:class] = "menu-link"
    end
    link_to(link, path, opts)
  end
end

# Deploy settings
activate :deploy do |deploy|
  deploy.deploy_method = :rsync
  deploy.host   = '162.243.103.246'
  deploy.user   = 'root'
  deploy.path   = '/var/www/infinitecaesura.com/public_html'
  # Set deploy.port to define a port for the deploy server. Defaults to 22.
  deploy.clean = true # removes orphaned files on remote host, default: false
  deploy.flags = '--omit-dir-times -davz'
end
