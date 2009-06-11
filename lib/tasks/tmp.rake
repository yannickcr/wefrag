namespace :tmp do
  namespace :assets do 
    desc 'Rebuild javascripts/all.js and stylesheets/all.css'
    task :rebuild => :environment do
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::AssetTagHelper
      include ApplicationHelper
      assets = [ 'public/javascripts/all.js', 'public/stylesheets/all.css' ]

      assets.each do |filename|
          FileUtils.remove_file(filename, true)
      end

      styles_and_scripts

      assets.each do |filename|
        if File.exist?(filename)
          all = `java -jar vendor/yuicompressor-2.3.5.jar --nomunge #{filename}`
          file = File.new(filename, 'w+')
          file.write(all)
          file.close
          puts "Built #{filename}"
        end
      end
    end
  end
end
