module BcCrawler
  class Helper
    def self.get_base_url(url)
      url[/https?:\/\/(.*?)\//]
    end
  end
end