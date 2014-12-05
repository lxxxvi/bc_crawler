module BcCrawler
  class Track

    attr_reader :duration, :track_num, :is_downloadable, :streaming,
                :is_draft, :id, :title_link, :file, :title, :url

    def initialize(release, track)
      @release            = release
      @duration           = track['duration']
      @track_num          = track['track_num']
      @is_downloadable    = track['is_downloadable']
      @streaming          = track['streaming']
      @is_draft           = track['is_draft']
      @id                 = track['id']
      @title_link         = track['title_link']
      @file               = track['file']
      @title              = track['title']
      @url                = "#{ BcCrawler::Helper.get_base_url(@release.url) }#{ track['title_link'] }"
    end

    def to_s
      <<-EOF
      URL : #{ @url }
      Track number : #{ @track_num }
      Track name : #{ @title }
      Duration : #{ @duration }
      EOF
    end
  end
end