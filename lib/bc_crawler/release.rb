module BcCrawler

  class Release

    attr_reader :art_fullsize_url, :art_thumb_url, :art_id, :about, :featured_track_id,
                :credits, :artist, :purchase_url, :band_id, :id, :release_date,
                :type, :title, :tracks, :has_audio, :url, :html, :data

    def initialize(url)
      @url = url
      @tracks = []
    end

    # Scan the HTML for a particular JavaScript snippet where a variable named "TralbumData" is assigned.
    # TralbumData contains all information about the release (and its tracks), but has to be cleaned first
    # in order to get a valid JSON object.
    #
    # By default, only the main nodes in TralbumData are crawled. There are more nodes available.
    #
    #   nodes = %w(album_is_preorder album_release_date artFullsizeUrl artist artThumbURL
    #              current defaultPrice featured_track_id FREE freeDownloadPage hasAudio
    #              id initial_track_num is_preorder item_type last_subscription_item
    #              maxPrice minPrice packages PAID playing_from preorder_count trackinfo url)
    def crawl(nodes = %w(artFullsizeUrl artThumbURL current hasAudio trackinfo url))
      puts "Crawling #{@url}"
      @nodes = nodes

      # call the URL, fetch the JavaScript code (TralbumData) and clean the string
      @html = open(@url).read
      js_content = html.gsub(/\n/, '~~')[/var TralbumData = \{(.*?)\};/, 1] # get content of JS variable TralbumData
                       .gsub('~~', "\n")                                  # undo line endings replacement
                       .gsub("\t", '')                                    # remove tabs
                       .gsub("\" + \"", '')                               # special bug in "url" node

      # scan the JavaScript code text for the given nodes
      json_nodes = []
      @nodes.each do |node|
        json_nodes << js_content[/^( )*#{node}( )*:.*$/]                  # fetch current node in JavaScript object
                               .gsub(/#{node}/, "\"#{node}\"")            # add double quotes around node name
                               .gsub(/( )*,( )*$/, '')                    # remove empty lines with comma
      end

      @data = JSON.parse("{ #{ json_nodes.join(', ') } }")

      # Finally, we load the release info
      load_release_info
    end

    # Assign some of the  main information to instance variables
    # TODO: make ALL information available as instance variables
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

    # Tracks have their own class
    def load_track_info
      @data['trackinfo'].each do |track|
        @tracks << Track.new(self, track)
      end
    end

    def to_s
      <<-EOF
      URL : #{ @url }
      Artist : #{ @artist }
      Release title : #{ @title }
      Number of tracks : #{ @tracks.count }
      #{ '(use .crawl method to fetch the missing data)' if @artist.nil? }
      EOF
    end
  end

end