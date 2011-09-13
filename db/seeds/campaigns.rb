if defined?(User)
  User.all.each do |user|
    if user.plugins.where(:name => 'campaigns').blank?
      user.plugins.create(:name => 'campaigns',
                          :position => (user.plugins.maximum(:position) || -1) +1)
    end
  end
end

if defined?(Page)
  page = Page.create(
    :title => 'Campaigns',
    :link_url => '/campaigns',
    :deletable => false,
    :position => ((Page.maximum(:position, :conditions => {:parent_id => nil}) || -1)+1),
    :menu_match => '^/campaigns(\/|\/.+?|)$'
  )
  Page.default_parts.each do |default_page_part|
    page.parts.create(:title => default_page_part, :body => nil)
  end
end