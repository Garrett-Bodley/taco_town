class Ingredient

    attr_reader :type
    @@all = []

    def initialize(type:, ingredient:)
        @type = type
        ingredient.each do |key, value|
            self.class.attr_accessor(key)
            self.send("#{key}=", value)
        end
        @@all << self
    end

    def self.load
        Api.new.tap do |api|
            api.get_random.each_key do |type|
                api.search_by_type(type).each {|ingredient| Ingredient.new(type: type, ingredient: ingredient)}
            end
        end
    end

    def self.all
        @@all
    end
    
    def self.find_by_type(type)
        self.all.select {|ingredient| ingredient.type == type}
    end

    def self.types
        self.all.map {|ingredient| ingredient.type}.uniq
    end

end