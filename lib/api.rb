class Api

    ENDPOINT = "http://taco-randomizer.herokuapp.com/"
    MASTER = "https://raw.github.com/sinker/tacofancy/master/"

    # gets a random taco and returns a list of ingredients
    
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