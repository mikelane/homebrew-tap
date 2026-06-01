class GitPrism < Formula
  desc "Agent-optimized git data MCP server — structured change manifests and full file snapshots for LLM agents"
  homepage "https://github.com/mikelane/git-prism"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.1/git-prism-aarch64-apple-darwin.tar.xz"
      sha256 "3846e6c3da2c66abfb0517f07898ecb2dce2d56e253d0ec967c0f14cac9a9850"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.1/git-prism-x86_64-apple-darwin.tar.xz"
      sha256 "b1bbd1f596c522267e9a6dda05301d221c73cdeebecef6ae3c2710e79bffa03e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.1/git-prism-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0810836db049c02399448ded689058bbdee77b52394b6394cf250c8afd30a17c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.1/git-prism-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "da88c73dda9d766fbf9ffcbf94e91500301a1c426b612dad836f5e8974a348b5"
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
