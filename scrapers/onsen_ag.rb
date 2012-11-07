# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'

class OnsenAg < RssConv::Scraper
  RADIO_URL = "http://onsen.ag/"
  TITLE = "インターネットラジオステーション 音泉"
  DESCRIPTION = "インターネットラジオステーション＜音泉＞はアニメ・ゲーム・声優系を中心としたラジオを配信するサイトです。"

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = RADIO_URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new do |a|
      a.user_agent = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_0 like Mac OS X; ja-jp) "+
        "AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 "+
        "Safari/7875.18.5"
    end
    page = agent.get RADIO_URL
    list = page.search('div.title').to_a
    list.map! do |title|
      content = title.next.next.next.next
      link = content.search('.detail_btn form').first.attr('action') rescue StandardError
      { :title => title.content,
        :link => link,
        :description => title.to_html+content.to_html}
    end

    list
  end
end

if $0 == __FILE__
  OnsenAg.new.scrape
end
