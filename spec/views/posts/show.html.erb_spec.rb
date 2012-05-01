require 'spec_helper'

describe "posts/show" do
  before(:each) do
    @post = assign(:post, FactoryGirl.create(:post))
  end

  it "shows the contents of a post" do
    render

    assert_select "article#post-#{@post.id}"
    assert_select "article.post"
    assert_select "div.identicon"
    assert_select "h1.subject"
    assert_select "div.time"
    assert_select "div.name"
    assert_select "div.body"
  end
end
