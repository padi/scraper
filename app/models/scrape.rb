require 'open-uri'

class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :release_date, :runtime, :synopsis, :failure

  def scrape_new_movie(url)
    begin
      doc =  Nokogiri::HTML(open(url))
      doc.css('script').remove

      self.title = doc.at("//h1[@itemprop='name']").text
      self.hotness = doc.at("//span[@itemprop='ratingValue']").text
      self.image_url = doc.at("#movie-image-section img")["src"]
      self.rating = doc.at("//td[@itemprop='contentRating']").text
      self.director = doc.at("//span[@itemprop='name']").text
      self.genre = doc.at("//span[@itemprop='genre']").text
      # TODO find updated release date
      # self.release_date = doc.at("//td[@itemprop = 'datePublished']").text.to_date
      self.runtime = doc.at("//time[@itemprop='duration']").text
      s = doc.at("#movieSynopsis").text
      if ! s.valid_encoding?
        s = s.encode("UTF-16be", :invalid=>:replace, :replace=>"?").encode('UTF-8')
      end
      self.synopsis = s
    rescue => e
      self.failure = "Something went wrong with the scrape: #{e.message}"
    end
  end

end
