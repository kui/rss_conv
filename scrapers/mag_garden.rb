# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'
require 'digest/md5'

class MagGarden < RssConv::Scraper
  URL = "http://comic.mag-garden.co.jp/"
  TITLE = "マッグガーデン コミックオンライン"
  DESCRIPTION = "#{TITLE} 更新情報"

  UPDATE_URLS = [
    'http://comic.mag-garden.co.jp/blade/',
    # 'http://comic.mag-garden.co.jp/eden/',
    # 'http://comic.mag-garden.co.jp/beats/',
  ]

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new
    UPDATE_URLS.map do |url|
      page = agent.get(url)
      page.search('a.cbox-main').map do |comic|
        comic_link = comic.attr(:href)
        comic_page = agent.get(comic_link)
        title = comic_page.title
        desc = comic_page.search('.article-head-main').to_html
        digest = Digest::SHA512.hexdigest(desc)
        { :title => title,
          :link => "#{comic_link}##{digest}",
          :description => desc }
      end
    end.flatten
  end

  p new.scrape if $0 == __FILE__
end
