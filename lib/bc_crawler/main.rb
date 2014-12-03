# BcCrawler (Bandcamp Crawler) can be used to fetch release data
# from a given artist, band or label.
# It will fetch the main information such as band name, release name,
# track name, track duration, track number, etc.

# Crawls the main page of an artist/band/label
module BcCrawler
  class Main
    attr_accessor :releases, :url

    def initialize(url)
      @url        = url
      @releases   = []

      html = open(@url).read
      release_paths = Set.new

      # get all "a" elements that target an /album/... URL
      html.scan(/<a href="\/album\/(.*?)"/).each { |r| release_paths << "/album/#{r.first}" }

      # create the releases
      release_paths.each do |path|
        @releases << BcCrawler::Release.new("#{ @url }#{ path }")
      end

    end

    def crawl
      # fetch information about the release
      @releases.each do |release|
        release.crawl
      end
    end

    def to_s
      "URL: #{ @url }"
    end
  end

end

