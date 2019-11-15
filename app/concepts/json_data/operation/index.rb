class JsonData < ApplicationRecord
  class Index < Trailblazer::Operation
    step :first

    def initialize
      json = File.read('data.json')
      @data = JSON.parse(json)
    end

    def first(options, *)
      options["data"] = @data # Передаємо всі значення з файлу
    end
  end
end