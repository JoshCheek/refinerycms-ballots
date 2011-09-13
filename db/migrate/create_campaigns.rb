class CreateCampaigns < ActiveRecord::Migration

  def self.up
    create_table :campaigns do |t|
      t.string :title
      t.integer :position

      t.timestamps
    end

    add_index :campaigns, :id

    load(Rails.root.join('db', 'seeds', 'campaigns.rb'))
  end

  def self.down
    if defined?(UserPlugin)
      UserPlugin.destroy_all({:name => "campaigns"})
    end

    if defined?(Page)
      Page.delete_all({:link_url => "/campaigns"})
    end

    drop_table :campaigns
  end

end
