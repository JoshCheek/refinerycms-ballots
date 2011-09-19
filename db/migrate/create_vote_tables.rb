class CreateVoteTables < ActiveRecord::Migration
  def self.up
    create_table :ballot_votes do |t|
      t.references :member
      t.references :ballot
      t.timestamps
    end
    
    create_table :office_votes do |t|
      t.references :ballot_vote
      t.references :office
    end
    
    create_table :candidate_votes do |t|
      t.references :office_vote
      t.references :candidate
    end
  end
  
  def self.down
    [:ballot_votes, :office_votes, :candidate_votes].each do |table_name|
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
