###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  # usage <%= inline_svg("logo"); %> assuming logo.svg is stored at source/images/logo.svg
 def inline_svg(filename, options = {})
   asset = "source/images/#{filename}.svg"

   if File.exists?(asset)
     file = File.open(asset, 'r') { |f| f.read }
     css_class = options[:class]
     return file if css_class.nil?

     document = Oga.parse_xml(file)
     svg      = document.css('svg').first

     svg.set(:class, css_class)

     document.to_xml
   else
     %(
       <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 30"
         width="400px" height="30px"
       >
         <text font-size="16" x="8" y="20" fill="#cc0000">
           Error: '#{filename}' could not be found.
           Looked in: '#{asset}'
         </text>
         <rect
           x="1" y="1" width="398" height="28" fill="none"
           stroke-width="1" stroke="#cc0000"
         />
       </svg>
     )
   end
 end
end

# Use relative URLs
activate :relative_assets
set :relative_links, true

# Build-specific configuration
configure :build do
  activate :autoprefixer

  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Minify HTML on build
  activate :minify_html
end

activate :deploy do |deploy|
  deploy.deploy_method = :git
  # Optional Settings
  # deploy.remote   = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch   = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule      # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message'      # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
  deploy.build_before = true
end
