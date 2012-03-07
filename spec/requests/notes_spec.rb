# encoding: utf-8

require 'spec_helper'

describe "Notes" do
  Capybara.default_selector = :css
  Capybara.javascript_driver = :webkit
  self.use_transactional_fixtures = false

  before :each do
    @user = Factory(:user)
    visit "/users/sign_in"
    fill_in "user_login",    :with => "#{@user.nickname}"
    fill_in "user_password", :with => "#{@user.password}"
    click_button "登录"

    #post "/users/sign_in", "user[nickname]" => @user.nickname, "user[password]" => @user.password
    #post_via_redirect user_session_path, "user[nickname]" => @user.nickname, "user[password]" => @user.password
  end

  describe "Sanity check" do
    it "should redirect to / afte login" do
      current_path.should == "/"
    end

    it "should have create note div" do
      page.should have_css("div#note_publish")
    end 

    it "should default tab is 'message'" do
      page.should have_selector("button", :text => "发布")
    end 

    it "should default tab is 'message'" do
      find("div#message")[:class].should eq('tab-pane fade active in')
      find("div#image")[:class].should eq('tab-pane fade')
    end 

    it "should switch to it when click 'image' tab", :js => true do
      within(:css, "div#note_publish") do
        all('a').each do |a|
          if a[:href] == '#image'
            a.click
          end
        end

        #find('a', :href => '#image').click
        find("div#image")[:class].should eq('tab-pane fade active in')
        find("div#message")[:class].should eq('tab-pane fade')
      end
    end

  end

  describe "When creating note", :js => true do
    before :each do
      within(:css, 'div#message') do
        fill_in "note_summary", :with => "msg@"
        click_button "发布"
      end
    end

    it "should create message note and appear in the list" do
      within(:css, 'div#notes_content') do
        first('li').should have_content('msg@')
      end
    end

    it "should reset boxes after creating note" do
      within(:css, 'div#message') do
        find('#note_summary').text.should eq('')
      end
    end

    it "should disappear after delete the note" do
      within(:css, 'div#notes_content') do
        first('li').all('a').each do |a|
          if a['data-method'] == "delete"
            # HACK: don't know how to invoke popup for webkit driver
            # for selenium: page.driver.browser.switch_to.alert.accept
            page.evaluate_script('window.confirm = function() { return true; }')
            a.click
          end
        end
      end
     
      # use find to wait for li to disapper
      Capybara.using_wait_time(3) do 
        find('div#notes_content').should have_no_selector('li')
      end
    end

    it "should display comments when comments_link clicked" do
      within(:css, "li#note1") do
        find('a[class="comments_link"]').click
        find('div.comments_list').should be_visible
      end
    end

  end # describe

  describe "Create image note", :js => true do
    before :each do
      within(:css, "div#note_publish") do
        all('a').each do |a|
          if a[:href] == '#image'
            a.click
          end
        end
      end 
    end

    it "should create image note and appear in the list" do
      within(:css, 'div#image') do
        fill_in "note_summary", :with => "image@"
        attach_file 'note_upload', "public/images/avatar.jpg"
        click_button "发布"
      end

      within(:css, 'div#notes_content') do
        first('li').should have_content('image@')
        first('li').should have_selector('div#attach_collapse1')
        first('li').should have_selector('img')
      end
    end

    it "should fail without image" do
      within(:css, 'div#image') do
        fill_in "note_summary", :with => "image@@"
        click_button "发布"
      end

      within(:css, "div[class='flash']") do
        find("div")[:class].should eq('alert alert-block alert-error fade in')
      end      
    end
  end # describe

  describe "notes list", :js => true do
    before :each do
      within(:css, 'div#message') do
        fill_in "note_summary", :with => "msg@"
        click_button "发布"
      end

      find('div#notes_content').should have_selector('li')

      within(:css, 'div#message') do
        fill_in "note_summary", :with => "msg@@"
        click_button "发布"
      end

    end

    it "should exist" do
      find('div#notes_content').should have_selector('li', :count => 2)
    end

    it "should response to comments_link" do
      within(:css, "div#notes_content") do
        [1,2].each do |id|
          find("li#note#{id}").find('a[class="comments_link"]')[:href].should eq("/comments?note_id=#{id}")
        end
      end
    end

    it "should display comments when comments_link clicked" do
      within(:css, "div#notes_content") do
        within(:css, "li#note1") do
          find('div.comments_list').should_not be_visible
          find('a[class="comments_link"]').click
          find('div.comments_list').should be_visible
        end
      end
    end
  end # describe

end

