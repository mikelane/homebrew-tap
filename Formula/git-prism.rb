class GitPrism < Formula
  desc "Agent-optimized git data MCP server — structured change manifests and full file snapshots for LLM agents"
  homepage "https://github.com/mikelane/git-prism"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.2.0/git-prism-aarch64-apple-darwin.tar.xz"
      sha256 "355dabb0e20f13774e44e3338a9edea27ac164805f95de5cdc78653cff7ceb76"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.2.0/git-prism-x86_64-apple-darwin.tar.xz"
      sha256 "cb5d92736626b8c29d52a05739cdd1b32bbe27559f20df6f8a95245dd6bfa2dd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.2.0/git-prism-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d9668def9eb0167a8b86c213d5e3b81d6ac29c9b63b7f1fb4a5b353ef2edaec"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.2.0/git-prism-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d72ff66013dff258dbc89b2379e4c8957b32e41813bae09ee66a23537e692a71"
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
