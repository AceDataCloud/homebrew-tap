class AcedatacloudCli < Formula
  include Language::Python::Virtualenv

  desc "Generate media, search the web and retrieve Ace Data Cloud tasks"
  homepage "https://github.com/AceDataCloud/AceDataCloudCli"
  url "https://files.pythonhosted.org/packages/f3/3f/921183cd70c00f1d204356cc2bd4f471d9a9dc287773c8c8551513ebb509/acedatacloud_cli-2026.11.27.3.tar.gz"
  sha256 "17361d641b3a3048f53225cd628670c4b43a38fa0a7275be01b57970115724f0"
  license "MIT"

  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/9a/d5/b4d2c4d397b7c0222635cd069098f232fb5cba31f6749e77b339e263b52c/httpx-0.29.0.tar.gz"
    sha256 "700928ee6c1f4213795e67c47eba8f8553639069fea89199f71d654e38edc593"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      For API calls, configure your key with `adc auth login`.
      Manage application keys at https://platform.acedata.cloud/console/applications?utm_source=homebrew&utm_medium=referral&utm_campaign=evergreen
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/adc --version")
    images = shell_output("#{bin}/adc image --help")
    assert_match "nano-banana", images
    assert_match "gpt-image", images
    videos = shell_output("#{bin}/adc video --help")
    assert_match "seedance", videos
    assert_match "kling", videos
    assert_match "acemusic", shell_output("#{bin}/adc services")
    packages = JSON.parse(shell_output("#{bin}/adc packages suno --json"))
    assert_includes packages.fetch("services").map { |service| service.fetch("slug") }, "suno"
  end
end
