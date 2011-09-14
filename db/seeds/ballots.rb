if defined?(User)
  User.all.each do |user|
    if user.plugins.where(:name => 'ballots').blank?
      user.plugins.create(:name => 'ballots',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(Page)
  page = Page.create(
    :title => 'Ballots',
    :link_url => '/ballots',
    :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/ballots(\/|\/.+?|)$',
    :show_in_menu => false,
  )
  Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end