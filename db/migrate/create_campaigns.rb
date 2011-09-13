class CreateCampaigns < ActiveRecord::Migration

  def self.up
    create_table :campaigns do |t|
      t.string      :title
      t.integer     :position
      t.timestamps
    end
    
    create_table :offices do |t|
      t.string      :title
      t.references  :campaign
      t.integer     :position
      t.timestamps
    end

    create_table :candidates do |t|
      t.string      :name
      t.references  :office
      t.integer     :position
      t.timestamps
    end


    add_index :campaigns  , :id
    add_index :offices    , :id
    add_index :candidates , :id

    load(Rails.root.join('db', 'seeds', 'campaigns.rb'))
  end

  def self.down
    [:campaigns, :offices, :candidates].each do |table_name|
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

