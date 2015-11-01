# coding: utf-8

# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'
require 'digest/md5'

class YoungAnimalDensi < RssConv::Scraper
  URL = "http://www.younganimal-densi.com/rensai"
  TITLE = "ヤングアニマル Densi"
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
    latest = page.search('.item_area').first
    return nil if latest.nil?

    date = page.search('.date').first
    return nil if date.nil?

    digests = []
    digests << Digest::MD5.hexdigest(latest.content)
    digests << Digest::MD5.hexdigest(date.content)
    hash = "#%s%s" % digests

    [{ :title => date.content,
       :link => URL + hash,
       :description => latest.to_html }]
  end

  p new.scrape if $0 == __FILE__
end
