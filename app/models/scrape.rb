class Scrape
  attr_accessor :title, :hotness, :image_url, :rating, :director, :genre, :release_date, :runtime, :synopsis, :failure

  def scrape_new_movie
    begin
      doc =  Nokogiri::HTML(open("http://www.rottentomatoes.com/m/the_martian/"))
      doc.css('script').remove

      self.title = doc.at("//h1[@itemprop='name']").text
      self.hotness = doc.at("//span[@itemprop='ratingValue']").text
      self.image_url = doc.at("#movie-image-section img")["src"]
      self.rating = doc.at("//td[@itemprop='contentRating']").text
      self.director = doc.at("//span[@itemprop='name']").text
      self.genre = doc.at("//span[@itemprop='genre']").text
      self.runtime = doc.at("//time[@itemprop='duration']").text
      self.synopsis =  doc.at("#movieSynopsis").text
    rescue => e
      self.failure = "Something went wrong with the scrape: #{e.message}"
    end
  end

end
