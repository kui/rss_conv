# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'

class TsutayaDiscasComic < RssConv::Scraper
  RADIO_URL = "http://www.discas.net/netdvd/topComic.do"
  TITLE = "TSUTAYA DISCAS コミックレンタル"
  DESCRIPTION = TITLE

  MAX_PAGE = 10

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = RADIO_URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new

    list = []

    1.upto(MAX_PAGE).each do |i|
      page = get_page(agent, i)
      list.concat(extract_comic_list page)
    end

    list
  end

  private

  LIST_URL = "http://search.discas.net/netdvd/comic/searchComic.do?sk=1&pT=4&srt=7&kj=0&u=0&t=2&p=62&dm=2&pl=1&af=1&pn=%s"

  def get_page agent, i
    url = LIST_URL % i
    puts "fetch #{url}"
    agent.get url
  end

  def extract_comic_list page
    page.search('table[width="600"]').to_a.each.map do |i|
      link = i.search('a').first
      next nil if link == nil

      title = i.search('a > span.tx01').first
      next nil if title == nil

      genre = i.search('span.tx01 > a').first
      next nil if genre == nil

      { :title => title.content,
        :link => link.attr('href'),
        :genre => genre.content,
        :description => i.to_html}
    end.each.reject do |i|
      i == nil or exclude?(i)
    end
  end

  def exclude? item
    item[:genre].match(/少女コミック|ボーイズラブコミック|レディースコミック/)
  end

  new.scrape if $0 == __FILE__
end
