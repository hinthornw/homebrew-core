class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Shiny new formula"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/13/f4/e60c465ddc4d6fbfd6a9c002bbd491a747b4cbfa92db0e5c76245bfd5c97/langgraph_cli-0.1.52.tar.gz"
  sha256 "210eea115772df982408366b0aad06d226e6ea3752e8784c3ce99f388b2d07c9"

  depends_on "python3"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_create(libexec, "python3")
    virtualenv_install_with_resources
  end

  test do
    false
  end
end
