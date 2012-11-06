# -*- coding: utf-8 -*-
# RSS の要素には様々なものがあるけれど、今回はこの項目だけサポートしている
class SimpleMock < RssConv::Scraper
  def scrape
    {
      :title => "Mock RSS",
      :description => "this is a mock scraper",
      :link => "http://example.com",
      :items => [
        { :link => "http://example.com/1.html",
          :title => "first item",
          :description => "this is first item of Mock RSS"},
        { :link => "http://example.com/2.html",
          :title => "secound item",
          :description => "this is secound item of Mock RSS"},
      ]
    }
  end
end
