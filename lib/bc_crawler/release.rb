module BcCrawler

  class Release

    attr_reader :art_fullsize_url, :art_thumb_url, :art_id, :about, :featured_track_id,
                :credits, :artist, :purchase_url, :band_id, :id, :release_date,
                :type, :title, :tracks, :has_audio, :url, :html, :data

    # @all_nodes = %w(album_is_preorder album_release_date artFullsizeUrl artist artThumbURL
    #                 current defaultPrice featured_track_id FREE freeDownloadPage hasAudio
    #                 id initial_track_num is_preorder item_type last_subscription_item
    #                 maxPrice minPrice packages PAID playing_from preorder_count trackinfo url)
    def initialize(url, nodes = %w(artFullsizeUrl artThumbURL current hasAudio trackinfo url))
      @url = url
      @nodes = nodes
      @tracks = []
    end

    def crawl
      puts "Crawling #{@url}"
      @html = open(@url).read
      js_content = html.gsub(/\n/, '~~')[/var TralbumData = {(.*?)};/, 1] # get content of JS variable TralbumData
                       .gsub('~~', "\n")                                  # undo line endings replacement
                       .gsub("\t", '')                                    # remove tabs
                       .gsub("\" + \"", '')                               # special bug in "url" node

      json_nodes = []
      @nodes.each do |node|
        json_nodes << js_content[/^( )*#{node}( )*:.*$/]                  # fetch current json node
                               .gsub(/#{node}/, "\"#{node}\"")            # add double quotes around node name
                               .gsub(/( )*,( )*$/, '')                    # remove empty lines with comma
      end

      @data = JSON.parse("{ #{ json_nodes.join(', ') } }")

      load_release_info
    end

    def load_release_info
      @art_fullsize_url   = @data['artFullsizeUrl']
      @art_thumb_url      = @data['artThumbURL']
      @art_id             = @data['current']['art_it']
      @about              = @data['current']['about']
      @featured_track_id  = @data['current']['featured_track_id']
      @credits            = @data['current']['credits']
      @artist             = @data['current']['artist']
      @purchase_url       = @data['current']['purchase_url']
      @band_id            = @data['current']['band_id']
      @id                 = @data['current']['id']
      @release_date       = @data['current']['release_date']
      @type               = @data['current']['type']
      @title              = @data['current']['title']
      @has_audio          = @data['hasAudio']
      load_track_info
    end

    def load_track_info
      @data['trackinfo'].each do |track|
        @tracks << Track.new(self, track)
      end
    end

    def to_s
      <<-EOF
          URL : #{@url}
          Data : #{@data}
      EOF
    end
  end

end