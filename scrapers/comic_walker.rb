# coding: utf-8

# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'
require 'digest/md5'

class ComicWalker < RssConv::Scraper
  URL = "http://comic-walker.com/contents/newer"
  TITLE = "ComicWalker"
  DESCRIPTION = "#{TITLE} 更新情報"

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new
    page = agent.get URL
    latest = page.search('#magazine_list').first
    return nil if latest.nil?

    # 遅延読み込みインジケータgifの差し替え
    latest.search('img.lazy').each do |img|
      if not img['data-original']
        next
      end
      img['src'] = img['data-original']
    end

    digest = Digest::MD5.hexdigest(latest.content)
    [{ :title => TITLE,
       :link => URL + "##{digest}",
       :description => latest.to_html }]
  end

  p new.scrape if $0 == __FILE__
end
