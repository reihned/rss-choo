class Filter < ActiveRecord::Base
   def filter_title_xml
    self.filter_title_hash.to_xml
  end

  def filter_title_hash
    # converting the text keywords to an array of keywords
    keywords = self.keywords.split(/\s/)
    # get the feed as a hash
    feed = self.getfeed_hash

    #filter the channel items and select the ones matching the keywords in the title

    # - first copy the original feed.
    feed_filtered = feed.deep_dup

    # - change the feed filtered by use of select
    feed_filtered["rss"]["channel"]["item"] = feed["rss"]["channel"]["item"].select do |item|
      (item["title"].split(/\s/) - keywords).empty?
    end

    # adjust the feed description
    feed_filtered["rss"]["channel"]["description"].concat(" - filtered by rss-choo")

    #return the filtered hash
    return feed_filtered
  end

  def getfeed_xml
    response = HTTParty.get(self.feed_url)
    return response.body
  end

  def getfeed_hash
    return Hash.from_xml(self.get_feed)
  end
end
