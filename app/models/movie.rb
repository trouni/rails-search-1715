class Movie < ApplicationRecord
  belongs_to :director

  # SQL Implementation
  def self.search(query)
    sql_query = <<~SQL
      title @@ :q OR
      synopsis @@ :q OR
      directors.first_name @@ :q OR
      directors.last_name @@ :q
    SQL

    Movie.joins(:director).where(sql_query, q: "%#{query}%")
  end
end
