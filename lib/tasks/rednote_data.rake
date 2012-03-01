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
  emails = [ 'zhouhuan@redflag-linux.com', 
             'jianxing@redflag-linux.com',
             'sycao@redflag-linux.com',
             'shensuwen@redflag-linux.com',
           ]
  nicknames = [ 'zhou',
                'xing',
                'cao',
                'shen',
              ]
  password = "abc123"

  avatar = File.open('public/images/avatar.jpg')

  (0..3).each do |i|
      User.create!(:nickname => nicknames[i],
                   :email => emails[i],
                   :avatar => avatar,
                   :preview => avatar,
                   :password => password,
                   :password_confirmation => password
                  )
  end
end

def make_notes
  (0..3).each do |i|
    User.all.each do |user|
      values = [
                "some text",
                "gogo.redflag-linux.com", #link
                "/images/icons/11.gif",#image
                "C\nprint(\"Hello world.\");", #code
               ]
      user.notes.create!( :summary => "value=#{values[i]} just test by #{user.nickname}",
                          :description => values[i],
                          :kind => i+1
                          )
    end
  end
end

def make_comments
  User.all.each do |user|
    notes = Note.all
    notes.each do |note|
      user.comments.create!( :comment => "comment note_id=#{note.id} by #{user.nickname}",
                             :commentable_id => note.id
                             )
    end
  end
end
