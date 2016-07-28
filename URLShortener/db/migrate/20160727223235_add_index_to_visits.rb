class AddIndexToVisits < ActiveRecord::Migration
  def change
    add_index(:visits, [:visitor_id, :shortened_url_id])
  end
end
