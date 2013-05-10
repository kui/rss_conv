# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'

class ComicHigh < RssConv::Scraper
  URL = "http://webaction.jp/"
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

    webcomics = page.search('#topleft > article')

    date = webcomics.search('> .update')
    title = if date.length.zero? then
      raise "element not found: #topleft > article > .update"
    else
      "#{TITLE} #{date.first.content}"
    end

    digest = Digest::MD5.hexdigest(webcomics.to_html)
    link = "#{URL}##{digest}"

    return [{ :title => title, :link => link, :description => webcomics.to_html}]
  end

  p new.scrape if $0 == __FILE__
end
