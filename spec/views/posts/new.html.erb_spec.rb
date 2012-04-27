require 'spec_helper'

describe "posts/new" do
  before(:each) do
    assign(:post, stub_model(Post,
      :subject => "MyString",
      :body => "MyText",
      :ip_address => "MyString",
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new post form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => posts_path, :method => "post" do
      assert_select "input#post_subject", :name => "post[subject]"
      assert_select "textarea#post_body", :name => "post[body]"
      assert_select "input#post_ip_address", :name => "post[ip_address]"
      assert_select "input#post_name", :name => "post[name]"
    end
  end
end
