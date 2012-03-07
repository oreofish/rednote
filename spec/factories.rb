# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.email                 "hzj@redflag-linux.com"
  user.nickname              "hzj"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.define :note do |note|
  note.summary              "foobar content"
  note.message              0
  note.kind                 1
  note.description          "foobar title"
  note.association          :user
end

Factory.define :task do |task|
  task.content              "foobar content"
  task.association          :user
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :summary do |n|
  "summary#{n}"
end

Factory.sequence :content do |n|
  "content-#{n}"
end

Factory.define :book do |book|
  book.title                 "me"
  book.url                   "www.baidu.com"
  book.cover                 "foobar"
  book.user_id               1
end
