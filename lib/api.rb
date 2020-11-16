class Api
    ENDPOINT = "http://taco-randomizer.herokuapp.com/"
    
    def get_request(query="random")
        url = "#{ENDPOINT}" + "#{query}/"
        uri = URI.parse(url)
        response = Net::HTTP.get(uri)
    end

    def search_by_type(slug=nil)
        JSON.parse(get_request(slug + "s"))
    end

    def get_random
        JSON.parse(get_request)
    end
end