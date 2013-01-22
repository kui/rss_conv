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
    'http://comic.mag-garden.co.jp/eden/',
    'http://comic.mag-garden.co.jp/beats/',
  ]

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new
    UPDATE_URLS.each.map do |url|
      page = agent.get url rescue StandardError

      main_box = page.search('.mainBox').first
      next nil if main_box.nil?

      title = main_box.search('h4').first
      next nil if title.nil?
      title = title.content

      title_digest = '#' + Digest::MD5.hexdigest(title)

      { :title => title, :link => (url + title_digest), :description => main_box.to_html }
    end.each.reject {|i| i.nil? }
  end

  p new.scrape if $0 == __FILE__
end
