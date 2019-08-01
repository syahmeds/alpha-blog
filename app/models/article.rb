class Article < ApplicationRecord
  belongs_to :user
  validates :title, presence: true, length: { minimum: 3, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 300 }
  validates :user_id, presence: true

  def self.user_articles(userid)
    Article.find_by_sql <<-SQL
      SELECT * FROM articles WHERE user_id = #{userid}
    SQL
  end

  def self.sorted_latest_articles(following)
    Article.find_by_sql <<-SQL
                  select * from (select * from (select articles.*, dense_rank() over(partition by articles.user_id 
                  order by articles.updated_at desc) as t_rank from articles where articles.user_id 
                  in (#{following.nil? || following.empty? ? 'NULL': following.join(',')})) as latest_articles 
                  order by latest_articles.updated_at desc) as sorted_latest_articles where t_rank <= 1
    SQL
  end

end