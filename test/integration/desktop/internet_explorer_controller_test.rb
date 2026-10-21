require "test_helper"

class Desktop::InternetExplorerControllerTest < ActionDispatch::IntegrationTest
  test "with nothing to browse it's a blank page" do
    get desktop_internet_explorer_url

    assert_select "turbo-frame#internet-explorer .address-bar input[readonly][value=?]", "about:blank"
    assert_select ".page", text: ""
    assert_select ".status a", count: 0
  end

  test "browses to a post at its real address" do
    get desktop_internet_explorer_url(post: posts(:one))

    assert_select ".address-bar input[value=?]", post_url(posts(:one))
    assert_select ".status a[href=?]", post_url(posts(:one)), text: "Open full page"
  end

  test "shows a post as its page does" do
    get desktop_internet_explorer_url(post: posts(:one))

    assert_select ".page h1", text: "Post 1"
    assert_select ".page .lede", text: "Summary 1"
    assert_select ".page .prose", text: /Content 1/
  end

  test "browses to a project at its real address" do
    get desktop_internet_explorer_url(project: projects(:one))

    assert_select ".address-bar input[value=?]", project_url(projects(:one))
    assert_select ".status a[href=?]", project_url(projects(:one)), text: "Open full page"
  end

  test "shows a project as its page does" do
    get desktop_internet_explorer_url(project: projects(:one))

    assert_select ".page h1", text: "Proejct 1"
    assert_select ".page a.button[href=?]", projects(:one).repo_url
    assert_select ".page .prose", text: /Project details/
  end

  test "File > Close closes the window" do
    get desktop_internet_explorer_url

    assert_select "#internet-explorer-file-menu form[method=dialog] button", text: "Close"
  end

  test "talks, drafts, and missing projects aren't found" do
    get desktop_internet_explorer_url(post: posts(:three))

    assert_response :not_found

    get desktop_internet_explorer_url(post: posts(:unpublished_post))

    assert_response :not_found

    get desktop_internet_explorer_url(project: "0-missing")

    assert_response :not_found
  end
end
