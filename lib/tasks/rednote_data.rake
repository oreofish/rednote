namespace :db do
  desc "Fill database with sample data for rspec unit test"
  task :data => :environment do
    Rake::Task['db:reset'].invoke
    make_users
    make_notes
    make_comments
  end

end

def make_users
  emails = [
    'zhouhuan@redflag-linux.com', 
    'jianxing@redflag-linux.com',
    'sycao@redflag-linux.com',
    'shensuwen@redflag-linux.com',
  ]
  nicknames = [
      'zhou',
      'xing',
      'cao',
      'shen',
  ]
  password = "abc123"
    (0..3).each do |i|
      User.create!(:nickname => nicknames[i],
                   :email => emails[i],
                   :password => password,
                   :password_confirmation => password)
  end
end

def make_notes
    keys = [
        :link,
        :link,
        :image,
        :book,
    ]
  (0..3).each do |i|
    User.all.each do |user|
      values = [
          nil,
          "gogo.redflag-linux.com", #link
          "/images/icons/11.gif",#image
          "no book", #book
    ]
      user.notes.create!( :content => "value=#{values[i]} just test by #{user.nickname}", keys[i] => values[i], :kind => i+1 )
    end
  end
end

def make_comments
  (1..4).each do |i|
      user = User.find(i)
      notes = Note.all
      notes.each do |note|
          note.comments.create!( :comment => "comment note_id=#{note.id} by #{user.nickname}", :commentable_id => note.id, :user_id => user.id)
      end
  end
end
