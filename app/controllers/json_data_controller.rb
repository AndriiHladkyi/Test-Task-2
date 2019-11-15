class JsonDataController < ApplicationController

  def index
    run JsonData::Index # Просто витягуємо всі дані для початкової сторінки
    render cell(JsonData::Cell::Index, result['data']), layout: false
  end

  def search
    run JsonData::Search, params.to_unsafe_h # Передаємо параметри, а саме поле вводу користувача, для обробки даних
    render cell(JsonData::Cell::Index, result['data']), layout: false
  end
end
