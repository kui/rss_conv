require "rss"
require "pathname"
require "time"
require 'digest/md5'

class RssConv::Generator

  RSS_VERSION = "2.0"
  PROJECT_PAGE = "https://github.com/kui/rss_conv"

  def initialize
    @scrapers = get_scrapers
    @rdfs_path = get_rdfs_path
  end

  def generate_all
    @scrapers.each do |scraper|
      feed =
        begin
          scraper.scrape
        rescue => e
          feed_for_err e, scraper
        end
      feed ||= feed_for_nil scraper

      rss = convert_to_rss scraper, feed
      if rss == nil
        puts "ignore #{scraper.class} (cannot generate rss)"
        next
      end

      file_name = "#{scraper.class.to_s}.rdf"
      file_path = @rdfs_path.join file_name
      file_path.open('w') {|f| f.write rss}
      puts "generate #{file_path}"
    end
  end

  private

  def feed_for_err err, scraper
    h = "#%s%s%s" % [scraper.title, err.to_s, Time.now.to_s].map{|s| Digest::MD5.hexdigest(s)}
    [{:title => err.class, :link => PROJECT_PAGE + h, :description => err.to_s }]
  end

  def feed_for_nil scraper
    h = "#%s%s" % [scraper.title, Time.now.to_s].map{|s| Digest::MD5.hexdigest(s)}
    [{:title => err.class, :link => PROJECT_PAGE + h, :description => err.to_s }]
  end

  def convert_to_rss scraper, feed
    RSS::Maker.make RSS_VERSION do |maker|
      maker.channel.pubDate = Time.now.rfc822

      [:title, :description, :link].each do |n|
        v = nil
        begin
          v = scraper.send n
        rescue NoMethodError => e
          puts e
          return nil
        end
        maker.channel.send "#{n}=", v
      end

      feed.each do |i|
        rss_item = maker.items.new_item
        [:title, :link, :description].each do |n|
          rss_item.send "#{n}=", i[n]
        end
      end
    end
  end

  def get_scrapers
    scrapers = Object.constants
    scrapers.map! do |clazz_name|
      Object.const_get clazz_name
    end
    scrapers.reject! do |clazz|
      clazz.class != Class
    end
    scrapers.reject! do |clazz|
      clazz > RssConv::Scraper
    end
    scrapers.reject! do |clazz|
      not clazz.method_defined? :scrape
    end
    scrapers.map! do |clazz|
      clazz.new
    end

    scrapers
  end

  def get_rdfs_path
    lib_path =  Pathname.new(File.expand_path File.dirname __FILE__).parent
    lib_path.parent.children(true).find do |child|
      child.basename.to_s == "rdfs"
    end
  end

end
