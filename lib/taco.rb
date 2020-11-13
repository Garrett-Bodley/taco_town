class Taco

    attr_accessor :ingredients
    @@all = []

    def initialize
        @ingredients = []
    end

    def add_ingredient(ingredient)
        @ingredients << ingredient unless @ingredients.include?(ingredient)
    end

    def recipe
        Hash.new.tap do |recipe|
            @ingredients.each {|ingredient| recipe[ingredient.type] = ingredient.name}
        end
    end

    def has_type?(type)
        @ingredients.any?{|ingredient| ingredient.type == type}
    end

    def save
        @@all << self unless @@all.include?(self)
    end

    def self.all
        @@all
    end

    def full?
        @ingredients.count == Ingredient.types.count
    end

    def self.random
        Taco.new.tap do |taco|
            Api.new.get_random.each do |type, info|
                info.each do |title, data|
                    taco.add_ingredient(Ingredient.find_by_type(type).find {|ingredient| ingredient.send("#{title}") == data})
                end
            end
        end
    end
end