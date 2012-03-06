# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.email                 "hzj@redflag-linux.com"
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

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :summary do |n|
  "summary#{n}"
end
