# -*- coding: utf-8 -*-

require 'rss_conv'
require 'rubygems'
require 'mechanize'

class AnimateTvRadio < RssConv::Scraper
  RADIO_URL = "http://www.animate.tv/radio/"
  TITLE = "アニメイト TV ウェブラジオ"
  DESCRIPTION = "アニメの事ならアニメイトTV！声優/アニメニュース・アニメ動画・声優ラジオ・PV配信などアニメに関する情報が満載です！"

  attr_reader :title, :link, :description

  def initialize
    @title = TITLE
    @link = RADIO_URL
    @description = DESCRIPTION
  end

  def scrape
    agent = Mechanize.new
    page = agent.get RADIO_URL
    radio_list = page.search('#new .contents_block_A').to_a
    radio_list.map! do |r|
      t = r.search('.title a').first
      if t == nil
        next nil
      end

      {
        :title => t.inner_text,
        :link => t.attr('href'),
        :description => r.to_html
      }
    end

    radio_list
  end
end

if $0 == __FILE__
  AnimateTvRadio.new.scrape
end
