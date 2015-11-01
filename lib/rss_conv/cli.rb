require "pathname"

module RssConv::Cli

  class << self

    def run
      if ARGV.length != 1
        load_all_scrapers
      else
        load ARGV[0]
      end

      gen = RssConv::Generator.new
      gen.generate_all

      exit 0
    end

    def load_all_scrapers
      lib_path =  Pathname.new(File.expand_path File.dirname __FILE__).parent
      scrapers_path = lib_path.parent.children(true).find do |child|
        child.basename.to_s == "scrapers"
      end
      scrapers_path.children.each do |child|
        if child.extname != ".rb"
          next
        end
        puts "load #{child}"
        load child.to_s
      end
    end

  end
end
