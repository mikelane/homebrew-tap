class GitPrism < Formula
  desc "Agent-optimized git data MCP server — structured change manifests and full file snapshots for LLM agents"
  homepage "https://github.com/mikelane/git-prism"
  version "0.9.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.2/git-prism-aarch64-apple-darwin.tar.xz"
      sha256 "ed43ac81b6d4c1deaee611e52321890689bccb0cb44e9b09141f226891b177a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.2/git-prism-x86_64-apple-darwin.tar.xz"
      sha256 "dccdba5052a182858ee944e8558216f00a0d2f27b174cba4fbd7022faebd5829"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.2/git-prism-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b31951e202c1fdc7137bb5597898508ae1800c6c36a8f318bdf1c3ab5e305fa5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.9.2/git-prism-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5a73afd2a00f11d6658389eccfed3a5b2b50efdef4f7635d26845f0a31795370"
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
