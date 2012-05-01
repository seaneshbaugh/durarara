require 'spec_helper'

describe "posts/index" do
  before(:each) do
    assign(:posts, [FactoryGirl.create(:post, :subject => "First Post", :body => "This is the first test post."),
                   FactoryGirl.create(:post, :subject => "Second Post", :body => "This is the second test post.")])
    assign(:post, Post.new)
  end

  it "renders a list of posts" do
    render

    assert_select "article.post", :count => 2
    assert_select "div.identicon", :count => 2
    assert_select "h1.subject", :count => 2
    assert_select "div.time", :count => 2
    assert_select "div.name", :count => 2
    assert_select "div.body", :count => 2
  end
end