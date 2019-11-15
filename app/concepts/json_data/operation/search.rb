require 'json'

class JsonData < ApplicationRecord
  class Search < Trailblazer::Operation
    step :my_initialize
    step :search

    attr_accessor :search_field, :result, :negative_words
    attr_reader :data

    # Так і не зрозумів чому не можу провести стандартну ініціалізацію, тому створив свою, яку викликаю в першу чергу

    def  my_initialize(options, *)
      @search_field = options["params"]["search_values"].split.flatten # Отримуємо дані, які ввів користувач і розбиваємо на масив
      json = File.read('data.json')
      @data = JSON.parse(json) # Зчитуємо файл в змінну
      @result = [] # Створюємо змінну для запису результату
      @negative_words = check_negative_words # Витягуємо слова, які починаються на "-", тобто мінус слова
    end

    def search(options, *)
      data.each do |note|
        note.each do |key, value|
          result << note if check_avail(value) # Записуємо в результат запис, якщо рядок підходить по параметрах
        end
      end
      options["data"] = result.uniq # Вивід результату
    end

    def check_negative_words # Пошук мінус слів
      words = []
      search_field.each do |v|
        if '-' == v[0]
          words << v[1..-1]
          search_field.delete(v)
        end
      end
      words
    end

    def check_avail(value)
      negative_words.each do |word|
        return false if value.downcase.include?(word.downcase) # Перевіряємо в першу чергу чи немає мінус слів, бо якщо є, немає сенсу продовжувати
      end

      search_values = search_field.dup # Назначаємо змінній копію масиву, який дістався нам від користувача
      search_field.each do |search_value|
        search_values.delete(search_value) if value.downcase.include?(search_value.downcase) # Видаляємо значення з масиву, якщо вони попадаються в стрічці з файла
      end

      search_values.empty? # Якщо в масиві немає більше значень, значить співпали всі слова і ми повертаємо true, якщо ж залишились слова - то false
    end

  end
end