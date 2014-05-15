require 'nokogiri'
require 'open-uri'
require 'rss/maker'


doc = Nokogiri::HTML(open("http://blogs.scientificamerican.com/tetrapod-zoology/"))


rss = RSS::Maker.make("2.0") do |m|
    m.channel.title = "Tetrapod Zoology"
    m.channel.author = "Darren Naish"
    m.channel.updated = Time.now.to_s
    m.channel.link = "http://blogs.scientificamerican.com/tetrapod-zoology/"
    m.channel.description = "This is a temporary feed for the Tetrapod Zoology blog, hosted at Scientific American and written by Darren Naish. Currently, the Scientific American RSS feed is non-functional, thus the need for this feed."
    m.items.do_sort = true

    for post in doc.css('div.blogPost2')

        m.items.new_item do |item|
            item.title = post.xpath(".//h1[@id = 'postTitle2']/a[1]/@title").to_s.sub(/^Permanent Link to /, "")
            item.link = post.xpath(".//h1[@id = 'postTitle2']/a[1]/@href").to_s
            item.guid.content = item.link
            item.guid.isPermaLink = true
            item.updated = post.xpath(".//span[@class = 'datestamp']/text()").to_s
            item.author = 'Darren Naish'
            item.content_encoded = post.xpath(".//div[@id = 'singleBlogPost']/p[1]/text()").to_s
        end

    end

end

puts rss

