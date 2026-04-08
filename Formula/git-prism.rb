class GitPrism < Formula
  desc "Agent-optimized git data MCP server — structured change manifests and full file snapshots for LLM agents"
  homepage "https://github.com/mikelane/git-prism"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.0/git-prism-aarch64-apple-darwin.tar.xz"
      sha256 "d428413a24a698fd961cdb0d563dac4828a774c40402c52e76fa90c37736134a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.0/git-prism-x86_64-apple-darwin.tar.xz"
      sha256 "6dbc1b3cf9a0f79c6ac92875899d1daaeee010cf31aafeff5b28bf36b23f93ab"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.0/git-prism-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "897256e536068ddf22fcf3be76847eda27c3727908080aa29c0e3dca9eef00b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.0/git-prism-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53f0a8a07d27e49a49961fad2095fd94a12df463183fc8d8399d912ccae6fb06"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "git-prism" if OS.mac? && Hardware::CPU.arm?
    bin.install "git-prism" if OS.mac? && Hardware::CPU.intel?
    bin.install "git-prism" if OS.linux? && Hardware::CPU.arm?
    bin.install "git-prism" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
