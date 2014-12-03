# BcCrawler

A simple Ruby Gem to crawl bandcamp.com sites. It will load information about the artist/label/band, their releases (albums) and all tracks.

## Installation

Add this line to your application's Gemfile:

    gem 'bc_crawler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bc_crawler

## Usage

### Crawl an artist/label/band

```ruby
require 'bc_crawler'

main = BcCrawler::Main.new('https://amandapalmer.bandcamp.com/')
 => URL: https://amandapalmer.bandcamp.com/

main.releases.first
 =>  URL : https://amandapalmer.bandcamp.com//album/an-evening-with-neil-gaiman-and-amanda-palmer
    Data :
```

Initially, the data attribute is empty, because only the "main"-page has been crawled.

### Crawl a release

```ruby
main.releases.first.crawl

main.releases.first
 =>  URL : https://amandapalmer.bandcamp.com//album/an-evening-with-neil-gaiman-and-amanda-palmer
    Data : { Hash }
```

### Crawl all releases from an artist/label/band at once

```ruby
main.crawl
# Crawling https://amandapalmer.bandcamp.com//album/an-evening-with-neil-gaiman-and-amanda-palmer
# Crawling https://amandapalmer.bandcamp.com//album/theatre-is-evil-2
# Crawling https://amandapalmer.bandcamp.com//album/amanda-palmer-goes-down-under
# Crawling https://amandapalmer.bandcamp.com//album/amanda-palmer-performs-the-popular-hits-of-radiohead-on-her-magical-ukulele
# Crawling https://amandapalmer.bandcamp.com//album/nighty-night
# Crawling https://amandapalmer.bandcamp.com//album/who-killed-amanda-palmer
# Crawling https://amandapalmer.bandcamp.com//album/who-killed-amanda-palmer-alternate-tracks
# Crawling https://amandapalmer.bandcamp.com//album/map-of-tasmania-the-remix-project
# Crawling https://amandapalmer.bandcamp.com//album/7-series-part-3
```

Certain information about releases and tracks can directly be accessed by attributes.

### Release information

```ruby
release = main.releases.first

release.artist
 => "Neil Gaiman and Amanda Palmer"

release.band_id
 => 3463798201

release.type
 => "album"

release.title
 => "An Evening With Neil Gaiman and Amanda Palmer"

release.id              # "Relase ID"
 => 3510389344

release.release_date
 => "19 Nov 2013 00:00:00 GMT"

release.featured_track_id
 => 658956410

release.about
 => nil

release.credits
 => nil

release.art_fullsize_url
 => "https://f1.bcbits.com/img/a3489132960_10.jpg"

release.art_thumb_url
 => "https://f1.bcbits.com/img/a3489132960_3.jpg"

release.art_id
 => nil

release.has_audio
 => true

release.purchase_url
 => nil
```

A release holds one track or more in an array. Each track has these attributes

### Track information
```ruby
random_track = release.tracks[rand(0..release.tracks.count)]

random_track.id         # "Track ID"
 => 658956410

random_track.track_num
 => 32

random_track.title
 => "Judy Blume"

random_track.duration
 => 395.093

random_track.url
 => "https://amandapalmer.bandcamp.com//track/judy-blume-2"

random_track.is_downloadable
 => true

random_track.streaming
 => 1

random_track.file
 => {"mp3-128"=>"http://popplers5.bandcamp.com/download/track?enc=mp3-128&fsig=6667d236f0f0128472b2d505feb8f43a&id=658956410&stream=1&ts=1417597933.0"}

random_track.is_draft
 => false

random_track.title_link
 => "/track/judy-blume-2"
```


If the information above is not enough, you can access the entire data object from Bandcamp in the release.data attribute

release.data structure
```JSON
{
  "artFullsizeUrl": "https://f1.bcbits.com/img/a3489132960_10.jpg",
  "artThumbURL": "https://f1.bcbits.com/img/a3489132960_3.jpg",
  "current": {
      "is_set_price": null,
      "purchase_title": null,
      "minimum_price_nonzero": 10,
      "killed": null,
      "publish_date": "07 Nov 2013 15:27:37 GMT",
      "mod_date": "22 Nov 2013 20:01:15 GMT",
      "art_id": 3489132960,
      "minimum_price": 10,
      "featured_track_id": 658956410,
      "auto_repriced": null,
      "require_email": null,
      "download_pref": 2,
      "title": "An Evening With Neil Gaiman and Amanda Palmer",
      "new_desc_format": 1,
      "about": null,
      "require_email_0": null,
      "private": null,
      "artist": "Neil Gaiman and Amanda Palmer",
      "id": 3510389344,
      "band_id": 3463798201,
      "credits": null,
      "upc": null,
      "set_price": 7,
      "new_date": "07 Nov 2013 14:50:34 GMT",
      "type": "album",
      "purchase_url": null,
      "release_date": "19 Nov 2013 00:00:00 GMT",
      "download_desc_id": null
  },
  "hasAudio": true,
  "trackinfo": [
    "(all tracks go here... see "trackinfo")"
  ],
  "url": "http://amandapalmer.bandcamp.com/album/an-evening-with-neil-gaiman-and-amanda-palmer"
}
```

Assuming you want the "minimum_price" of a release
```ruby
release.data['current']['minimum_price']
 => 10.0
```

The "trackinfo" in release.data looks like this
```JSON
{
    "video_poster_url": null,
    "is_draft": false,
    "title_link": "/track/my-last-landlady-3",
    "download_tooltip": "",
    "video_caption": null,
    "has_lyrics": false,
    "sizeof_lyrics": 0,
    "duration": 391.821,
    "license_type": 1,
    "video_featured": null,
    "has_info": false,
    "title": "My Last Landlady",
    "video_source_type": null,
    "track_num": 1,
    "private": null,
    "alt_link": null,
    "video_id": null,
    "is_downloadable": false,
    "video_source_id": null,
    "lyrics": null,
    "album_preorder": false,
    "id": 1844797083,
    "encoding_error": null,
    "has_free_download": null,
    "video_mobile_url": null,
    "streaming": 1,
    "unreleased_track": false,
    "file": {
        "mp3-128": "http://popplers5.bandcamp.com/download/track?enc=mp3-128&fsig=25ddaa2b8fa8a008562e4e0c6efc2eff&id=1844797083&stream=1&ts=1417597933.0"
    },
    "encoding_pending": null,
    "free_album_download": false,
    "encodings_id": 3584714018
}
```

Assuming you want to know if the first track of a release "has_lyrics":

```ruby
    release.data['trackinfo'][0]['has_lyrics']
     => false
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/bc_crawler/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
