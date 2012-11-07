# -*- coding: utf-8 -*-
# RSS の要素には様々なものがあるけれど、今回はこの項目だけサポートしている
class SimpleMock < RssConv::Scraper

  attr_reader :title, :description, :link

  def initialize
    @title = "Mock RSS"
    @description = "this is a mock scraper"
    @link = "http://example.com"
  end

  def scrape
    [
      { :link => "http://example.com/1.html",
        :title => "first item",
        :description => "<p>this is first item of Mock RSS</p>"},
      { :link => "http://example.com/2.html",
        :title => "secound item",
        :description => "<p>this is secound item of Mock RSS</p>"},
    ]
  end
end
