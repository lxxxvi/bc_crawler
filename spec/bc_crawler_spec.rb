require 'spec_helper'

describe BcCrawler do

  before(:all) do
    @test_release_url = 'http://amandapalmer.bandcamp.com/album/amanda-palmer-performs-the-popular-hits-of-radiohead-on-her-magical-ukulele'
  end

  it 'returns the base url' do
    base_url = BcCrawler::Helper.get_base_url('https://abc.bandcamp.com/album/of-the-year')
    expect(base_url).to eq('https://abc.bandcamp.com/')
  end

  it 'crawls the main page' do
    main_page = BcCrawler::Main.new('http://amandapalmer.bandcamp.com/')
    expect(main_page.releases.count).to be > 0
  end

  it 'crawls the release page' do
    album_page = BcCrawler::Release.new(@test_release_url)
    album_page.crawl
    expect(album_page.title).to eq('Amanda Palmer Performs The Popular Hits Of Radiohead On Her Magical Ukulele')
  end

  it 'stores the trackinfo' do
    album_page = BcCrawler::Release.new(@test_release_url)
    album_page.crawl
    expect(album_page.tracks.first.track_num).to be == 1
  end
end