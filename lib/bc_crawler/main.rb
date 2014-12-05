# BcCrawler (Bandcamp Crawler) can be used to fetch release data
# from a given artist, band or label on bandcamp.com.
# It will fetch the main information such as band name, release name,
# track name, track duration, track number, etc.

module BcCrawler
  class Main
    attr_accessor :releases, :url

    def initialize(url)
      @url        = url
      @releases   = []

      # call the page
      html = open(@url).read
      release_paths = Set.new

      # get all "a" elements that target an /album/... URL
      html.scan(/<a href="\/album\/(.*?)"/).each { |r| release_paths << "/album/#{r.first}" }

      # TODO: implement single tracks, that are not assigned to an album, but directly to the artist

      # initialize the release(s)
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
    <<-EOF
    URL : #{ @url }
    Number of releases : #{ @releases.count }
    EOF
    end
  end

end

