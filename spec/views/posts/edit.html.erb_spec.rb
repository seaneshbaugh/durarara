require 'spec_helper'

describe "posts/edit" do
  before(:each) do
    @post = assign(:post, stub_model(Post,
      :subject => "MyString",
      :body => "MyText",
      :ip_address => "MyString",
      :name => "MyString"
    ))
  end

  it "renders the edit post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path(@post), :method => "post" do
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_body", :name => "post[body]"
      assert_select "input#post_ip_address", :name => "post[ip_address]"
      assert_select "input#post_name", :name => "post[name]"
    end
  end
end
