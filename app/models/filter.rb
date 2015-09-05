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

    # - first copy the original feed. this dup is for debug purposes and can be removed in a refactor
    feed_filtered = feed.deep_dup

    # - change the feed filtered by use of select
    keywords.each do |keyword|
      feed_filtered["rss"]["channel"]["item"] = feed_filtered["rss"]["channel"]["item"].select do |item|
        item["title"].include?(keyword)
      end
    end

    # adjust the feed description
    unless( feed_filtered["rss"]["channel"]["description"] )
      feed["rss"]["channel"]["description"] = "filtered by rss-choo"
    else
      feed_filtered["rss"]["channel"]["description"].concat(" - filtered by rss-choo")
    end

    #return the filtered hash
    return feed_filtered
  end

  def getfeed_xml
    response = HTTParty.get(self.feed_url)
    return response.body
  end

  def getfeed_hash
    return Hash.from_xml(self.getfeed_xml)
  end
end
