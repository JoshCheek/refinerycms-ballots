class CreateBallots < ActiveRecord::Migration

  def self.up
    create_table :ballots do |t|
      t.string      :title
      t.integer     :position
      t.datetime    :start_date
      t.datetime    :end_date
      t.timestamps
    end
    
    create_table :offices do |t|
      t.string      :title
      t.integer     :number_of_positions, :default => 1
      t.references  :ballot
      t.integer     :position
      t.timestamps
    end

    create_table :candidates do |t|
      t.string      :name
      t.references  :office
      t.integer     :position
      t.timestamps
    end


    add_index :ballots    , :id
    add_index :offices    , :id
    add_index :candidates , :id

    load(Rails.root.join('db', 'seeds', 'ballots.rb'))
  end

  def self.down
    [:ballots, :offices, :candidates].each do |table_name|
      if defined?(UserPlugin)
        UserPlugin.destroy_all :name => table_name.to_s
      end

      if defined?(Page)
        Page.delete_all :link_url => "/#{table_name}"
      end
      
      drop_table table_name
    end
  end

end

