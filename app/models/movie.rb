class Movie < ApplicationRecord
  belongs_to :director

  # PgSearch Implementation
  include PgSearch::Model
  multisearchable against: [:title, :synopsis]

  pg_search_scope :search, # This creates a Movie.search class method (aka scope)
    against: [:title, :synopsis],
    associated_against: {
      director: [:first_name, :last_name]
    },
    using: { tsearch: { prefix: true } }

  # SQL Implementation
  def self.sql_search(query)
    sql_query = <<~SQL
      title @@ :q OR
      synopsis @@ :q OR
      directors.first_name @@ :q OR
      directors.last_name @@ :q
    SQL

    Movie.joins(:director).where(sql_query, q: "%#{query}%")
  end
end
