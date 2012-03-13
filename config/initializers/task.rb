require 'rubygems'
require 'rufus/scheduler'
scheduler = Rufus::Scheduler.start_new

scheduler.cron '0 17 * * 2' do
  Book.all.each {|p| p.status = "keep"; p.save!}
  Debit.all.first
end

#scheduler.cron '31 17 * * 1' do
#  books = Book.find_by_sql("SELECT books.* FROM books WHERE status='keep' ")
#  books.each do |book|
#    debits = Debit.find_by_sql("SELECT debits.* FROM debits WHERE book_id=#{book.id}")
#    if debits.first != nil
#      debits.first.destroy
#    end
#  end
#end
