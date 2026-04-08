class GitPrism < Formula
  desc "Agent-optimized git data MCP server — structured change manifests and full file snapshots for LLM agents"
  homepage "https://github.com/mikelane/git-prism"
  version "0.3.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.1/git-prism-aarch64-apple-darwin.tar.xz"
      sha256 "311fea4cc84e9ff7411eea2bf0a8b6b9c66d86735a7175b8866c575864c9182e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.1/git-prism-x86_64-apple-darwin.tar.xz"
      sha256 "0c952970c44c3881b321d880b86f152de2d41c6e03da40d4ab62b5b7ee9cbf47"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.1/git-prism-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "475df4a40a00f146577769bfb7229f273b35bc706c4a297ed7afad5917521fc0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/mikelane/git-prism/releases/download/v0.3.1/git-prism-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c0a65b25898ad36252cf9169236ad68fe481c040525f0d0510698d1727f80da9"
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
