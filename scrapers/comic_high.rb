# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'

class ComicHigh < RssConv::Scraper
  URL = "http://comichigh.jp/webcomic.html"
  TITLE = "WEB コミック ハイ！"
  DESCRIPTION = TITLE

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new
    page = agent.get URL

    page.search('.webcomic').to_a.each.map do |item|

      # title
      id = item.attr 'id'
      titles = item.search '.comictitle'
      title =
        if titles.length > 0 then titles.first.inner_html
        elsif id then id
        end
      next nil if title.nil?

      # link
      link = nil
      links = item.search '.comic_list_new a'
      link =
        if links.length > 0 then links.first.attr 'href'
        elsif not id.nil? then "#{URL}\##{id}"
        end
      next nil if link.nil?

      { :title => title, :link => link, :description => item.to_html}
    end.each.reject do |item|
      item == nil
    end
  end

  new.scrape if $0 == __FILE__
end
